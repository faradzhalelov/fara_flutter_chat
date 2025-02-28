class UserModel {

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.avatarUrl,
    this.isOnline = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      isOnline: json['is_online'] as bool? ?? false,
    );
  final String id;
  final String email;
  final String username;
  final String? avatarUrl;
  final bool isOnline;

  Map<String, dynamic> toJson() => {
      'id': id,
      'email': email,
      'username': username,
      'avatar_url': avatarUrl,
      'is_online': isOnline,
    };
}
