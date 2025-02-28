class ChatModel {

  ChatModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userIds,
    this.name,
    this.lastMessageText,
    this.lastMessageUserId,
    this.lastMessageType,
    this.lastMessageAt,
    this.otherUsername,
    this.otherUserAvatarUrl,
    this.isLastMessageMine = false,
    this.isOtherUserOnline = false,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at']  != null ? DateTime.parse(json['updated_at'] as String) : null,
      userIds: json['user_ids'] != null ? (json['user_ids'] as List<dynamic>).map((e) => e as String).toList() : const [],
      name: json['name'] as String?,
      lastMessageText: json['lastMessage_text'] as String?,
      lastMessageUserId: json['last_message_user_id'] as String?,
      lastMessageType: json['last_message_type'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
    );
  final String id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> userIds;
  final String? name;
  final String? lastMessageText;
  final String? lastMessageUserId;
  final String? lastMessageType;
  final DateTime? lastMessageAt;

  // UI metadata (not stored in DB)
  final String? otherUsername;
  final String? otherUserAvatarUrl;
  final bool isLastMessageMine;
  final bool isOtherUserOnline;

  Map<String, dynamic> toJson() => {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'user_ids': userIds,
      'name': name,
      'last_message_text': lastMessageText,
      'last_message_user_id': lastMessageUserId,
      'last_message_type': lastMessageType,
      'last_message_at': lastMessageAt?.toIso8601String(),
    };
}
