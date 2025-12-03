class ChatMessageModel {
  final int? id;
  final int senderId;
  final int recipientId;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  ChatMessageModel({
    this.id,
    required this.senderId,
    required this.recipientId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as int?,
      senderId: json['senderId'] as int,
      recipientId: json['recipientId'] as int,
      content: json['content'] as String,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'senderId': senderId,
      'recipientId': recipientId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  ChatMessageModel copyWith({
    int? id,
    int? senderId,
    int? recipientId,
    String? content,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}

