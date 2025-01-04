class Group {
  int? groupId;
  String groupName;
  List<int> members;

  Group({
    this.groupId,
    required this.groupName,
    required this.members,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'members': members.join(','), // Convert to comma-separated string
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      groupId: map['groupId'],
      groupName: map['groupName'],
      members: map['members'].split(',').map((e) => int.parse(e)).toList(),
    );
  }
}
