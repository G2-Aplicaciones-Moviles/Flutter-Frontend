class ChatContactModel {
  final int userId;
  final String name;
  final String? email;
  final String? avatarUrl;
  final DateTime? lastMessageAt;
  final String? lastMessage;

  ChatContactModel({
    required this.userId,
    required this.name,
    this.email,
    this.avatarUrl,
    this.lastMessageAt,
    this.lastMessage,
  });

  factory ChatContactModel.fromJson(Map<String, dynamic> json) {
    return ChatContactModel(
      userId: json['userId'] as int,
      name: json['name'] as String? ?? 'Usuario',
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.parse(json['lastMessageAt'] as String)
          : null,
      lastMessage: json['lastMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'lastMessage': lastMessage,
    };
  }
}

