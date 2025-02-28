import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:fara_chat/core/supabase/supabase_service.dart';
import 'package:fara_chat/core/utils/extensions/extensions.dart';
import 'package:fara_chat/data/database/database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRepository {

  ChatRepository(this._db);

  final AppDatabase _db;
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  String get currentUserId => supabase.auth.currentUser?.id ?? '';

  // Initialize sync process
  Future<void> initialize() async {
    await syncUsers();
    await syncChats();
    setupRealtimeSync();
  }

  // Sync users from Supabase to local DB
  Future<void> syncUsers() async {
    try {
      // Get users from current user's chats
      final response = await supabase.from('users').select();
      
      // Transform into Drift companions
      final usersList = response.map<UsersCompanion>(
        (user) => user.toUserCompanion(),
      ).toList();
      
      // Upsert users to local DB
      await _db.upsertUsers(usersList);
    } catch (e) {
      log('Error syncing users: $e');
    }
  }

  // Sync all chats from Supabase to local DB
  Future<void> syncChats() async {
    try {
      final userId = currentUserId;
      if (userId.isEmpty) return;
      
      // Get chats for current user
      final response = await supabase
        .from('chats')
        .select()
        .contains('user_ids', [userId]);
      
      // Transform into Drift companions
      final chatsList = response.map<ChatsCompanion>(
        (chat) => chat.toChatCompanion(),
      ).toList();
      
      // Upsert chats to local DB
      await _db.upsertChats(chatsList);
      
      // Sync messages for each chat
      for (final chat in response) {
        await syncChatMessages(chat['id'] as String);
      }
    } catch (e) {
      log('Error syncing chats: $e');
    }
  }

  // Sync messages for a specific chat
  Future<void> syncChatMessages(String chatId) async {
    try {
      // Get messages for chat
      final response = await supabase
        .from('messages')
        .select()
        .eq('chat_id', chatId)
        .order('created_at');
      
      // Transform into Drift companions
      final messagesList = response.map<MessagesCompanion>(
        (message) => message.toMessageCompanion(),
      ).toList();
      
      // Upsert messages to local DB
      await _db.upsertMessages(messagesList);
    } catch (e) {
      log('Error syncing messages for chat $chatId: $e');
    }
  }

  // Set up realtime subscriptions
  void setupRealtimeSync() {
    final userId = currentUserId;
    if (userId.isEmpty) return;
    
    // Listen for chat updates
    final chatChannel = supabase.channel('public:chats');
    final chatSubscription = chatChannel.on(
      RealtimeListenTypes.postgresChanges,
      SupabaseRealtimePayload(
        schema: 'public',
        table: 'chats',
        filter: 'user_ids=cs.{$userId}',
      ),
      (payload, [ref]) async {
        if (payload.eventType == 'INSERT' || payload.eventType == 'UPDATE') {
          final chatData = payload.newRecord as Map<String, dynamic>;
          await _db.upsertChat(chatData.toChatCompanion());
        } else if (payload.eventType == 'DELETE') {
          final chatId = payload.oldRecord['id'];
          await _db.deleteChat(chatId as String);
        }
      },
    ).subscribe();
    
    _subscriptions.add(chatSubscription);
    
    // Listen for message updates
    final messageChannel = supabase.channel('public:messages');
    final messageSubscription = messageChannel.on(
      RealtimeListenTypes.postgresChanges,
      SupabaseRealtimePayload(
        schema: 'public',
        table: 'messages',
        event: 'INSERT',
      ),
      (payload, [ref]) async {
        if (payload.eventType == 'INSERT') {
          final messageData = payload.newRecord as Map<String, dynamic>;
          final chatId = messageData['chat_id'];
          
          // Check if this message belongs to one of our chats
          final chat = await _db.getChatById(chatId as String);
          if (chat != null) {
            // Update local DB with new message
            await _db.upsertMessage(messageData.toMessageCompanion());
          }
        }
      },
    ).subscribe();
    
    _subscriptions.add(messageSubscription);
  }
  
  // Create a new chat
  Future<String> createChat(List<String> userIds, {String? name}) async {
    final userId = currentUserId;
    if (userId.isEmpty) throw Exception('User not authenticated');
    
    // Make sure current user is included
    if (!userIds.contains(userId)) {
      userIds.add(userId);
    }
    
    // Create chat in Supabase
    final response = await supabase.from('chats').insert({
      'user_ids': userIds,
      'name': name,
    }).select('id').single();
    
    final chatId = response['id'] as String;
    
    // Get full chat data
    final chatData = await supabase
      .from('chats')
      .select()
      .eq('id', chatId)
      .single();
    
    // Store in local DB
    await _db.upsertChat(chatData.toChatCompanion());
    
    return chatId;
  }
  
  // Send a message
  Future<void> sendMessage({
    required String chatId,
    required String content,
    String type = 'text',
    String? fileUrl,
  }) async {
    final userId = currentUserId;
    if (userId.isEmpty) throw Exception('User not authenticated');
    
    // Create message in Supabase
    final response = await supabase.from('messages').insert({
      'chat_id': chatId,
      'user_id': userId,
      'content': content,
      'type': type,
      'file_url': fileUrl,
    }).select().single();
    
    // Store in local DB
    await _db.upsertMessage(response.toMessageCompanion());
  }
  
  // Get user info
  Future<Map<String, dynamic>> getChatUserInfo(String chatId) async {
    final userId = currentUserId;
    final chat = await _db.getChatById(chatId);
    
    if (chat == null) {
      throw Exception('Chat not found');
    }
    
    // Parse user IDs
    final userIdsList = json.decode(chat.userIds) as List;
    
    // For direct chats, get the other user's info
    if (userIdsList.length == 2) {
      final otherUserId = userIdsList.firstWhere(
        (id) => id != userId, 
        orElse: () => userId,
      );
      
      final otherUser = await _db.getUserById(otherUserId as String);
      
      if (otherUser != null) {
        return {
          'name': chat.name ?? otherUser.username,
          'avatar_url': otherUser.avatarUrl,
          'is_online': otherUser.isOnline,
          'other_user_id': otherUserId,
        };
      }
    }
    
    // For group chats or if other user not found
    return {
      'name': chat.name ?? 'Chat',
      'avatar_url': null,
      'is_online': false,
      'other_user_id': null,
    };
  }

  // Clean up subscriptions
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
}