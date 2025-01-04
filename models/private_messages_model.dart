class PrivateMessage {
  int? messageId;
  int senderId;
  int receiverId;
  String content;
  String timestamp;

  PrivateMessage({
    this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp,
    };
  }

  factory PrivateMessage.fromMap(Map<String, dynamic> map) {
    return PrivateMessage(
      messageId: map['messageId'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      content: map['content'],
      timestamp: map['timestamp'],
    );
  }
}
