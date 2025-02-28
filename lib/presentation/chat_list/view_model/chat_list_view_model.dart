import 'dart:async';
import 'package:fara_chat/data/database/database.dart';
import 'package:fara_chat/data/repositories/chat_repository.dart';
import 'package:fara_chat/providers/chats/chats_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_list_view_model.g.dart';

@riverpod
class ChatListViewModel extends _$ChatListViewModel {
  late final ChatRepository _chatRepository;
  StreamSubscription<dynamic>? _chatSubscription;

  @override
  Future<List<(Chat, User)>> build() async {
    _chatRepository = ref.watch(chatRepositoryProvider);
    
    // Initial load
    final chatsList = await _loadChats();
    
    // Set up subscription to chat updates
    _setupChatSubscription();
    
    // Clean up subscription when provider is disposed
    ref.onDispose(() {
      _chatSubscription?.cancel();
    });
    
    return chatsList;
  }

  /// Loads the list of chats with associated users
  Future<List<(Chat, User)>> _loadChats() async {
    try {
      // Get chats from local database
      final chats = await _chatRepository.getChats();
      
      // Fetch users for each chat
      final chatUserPairs = <(Chat, User)>[];
      
      for (final chat in chats) {
        // For direct chats (assuming 2 users per chat), get the other user
        final otherUserId = await _getOtherUserId(chat);
        if (otherUserId != null) {
          final otherUser = await _chatRepository.getUserById(otherUserId);
          if (otherUser != null) {
            chatUserPairs.add((chat, otherUser));
          }
        }
      }
      
      return chatUserPairs;
    } catch (e) {
      // Re-throw to be caught by AsyncValue
      throw Exception('Failed to load chats: $e');
    }
  }

  /// Sets up subscription to chat updates
  void _setupChatSubscription() {
    _chatSubscription?.cancel();
    _chatSubscription = _chatRepository.watchChats().listen((chats) {
      // When chats update, refresh the state
      refresh();
    });
  }

  /// Gets the ID of the other user in a chat
  Future<String?> _getOtherUserId(Chat chat) async {
    final currentUserId = _chatRepository.currentUserId;
    final userIds = await _chatRepository.getChatUserIds(chat.id);
    
    // Find the other user in the chat
    return userIds.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '', // Return empty string if not found
    );
  }

  /// Refreshes the chat list manually
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    
    try {
      // Sync with server first
      await _chatRepository.syncChats();
      
      // Then load from local database
      final chatsList = await _loadChats();
      state = AsyncValue.data(chatsList);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Deletes a chat
  Future<void> deleteChat(String chatId) async {
    try {
      await _chatRepository.deleteChat(chatId);
      
      // Refresh state after deletion
      await refresh();
    } catch (e) {
      // Handle error, possibly updating state with an error
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Creates a new chat with a user
  Future<String?> createChat(String userId) async {
    try {
      final chatId = await _chatRepository.createChat([userId]);
      
      // Refresh the chat list after creating a new chat
      await refresh();
      
      return chatId;
    } catch (e) {
      // Handle error, update state?
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }
}