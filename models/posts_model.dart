class Post {
  int? postId;
  int userId;
  String imagePath;
  String caption;
  int likes;

  Post({
    this.postId,
    required this.userId,
    required this.imagePath,
    required this.caption,
    this.likes = 0,
  });

  // Convert to map for database
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'imagePath': imagePath,
      'caption': caption,
      'likes': likes,
    };
  }

  // Convert from map to model
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['postId'],
      userId: map['userId'],
      imagePath: map['imagePath'],
      caption: map['caption'],
      likes: map['likes'],
    );
  }
}
