class Comment {
  int? commentId;
  int postId;
  int userId;
  String comment;

  Comment({
    this.commentId,
    required this.postId,
    required this.userId,
    required this.comment,
  });

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'postId': postId,
      'userId': userId,
      'comment': comment,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentId: map['commentId'],
      postId: map['postId'],
      userId: map['userId'],
      comment: map['comment'],
    );
  }
}
