

import 'dart:async';
import 'dart:developer';

import 'package:fara_chat/data/database/database.dart';
import 'package:fara_chat/data/repositories/chat_repository.dart';
import 'package:fara_chat/providers/chats/chats_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messages_view_model.g.dart';

@riverpod
class MessagesViewModel extends _$MessagesViewModel {
  late final ChatRepository _chatRepository;
  StreamSubscription<dynamic>? _messagesSubscription;
    Timer? debounceTimer;


  @override
  Future<List<Message>> build(String chatId) async {
    _chatRepository = ref.read(chatRepositoryProvider);
        // Initial load
    final messagesList = await _loadMessagesFromLocal(chatId);

       // Set up subscription to messages updates
    _setupMessagesSubscription(chatId);

      // Clean up subscription when provider is disposed
    ref.onDispose(() {
      _messagesSubscription?.cancel();
      _messagesSubscription?.cancel();

    });

    return messagesList;
  }

    /// Loads the list of messages with associated chatId
  Future<List<Message>> _loadMessagesFromLocal(String chatId) async {
    try {
      // Get messages from local database
      return await _chatRepository.getMessages(chatId);
    } catch (e) {
      // Re-throw to be caught by AsyncValue
      throw Exception('Failed to load messages: $e');
    }
  }

    /// Sets up subscription to chat updates
  void _setupMessagesSubscription(String chatId) {
    _messagesSubscription?.cancel();

    // Create a debounce timer
    List<Message>? lastMessages;

    _messagesSubscription = _chatRepository.watchMessages(chatId).listen((messages) {
      log('_setupMessagesSubscription event received: ${messages.length} messages');

      // Check if the data is actually different
      final bool isDifferent = lastMessages == null ||
          lastMessages!.length != messages.length ||
          !_areChatsEqual(lastMessages!, messages);

      if (!isDifferent) {
        log('Skipping duplicate chat update');
        return;
      }

      lastMessages = List.of(messages);

      // Cancel previous timer if it exists
      debounceTimer?.cancel();

      // Set a new timer
      debounceTimer = Timer(const Duration(milliseconds: 500), () async {
        try {
          final messagesList = await _loadMessagesFromLocal(chatId);
          state = AsyncValue.data(messagesList);
        } catch (e) {
          log('Error updating chats: $e');
        }
      });
    });
  }

  // Helper method to compare chat lists
  bool _areChatsEqual(List<Message> list1, List<Message> list2) {
    if (list1.length != list2.length) return false;

    // Simple comparison using IDs and lastMessageAt
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].id != list2[i].id ||
          list1[i].createdAt != list2[i].createdAt) {
        return true;
      }
    }

    return true;
  }

}