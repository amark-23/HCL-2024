class RunningEvent {
  int? eventId;
  int creatorId;
  String title;
  String description;
  String location;
  String date;
  List<int> participants;

  RunningEvent({
    this.eventId,
    required this.creatorId,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.participants,
  });

  // Convert the RunningEvent object into a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'creatorId': creatorId,
      'title': title,
      'description': description,
      'location': location,
      'date': date,
      'participants': participants
          .join(','), // Convert participants list to a comma-separated string
    };
  }

  // Create a RunningEvent object from a Map (retrieved from the database)
  factory RunningEvent.fromMap(Map<String, dynamic> map) {
    return RunningEvent(
      eventId: map['eventId'],
      creatorId: map['creatorId'],
      title: map['title'],
      description: map['description'],
      location: map['location'],
      date: map['date'],
      participants: map['participants']
          .split(',')
          .where((e) => e.isNotEmpty)
          .map((e) => int.parse(e))
          .toList(), // Convert comma-separated string to a list of integers
    );
  }
}
