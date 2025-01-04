import 'package:flutter_app/database/dbhelper.dart';
import 'dart:convert'; // For encoding JSON

//import 'package:flutter_app/models/user_model.dart';
//import ...
Future<void> insertData() async {
  //requires Server and API
}
Future<void> insertDummyData() async {
  final dbHelper = DatabaseHelper();
  final db = await dbHelper.getDB();
  //TODO: add profile pics
  //3 users: nikos_ftw, younglight, spiderman
  await db.insert('users', {
    'username': 'nikos_ftw',
    'email': 'nikosftw@mail.com',
    'password': '123456',
    'profession': 'Runner',
    'location': 'Glyfada, Greece',
  });

  await db.insert('users', {
    'username': 'younglight',
    'email': 'younglight@gmail.com',
    'password': '123456',
    'profession': 'Trapper & Entrepreneur',
    'location': 'Glyfada, Greece',
  });

  await db.insert('users', {
    'username': 'spiderman',
    'email': 'spiderman@gmail.com',
    'password': '123456',
    'profession': 'Runner',
    'location': 'New York, USA',
  });

  await db.insert('users', {
    'username': 'aerapatera',
    'email': 'variemai@mail.com',
    'password': '123456',
    'profession': 'gyftos',
    'location': 'Ierapetra, Greece',
  });

  //2 achievements: 5km , 10km
  await db.insert('achievements', {
    'title': '5km Run',
    'description': 'Run 5 kilometers!',
    'distanceRequired': 5.0,
  });

  await db.insert('achievements', {
    'title': '10km Run',
    'description': 'Run 10 kilometers!',
    'distanceRequired': 10.0,
  });

  // nikosftw: 5km and 10km achievements
  // younglight: 5km
  // spiderman: 10km
  await db.insert('user_achievements', {
    'userId': 1,
    'achievementId': 1,
    'dateAchieved': DateTime.now().toIso8601String(),
  });

  await db.insert('user_achievements', {
    'userId': 1,
    'achievementId': 2,
    'dateAchieved': DateTime.now().toIso8601String(),
  });

  await db.insert('user_achievements', {
    'userId': 2,
    'achievementId': 1,
    'dateAchieved': DateTime.now().toIso8601String(),
  });

  await db.insert('user_achievements', {
    'userId': 3,
    'achievementId': 2,
    'dateAchieved': DateTime.now().toIso8601String(),
  });

  //nikos_ftw/younglight: 2 private messages
  await db.insert('private_messages', {
    'senderId': 1,
    'receiverId': 2,
    'content': 'kavlwmenh yeah',
    'timestamp': DateTime.now().toIso8601String(),
  });

  await db.insert('private_messages', {
    'senderId': 2,
    'receiverId': 1,
    'content': 'apto mmb',
    'timestamp': DateTime.now().toIso8601String(),
  });

  // Insert Dummy Group
  await db.insert('groups', {
    'groupName': 'Running Enthusiasts',
    'members': '1,2,3',
  });

  // Insert Dummy Group Messages
  await db.insert('group_messages', {
    'groupId': 1,
    'senderId': 1,
    'content': 'kalwshrthate sto party!',
    'timestamp': DateTime.now().toIso8601String(),
  });

  // Insert Dummy Posts
  await db.insert('posts', {
    'userId': 1,
    'imagePath': 'assets/images/post1.jpg', // Replace with actual image paths
    'caption': 'First run of the week! 5km in 30 minutes.',
    'likes': 15,
  });

  await db.insert('posts', {
    'userId': 2,
    'imagePath': 'assets/images/post2.jpg', // Replace with actual image paths
    'caption': 'Sunset cycling session. Such a peaceful ride!',
    'likes': 25,
  });

  await db.insert('posts', {
    'userId': 4,
    'imagePath': 'assets/images/post3.jpg', // Replace with actual image paths
    'caption': 'meow',
    'likes': 40,
  });

  // Insert Dummy Comments
  await db.insert('comments', {
    'postId': 1,
    'userId': 2,
    'comment': 'Amazing run! Keep it up!',
  });

  await db.insert('comments', {
    'postId': 1,
    'userId': 1,
    'comment': 'Thanks! Felt great to hit this milestone.',
  });

  await db.insert('comments', {
    'postId': 2,
    'userId': 1,
    'comment': 'Cycling during sunset is so relaxing!',
  });

  await db.insert('comments', {
    'postId': 3,
    'userId': 2,
    'comment': 'Congrats on your personal best! You’re crushing it!',
  });

  //Dummy running routes
  // Example Route 1: JSON for coordinates
  List<Map<String, double>> route1Data = [
    {'lat': 40.7128, 'lng': -74.0060}, // New York
    {'lat': 40.7138, 'lng': -74.0070},
    {'lat': 40.7148, 'lng': -74.0080},
  ];

  // Example Route 2: JSON for coordinates
  List<Map<String, double>> route2Data = [
    {'lat': 34.0522, 'lng': -118.2437}, // Los Angeles
    {'lat': 34.0523, 'lng': -118.2440},
    {'lat': 34.0524, 'lng': -118.2445},
  ];

  // Insert Route 1
  await db.insert('running_routes', {
    'userId': 1,
    'routeData': jsonEncode(route1Data), // Convert to JSON string
    'distance': 5.0, // Distance in kilometers
    'duration': 1800, // Duration in seconds (30 minutes)
  });

  // Insert Route 2
  await db.insert('running_routes', {
    'userId': 2,
    'routeData': jsonEncode(route2Data), // Convert to JSON string
    'distance': 3.2, // Distance in kilometers
    'duration': 1200, // Duration in seconds (20 minutes)
  });

  // Dummy Event 1
  List<int> event1Participants = [1, 2]; // User IDs
  await db.insert('running_events', {
    'creatorId': 1,
    'title': 'Morning 5K Run',
    'description': 'Join us for a refreshing 5K run to start the day!',
    'location': 'zefyri',
    'date': DateTime.now().add(Duration(days: 1)).toIso8601String(), // Tomorrow
    'participants': jsonEncode(event1Participants),
  });

  // Dummy Event 2
  List<int> event2Participants = [2, 3, 4]; // User IDs
  await db.insert('running_events', {
    'creatorId': 2,
    'title': 'Sunset 10K Challenge',
    'description': 'Run 10 kilometers while enjoying the beautiful sunset.',
    'location': 'Steriperi',
    'date': DateTime.now()
        .add(Duration(days: 7))
        .toIso8601String(), // One week later
    'participants': jsonEncode(event2Participants),
  });
}
