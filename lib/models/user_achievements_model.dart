class UserAchievement {
  int? id;
  int userId;
  int achievementId;
  String dateAchieved;

  UserAchievement({
    this.id,
    required this.userId,
    required this.achievementId,
    required this.dateAchieved,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'achievementId': achievementId,
      'dateAchieved': dateAchieved,
    };
  }

  factory UserAchievement.fromMap(Map<String, dynamic> map) {
    return UserAchievement(
      id: map['id'],
      userId: map['userId'],
      achievementId: map['achievementId'],
      dateAchieved: map['dateAchieved'],
    );
  }
}
