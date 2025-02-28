import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:fara_chat/data/database/database.dart';

extension UserCompanionExtension on Map<String, dynamic> {
  UsersCompanion toUserCompanion() => UsersCompanion(
        id: Value(this['id'] as String),
        email: Value(this['email'] as String),
        username: Value(this['username'] as String),
        avatarUrl: Value(this['avatar_url'] as String?),
        isOnline: Value(this['is_online'] as bool? ?? false),
      );
}

extension ChatCompanionExtension on Map<String, dynamic> {
  ChatsCompanion toChatCompanion() => ChatsCompanion(
        id: Value(this['id'] as String),
        name: Value(this['name'] as String?),
        createdAt: Value(DateTime.parse(this['created_at'] as String)),
        updatedAt: Value(DateTime.parse(this['updated_at'] as String)),
        userIds: Value(jsonEncode(this['user_ids'])),
        lastMessageText: Value(this['last_message_text'] as String?),
        lastMessageUserId: Value(this['last_message_user_id'] as String?),
        lastMessageType: Value(this['last_message_type'] as String?),
        lastMessageAt: this['last_message_at'] != null
            ? Value(DateTime.parse(this['last_message_at'] as String))
            : const Value(null),
      );
}

extension MessageCompanionExtension on Map<String, dynamic> {
  MessagesCompanion toMessageCompanion() => MessagesCompanion(
        id: Value(this['id'] as String),
        chatId: Value(this['chat_id'] as String),
        userId: Value(this['user_id'] as String?),
        content: Value(this['content'] as String?),
        type: Value(this['type'] as String),
        fileUrl: Value(this['file_url'] as String?),
        createdAt: Value(DateTime.parse(this['created_at'] as String)),
      );
}
