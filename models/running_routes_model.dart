class RunningRoute {
  int? routeId;
  int userId;
  String routeData; // Store JSON data as String
  double distance;
  int duration;

  RunningRoute({
    this.routeId,
    required this.userId,
    required this.routeData,
    required this.distance,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'routeId': routeId,
      'userId': userId,
      'routeData': routeData,
      'distance': distance,
      'duration': duration,
    };
  }

  factory RunningRoute.fromMap(Map<String, dynamic> map) {
    return RunningRoute(
      routeId: map['routeId'],
      userId: map['userId'],
      routeData: map['routeData'],
      distance: map['distance'],
      duration: map['duration'],
    );
  }
}
