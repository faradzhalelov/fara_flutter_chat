import 'package:fara_chat/data/database/database.dart';

extension UserExtension on Map<String, dynamic> {
  User toUser() => User(
        id: this['id'] as String,
        email: this['email'] as String,
        username: this['username'] as String,
        avatarUrl: this['avatar_url'] as String?,
        isOnline: this['is_online'] as bool? ?? false,
      );
}

extension UserToJsonExtension on User {
  Map<String, dynamic> toJson() => {
    'id' : id,
    'email' : email,
    'username' : username,
    'avatar_url' : avatarUrl,
  'is_online' : isOnline,
  };
}

extension ChatExtension on Map<String, dynamic> {
  Chat toChat() => Chat(
        id: this['id'] as String,
        name: this['name'] as String?,
        createdAt: DateTime.parse(this['created_at'] as String),
        updatedAt: DateTime.parse(this['updated_at'] as String),
        userIds: this['user_ids'] != null ? List<String>.from(this['user_ids'] as List<dynamic>) : <String>[],
        lastMessageText: this['last_message_text'] as String?,
        lastMessageUserId: this['last_message_user_id'] as String?,
        lastMessageType: this['last_message_type'] as String?,
        lastMessageAt: this['last_message_at'] != null
            ? DateTime.parse(this['last_message_at'] as String)
            : null,
      );
}

extension MessageExtension on Map<String, dynamic> {
  Message toMessage() => Message(
        id: this['id'] as String,
        chatId: this['chat_id'] as String,
        userId: this['user_id'] as String?,
        content: this['content'] as String?,
        type: this['type'] as String,
        fileUrl: this['file_url'] as String?,
        isRead: this['is_read'] as bool? ?? false,
        createdAt: DateTime.parse(this['created_at'] as String),
      );
}
