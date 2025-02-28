import 'package:fara_chat/data/models/message_type.dart';

class MessageModel {

  MessageModel({
    required this.id,
    required this.chatId,
    required this.createdAt, this.userId,
    this.content,
    this.type = MessageType.text,
    this.fileUrl,
    this.isMine = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'] as String,
        chatId: json['chat_id'] as String,
        userId: json['user_id'] as String?,
        content: json['content'] as String?,
        type: json['type'] != null ? MessageType.values.byName(json['type'] as String) : MessageType.text,
        fileUrl: json['file_url'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
  final String id;
  final String chatId;
  final String? userId;
  final String? content;
  final MessageType type;
  final String? fileUrl;
  final DateTime createdAt;
  
  // UI metadata
  final bool isMine;

  Map<String, dynamic> toJson() => {
        'id': id,
        'chat_id': chatId,
        'user_id': userId,
        'content': content,
        'type': type.name,
        'file_url': fileUrl,
        'created_at': createdAt.toIso8601String(),
      };
}
