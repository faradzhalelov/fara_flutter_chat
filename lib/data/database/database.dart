import 'package:flutter/foundation.dart';

/// User model
@immutable
class User {
  const User({
    required this.id,
    required this.email,
    required this.username,
    this.avatarUrl,
    this.isOnline = false,
  });

  final String id;
  final String email;
  final String username;
  final String? avatarUrl;
  final bool isOnline;

  // Copy with method for creating a modified copy
  User copyWith({
    String? id,
    String? email,
    String? username,
    String? avatarUrl,
    bool? isOnline,
  }) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        username: username ?? this.username,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        isOnline: isOnline ?? this.isOnline,
      );
}

/// Chat model
@immutable
class Chat {
  const Chat({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userIds,
    this.name,
    this.lastMessageText,
    this.lastMessageUserId,
    this.lastMessageType,
    this.lastMessageAt,
  });
  final String id;
  final String? name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> userIds;
  final String? lastMessageText;
  final String? lastMessageUserId;
  final String? lastMessageType;
  final DateTime? lastMessageAt;

  // Copy with method for creating a modified copy
  Chat copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? userIds,
    String? lastMessageText,
    String? lastMessageUserId,
    String? lastMessageType,
    DateTime? lastMessageAt,
  }) =>
      Chat(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        userIds: userIds ?? this.userIds,
        lastMessageText: lastMessageText ?? this.lastMessageText,
        lastMessageUserId: lastMessageUserId ?? this.lastMessageUserId,
        lastMessageType: lastMessageType ?? this.lastMessageType,
        lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      );
}

/// Message model
@immutable
class Message {
  const Message({
    required this.id,
    required this.chatId,
    required this.type, // ignore: always_put_required_named_parameters_first
    required this.createdAt,
    this.userId,
    this.isRead,
    this.content,
    this.fileUrl,
  });
  final String id;
  final String chatId;
  final String? userId;
  final String? content;
  final String type;
  final String? fileUrl;
  final bool? isRead;
  final DateTime createdAt;

  // Copy with method for creating a modified copy
  Message copyWith({
    String? id,
    String? chatId,
    String? userId,
    String? content,
    String? type,
    String? fileUrl,
    bool? isRead,
    DateTime? createdAt,
  }) => Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      type: type ?? this.type,
      fileUrl: fileUrl ?? this.fileUrl,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
}

/// Database interface
abstract class AppDatabase {
  // User operations
  Future<void> upsertUser(User user);
  Future<User?> getUserById(String userId);
  Future<List<User>> getAllUsers();

  // Chat operations
  Future<void> upsertChat(Chat chat);
  Future<Chat?> getChatById(String chatId);
  Future<List<Chat>> getAllChats();
  Stream<List<Chat>> watchAllChats();
  Future<void> deleteChat(String chatId);

  // Message operations
  Future<void> upsertMessage(Message message);
  Future<List<Message>> getChatMessages(String chatId);
  Stream<List<Message>> watchChatMessages(String chatId);

  // Close the database
  Future<void> close();
}
