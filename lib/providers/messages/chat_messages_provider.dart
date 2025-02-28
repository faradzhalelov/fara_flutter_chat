// import 'package:fara_chat/core/supabase/supabase_service.dart';
// import 'package:fara_chat/data/database/database.dart';
// import 'package:fara_chat/data/models/message_type.dart';
// import 'package:fara_chat/providers/chats/chats_provider.dart';
// import 'package:fara_chat/providers/database/database_provider.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'chat_messages_provider.g.dart';

// @riverpod
// class ChatMessagesNotifier extends _$ChatMessagesNotifier {
//   @override
//   Stream<List<Message>> build(String chatId) {
//     final currentUser = supabase.auth.currentUser;

//     if (currentUser == null) {
//       return Stream.value([]);
//     }

//     // Initialize message sync
//     Future.microtask(() async {
//       final repository = ref.read(chatRepositoryProvider);
//       await repository.syncChatMessages(chatId);
//     });

//     // Return stream from local database
//     return ref
//         .watch(driftDatabaseProvider)
//         .watchChatMessages(chatId)
//         .map((messages) => _mapMessagesToModels(messages, currentUser.id));
//   }

//   List<MessageModel> _mapMessagesToModels(
//           List<Message> messages, String currentUserId) =>
//       messages.map((message) {
//         final isMine = message.userId == currentUserId;

//         return MessageModel(
//           id: message.id,
//           chatId: message.chatId,
//           userId: message.userId,
//           content: message.content,
//           type: MessageType.values.byName(message.type),
//           fileUrl: message.fileUrl,
//           createdAt: message.createdAt,
//           isMine: isMine,
//         );
//       }).toList();

//   Future<void> sendMessage({
//     required String content,
//     String type = 'text',
//     String? fileUrl,
//   }) async {
//     final repository = ref.read(chatRepositoryProvider);
//     await repository.sendMessage(
//       chatId: chatId,
//       content: content,
//       type: type,
//       fileUrl: fileUrl,
//     );
//   }

//   Future<void> refreshMessages() async {
//     final repository = ref.read(chatRepositoryProvider);
//     await repository.syncChatMessages(chatId);
//   }
// }
