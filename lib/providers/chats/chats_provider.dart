import 'dart:convert';
import 'package:fara_chat/data/database/database.dart';
import 'package:fara_chat/data/models/chat_model.dart';
import 'package:fara_chat/data/repositories/chat_repository.dart';
import 'package:fara_chat/providers/auth/auth_provider.dart';
import 'package:fara_chat/providers/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chats_provider.g.dart';

@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) {
  final database = ref.watch(driftDatabaseProvider);
  final repository = ChatRepository(database);
  
  ref.onDispose(() => repository.dispose());
  
  return repository;
}

@riverpod
class ChatsNotifier extends _$ChatsNotifier {
  @override
  Stream<List<ChatModel>> build() {
    final currentUser = ref.watch(authNotifierProvider).valueOrNull;
    
    if (currentUser == null) {
      return Stream.value([]);
    }
    
    // Initialize chat sync
    Future.microtask(() async {
      final repository = ref.read(chatRepositoryProvider);
      await repository.initialize();
    });
    
    // Return stream from local database
    return ref.watch(driftDatabaseProvider)
        .watchAllChats()
        .map((chats) => _mapChatsToModels(chats, currentUser.id));
  }
  
  List<ChatModel> _mapChatsToModels(List<Chat> chats, String currentUserId) => chats.map((chat) {
      // Parse user IDs
      final userIds = jsonDecode(chat.userIds) as List;
      final userIdsList = userIds.cast<String>();
      
      // Check if the last message is from current user
      final isLastMessageMine = chat.lastMessageUserId == currentUserId;
      
      return ChatModel(
        id: chat.id,
        name: chat.name,
        createdAt: chat.createdAt,
        updatedAt: chat.updatedAt,
        userIds: userIdsList,
        lastMessageText: chat.lastMessageText,
        lastMessageUserId: chat.lastMessageUserId,
        lastMessageType: chat.lastMessageType,
        lastMessageAt: chat.lastMessageAt,
        isLastMessageMine: isLastMessageMine,
      );
    }).toList();
  
  Future<void> refreshChats() async {
    final repository = ref.read(chatRepositoryProvider);
    await repository.syncChats();
  }
  
  Future<String> createChat(List<String> userIds, {String? name}) async {
    final repository = ref.read(chatRepositoryProvider);
    return await repository.createChat(userIds, name: name);
  }
}