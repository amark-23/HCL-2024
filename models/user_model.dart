class User {
  int? userId;
  String username;
  String password;
  String email;
  String profession;
  String location;
  int followers;
  int following;

  User({
    this.userId,
    required this.username,
    required this.password,
    required this.email,
    required this.profession,
    required this.location,
    this.followers = 0,
    this.following = 0,
  });

  // Convert to map for database
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'password': password,
      'email': email,
      'profession': profession,
      'location': location,
      'followers': followers,
      'following': following,
    };
  }

  // Convert from map to model
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      username: map['username'],
      password: map['password'],
      email: map['email'],
      profession: map['profession'],
      location: map['location'],
      followers: map['followers'],
      following: map['following'],
    );
  }
}
