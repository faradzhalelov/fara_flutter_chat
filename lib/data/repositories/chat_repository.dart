import 'dart:async';
import 'dart:developer';
import 'package:fara_chat/core/supabase/supabase_service.dart';
import 'package:fara_chat/core/utils/extensions/database_extensions.dart';
import 'package:fara_chat/data/database/database.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;

class ChatRepository {

  ChatRepository(this._db);
  final AppDatabase _db;

  /// Get the current user's ID
  String get currentUserId => supabase.auth.currentUser?.id ?? '';
  final List<supabase_flutter.RealtimeChannel> _subscriptions = [];

  /// Initialize the repository
  Future<void> initialize() async {
    await syncUsers();
    await syncChats();
    setupRealtimeSync();
  }

  /// Sync users from Supabase to local DB
  Future<void> syncUsers() async {
    try {
      // Get users from current user's chats
      final response = await supabase.from('users').select();

      // Transform and upsert to local DB
      for (final user in response) {
        await _db.upsertUser(user.toUser());
      }
    } catch (e) {
      log('Error syncing users: $e');
    }
  }

  /// Sync all chats from Supabase to local DB
  Future<void> syncChats() async {
    try {
      final userId = currentUserId;
      if (userId.isEmpty) return;

      // Get chats for current user
      final response =
          await supabase.from('chats').select().contains('user_ids', [userId]);

      // Transform and upsert to local DB
      for (final chatData in response) {
        await _db.upsertChat(chatData.toChat());
      }

      // Sync messages for each chat
      for (final chat in response) {
        await syncChatMessages(chat['id'] as  String);
      }
    } catch (e) {
      log('Error syncing chats: $e');
    }
  }

  /// Sync messages for a specific chat
  Future<void> syncChatMessages(String chatId) async {
    try {
      // Get messages for chat
      final response = await supabase
          .from('messages')
          .select()
          .eq('chat_id', chatId)
          .order('created_at');

      // Transform and upsert to local DB
      for (final messageData in response) {
        await _db.upsertMessage(messageData.toMessage());
      }
    } catch (e) {
      log('Error syncing messages for chat $chatId: $e');
    }
  }

  /// Set up realtime subscriptions
  void setupRealtimeSync() {
    final userId = currentUserId;
    if (userId.isEmpty) return;

    // Create a single channel for both tables
    final channel = supabase.channel('db-changes');

    // Configure the channel for chat changes
    channel.onPostgresChanges(
      event: supabase_flutter.PostgresChangeEvent.all,
      schema: 'public',
      table: 'chats',
      filter: supabase_flutter.PostgresChangeFilter(
        type: supabase_flutter.PostgresChangeFilterType.inFilter,
        column: 'user_ids',
        value: [userId],
      ),
      callback: (payload) async {
        if (payload.eventType == supabase_flutter.PostgresChangeEvent.insert || payload.eventType == supabase_flutter.PostgresChangeEvent.update) {
          final chatData = payload.newRecord;
          await _db.upsertChat(chatData.toChat());
        } else if (payload.eventType == supabase_flutter.PostgresChangeEvent.update) {
          final chatId = payload.oldRecord['id'] as  String;
          await _db.deleteChat(chatId);
        }
      },
    );

    // Configure the channel for message changes
    channel.onPostgresChanges(
      event: supabase_flutter.PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      callback: (payload) async {
        final messageData = payload.newRecord;
        final chatId = messageData['chat_id'] as String;

        // Check if this message belongs to one of our chats
        final chat = await _db.getChatById(chatId);
        if (chat != null) {
          // Update local DB with new message
          await _db.upsertMessage(messageData.toMessage());
        }
      },
    );

    // Subscribe to the channel
    final subscription = channel.subscribe();
    _subscriptions.add(subscription);
  }

  /// Get all chats for the current user from local database
  Future<List<Chat>> getChats() async {
    try {
      return await _db.getAllChats();
    } catch (e) {
      log('Error getting chats: $e');
      return [];
    }
  }

  /// Watch chats for changes (returns a stream)
  Stream<List<Chat>> watchChats() => _db.watchAllChats();

  /// Get a specific chat by ID
  Future<Chat?> getChatById(String chatId) async => _db.getChatById(chatId);

  /// Get user IDs for a chat
  Future<List<String>> getChatUserIds(String chatId) async {
    final chat = await _db.getChatById(chatId);
    return chat?.userIds ?? [];
  }

  /// Get a user by ID
  Future<User?> getUserById(String userId) async => _db.getUserById(userId);

  /// Search users by username or email
  Future<List<User>> searchUsers(String query) async {
    try {
      final currentId = currentUserId;
      if (query.isEmpty) return [];

      // Search from Supabase
      final response = await supabase
          .from('users')
          .select()
          .neq('id', currentId)
          .or('username.ilike.%$query%,email.ilike.%$query%')
          .limit(20);

      // Convert to User models
      final users = response
          .map<User>((userData) => User(
                id: userData['id'] as String,
                email: userData['email'] as String ,
                username: userData['username'] as String,
                avatarUrl: userData['avatar_url'] as String?,
                isOnline: userData['is_online'] as bool? ?? false,
              ),)
          .toList();

      // Also save to local database
      for (final user in users) {
        await _db.upsertUser(user);
      }

      return users;
    } catch (e) {
      log('Error searching users: $e');
      throw Exception('Failed to search users: $e');
    }
  }

  /// Create a new chat with selected users
  Future<String> createChat(List<String> userIds) async {
    final userId = currentUserId;
    if (userId.isEmpty) throw Exception('User not authenticated');

    // Make sure current user is included
    if (!userIds.contains(userId)) {
      userIds.add(userId);
    }

    // Check if chat already exists (for direct chats)
    if (userIds.length == 2) {
      final existingChats = await _db.getAllChats();
      for (final chat in existingChats) {
        final chatUserIds = chat.userIds;
        if (chatUserIds.length == 2 &&
            chatUserIds.contains(userIds[0]) &&
            chatUserIds.contains(userIds[1])) {
          return chat.id;
        }
      }
    }

    try {
      // Create chat in Supabase
      final response = await supabase
          .from('chats')
          .insert({
            'user_ids': userIds,
            'name': null, // Direct chats typically don't have names
          })
          .select('id')
          .single();

      final chatId = response['id'] as String;

      // Get full chat data
      final chatData =
          await supabase.from('chats').select().eq('id', chatId).single();

      // Store in local DB
      await _db.upsertChat(chatData.toChat());

      return chatId;
    } catch (e) {
      log('Error creating chat: $e');
      throw Exception('Failed to create chat: $e');
    }
  }

  /// Delete a chat
  Future<void> deleteChat(String chatId) async {
    try {
      // Delete from Supabase
      await supabase.from('chats').delete().eq('id', chatId);

      // Delete from local DB
      await _db.deleteChat(chatId);
    } catch (e) {
      log('Error deleting chat: $e');
      throw Exception('Failed to delete chat: $e');
    }
  }

  /// Send a message
  Future<void> sendMessage({
    required String chatId,
    required String content,
    String type = 'text',
    String? fileUrl,
  }) async {
    final userId = currentUserId;
    if (userId.isEmpty) throw Exception('User not authenticated');

    try {
      // Create message in Supabase
      final response = await supabase
          .from('messages')
          .insert({
            'chat_id': chatId,
            'user_id': userId,
            'content': content,
            'type': type,
            'file_url': fileUrl,
          })
          .select()
          .single();

      // Update local DB
      await _db.upsertMessage(response.toMessage());
    } catch (e) {
      log('Error sending message: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  /// Clean up resources
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.unsubscribe();
    }
    _subscriptions.clear();
  }
}
