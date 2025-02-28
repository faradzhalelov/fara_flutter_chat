// features/chat_list/presentation/view_models/chat_list_view_model.dart
import 'dart:async';
import 'dart:developer';

import 'package:fara_chat/core/supabase/supabase_service.dart';
import 'package:fara_chat/data/database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_list_view_model.g.dart';

@riverpod
class ChatListViewModel extends _$ChatListViewModel {
  @override
  Stream<List<(Chat, User)>> build() async* {
    //
    final userId = supabase.auth.currentUser!.id;
    //sync chats
    await _syncChats();
    //
   // final chatsDao = ref.read(chatsDaoProvider);
    //
    // final channel = supabase
    //     .channel('chat_updates_$userId')
    //     .onPostgresChanges(
    //         event: PostgresChangeEvent.all,
    //         schema: 'public',
    //         table: 'chats',
    //         callback: (payload) {
    //           //
    //           log('payload new:${payload.newRecord} old:${payload.oldRecord}');
    //           //
    //           final eventType = payload.eventType;
    //           switch (eventType) {
    //             case PostgresChangeEvent.all:
    //               log('all:');
    //             case PostgresChangeEvent.insert:
    //               log('insert');
    //             case PostgresChangeEvent.update:
    //               log('update');
    //             case PostgresChangeEvent.delete:
    //               log('delete');
    //           }
    //         })
    //     .subscribe();
    // ref.onDispose(() {
    //   channel.unsubscribe();
    // });
    //
    //yield* chatsDao.watchChatsForUser(userId);
  }

  Future<String?> createChat(String otherUserId) async {
    // final repository = ref.read(supabaseRepositoryProvider);
    // final chatsDao = ref.read(chatsDaoProvider);
    state = const AsyncValue.loading();
    try {
      // final chatId = await repository.createChat(otherUserId);
      // if (chatId != null) {
      //   await chatsDao.insertChat(ChatsCompanion(
      //       id: Value(chatId), createdAt: Value(DateTime.now()),),);
      //   await chatsDao.addChatMember(ChatMembersCompanion(chatId: Value(chatId)));
      // }

      return 'chatId';
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteChat(String chatId) async {
    // final repository = ref.read(supabaseRepositoryProvider);
    // final chatsDao = ref.read(chatsDaoProvider);
    // final messagesDao = ref.read(messagesDaoProvider);
    try {
      // final messages = await messagesDao.getMessagesByChatId(chatId);
      // //
      // await chatsDao.deleteChat(chatId);
      // //
      // //delete chat in supabase
      // await repository.deleteChat(chatId);
      // // Delete attachments from storage
      // await repository.deleteAtachmentsFromStorage(messages);
      // //
    } catch (error) {
      rethrow;
    }
  }

  Future<List<(Chat, User)>> _loadChats() async {
   // final repository = ref.read(supabaseRepositoryProvider);
    try {
      return  [];
    } catch (e) {
      log('_loadChats: error chats loading');
      rethrow;
    }
  }

  Future<void> refresh() async => _syncChats();

  Future<void> _syncChats() async {
    try {
      final chats = await _loadChats();
      log('chats:$chats');
      // chats.map(
      //     (e) => ref.read(chatsDaoProvider).insertChat(e.$1.toCompanion()),);
    } catch (error, stackTrace) {
      log('_refreshChats: error chats loading');
      rethrow;
    }
  }
}
