class GroupMessage {
  int? messageId;
  int groupId;
  int senderId;
  String content;
  String timestamp;

  GroupMessage({
    this.messageId,
    required this.groupId,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'groupId': groupId,
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp,
    };
  }

  factory GroupMessage.fromMap(Map<String, dynamic> map) {
    return GroupMessage(
      messageId: map['messageId'],
      groupId: map['groupId'],
      senderId: map['senderId'],
      content: map['content'],
      timestamp: map['timestamp'],
    );
  }
}
