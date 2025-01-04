class Achievement {
  int? achievementId;
  String title;
  String description;
  double distanceRequired;

  Achievement({
    this.achievementId,
    required this.title,
    required this.description,
    required this.distanceRequired,
  });

  Map<String, dynamic> toMap() {
    return {
      'achievementId': achievementId,
      'title': title,
      'description': description,
      'distanceRequired': distanceRequired,
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      achievementId: map['achievementId'],
      title: map['title'],
      description: map['description'],
      distanceRequired: map['distanceRequired'],
    );
  }
}
