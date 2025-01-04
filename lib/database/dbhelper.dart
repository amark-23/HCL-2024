//import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/models/posts_model.dart';
import 'package:flutter_app/models/comments_model.dart';
import 'package:flutter_app/models/running_routes_model.dart';
import 'package:flutter_app/models/running_events_model.dart';
import 'package:flutter_app/models/achievements_model.dart';
import 'package:flutter_app/models/user_achievements_model.dart';
import 'package:flutter_app/models/groups_model.dart';
import 'package:flutter_app/models/group_messages_model.dart';
import 'package:flutter_app/models/private_messages_model.dart';

class DatabaseHelper {
  final String databaseName = "runstagram.db";
  Database? database;

//TABLES
  // Users table
  String usersTable = '''
    CREATE TABLE users (
      userId INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT UNIQUE,
      password TEXT,
      email TEXT,
      profession TEXT,
      location TEXT,
      followers INTEGER DEFAULT 0,
      following INTEGER DEFAULT 0
    );
  ''';

  // Posts table
  String postsTable = '''
    CREATE TABLE posts (
      postId INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER,
      imagePath TEXT,
      caption TEXT,
      likes INTEGER DEFAULT 0,
      FOREIGN KEY (userId) REFERENCES users(userId)
    );
  ''';

  // Comments table
  String commentsTable = '''
    CREATE TABLE comments (
      commentId INTEGER PRIMARY KEY AUTOINCREMENT,
      postId INTEGER,
      userId INTEGER,
      comment TEXT,
      FOREIGN KEY (postId) REFERENCES posts(postId),
      FOREIGN KEY (userId) REFERENCES users(userId)
    );
  ''';

  // Running Routes table
  String runningRoutesTable = '''
    CREATE TABLE running_routes (
      routeId INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER,
      routeData TEXT, -- JSON format to store route details
      distance REAL,
      duration INTEGER,
      FOREIGN KEY (userId) REFERENCES users(userId)
    );
  ''';

  // Running Events table
  String runningEventsTable = '''
    CREATE TABLE running_events (
      eventId INTEGER PRIMARY KEY AUTOINCREMENT,
      creatorId INTEGER,
      title TEXT,
      description TEXT,
      location TEXT,
      date TEXT,
      participants TEXT, -- JSON list of userIds
      FOREIGN KEY (creatorId) REFERENCES users(userId)
    );
  ''';

  // Achievements table
  String achievementsTable = '''
    CREATE TABLE achievements (
      achievementId INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT, -- Achievement title, e.g., "50km Run"
      description TEXT, -- Additional details about the achievement
      distanceRequired REAL, -- Distance required to achieve this (e.g., 50, 100, etc.)
      UNIQUE(title) -- Ensures no duplicate achievement types
    );
  ''';

  // User Achievements table
  String userAchievementsTable = '''
    CREATE TABLE user_achievements (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER,
      achievementId INTEGER,
      dateAchieved TEXT,
      FOREIGN KEY (userId) REFERENCES users(userId),
      FOREIGN KEY (achievementId) REFERENCES achievements(achievementId)
    );
  ''';

  String privateMessagesTable = '''
    CREATE TABLE private_messages (
    messageId INTEGER PRIMARY KEY AUTOINCREMENT,
    senderId INTEGER,
    receiverId INTEGER,
    content TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (senderId) REFERENCES users(userId),
    FOREIGN KEY (receiverId) REFERENCES users(userId)
    );
  ''';

  String groupMessagesTable = '''
  CREATE TABLE group_messages (
    messageId INTEGER PRIMARY KEY AUTOINCREMENT,
    groupId INTEGER,
    senderId INTEGER,
    content TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (groupId) REFERENCES groups(groupId),
    FOREIGN KEY (senderId) REFERENCES users(userId)
   );
  ''';

  String groupsTable = '''
  CREATE TABLE groups (
    groupId INTEGER PRIMARY KEY AUTOINCREMENT,
    groupName TEXT,
    members TEXT -- Store JSON list of userIds
   );
   ''';

  Future<Database> getDB() async {
    if (database != null) {
      return database!;
    }
    database = await initDB();
    return database!;
  }

  Future<Database> initDB() async {
    // Get the database path
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, databaseName);

    // Open the database
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      // Execute table creation scripts
      await db.execute(usersTable);
      await db.execute(postsTable);
      await db.execute(commentsTable);
      await db.execute(runningRoutesTable);
      await db.execute(runningEventsTable);
      await db.execute(achievementsTable);
      await db.execute(userAchievementsTable);
      await db.execute(privateMessagesTable);
      await db.execute(groupMessagesTable);
      await db.execute(groupsTable);
    });
  }

  //Methods

  //Sign up
  Future<int> signup(User user) async {
    final db = await getDB();
    return await db.insert('users', user.toMap());
  }

  //Login
  Future<User?> login(String username, String password) async {
    final db = await getDB();
    // Query the users table for the matching username and password
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    // If a matching user is found, return a User object; otherwise, return null
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }

  //Fetch all users
  Future<List<User>> getAllUsers() async {
    final db = await getDB();
    final result = await db.query('users');
    return result.map((map) => User.fromMap(map)).toList();
  }

  //Fetch specific user
  Future<User?> getUserById(int userId) async {
    final db = await getDB();
    final result = await db.query(
      'users',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  //Update user info
  Future<int> updateUser(User user) async {
    final db = await getDB();
    return await db.update(
      'users',
      user.toMap(),
      where: 'userId = ?',
      whereArgs: [user.userId],
    );
  }

  //new post
  Future<int> insertPost(Post post) async {
    final db = await getDB();
    return await db.insert('posts', post.toMap());
  }

  //get post by User
  Future<List<Post>> getPostsByUserId(int userId) async {
    final db = await getDB();
    final result = await db.query(
      'posts',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'postId DESC',
    );
    return result.map((map) => Post.fromMap(map)).toList();
  }

  //delete post
  Future<int> deletePost(int postId) async {
    final db = await getDB();
    return await db.delete(
      'posts',
      where: 'postId = ?',
      whereArgs: [postId],
    );
  }

  //like post
  Future<int> likePost(int postId, int newLikesCount) async {
    final db = await getDB();
    return await db.update(
      'posts',
      {'likes': newLikesCount},
      where: 'postId = ?',
      whereArgs: [postId],
    );
  }

  //comment on post
  Future<int> insertComment(Comment comment) async {
    final db = await getDB();
    return await db.insert('comments', comment.toMap());
  }

  //read comments
  Future<List<Comment>> getCommentsByPostId(int postId) async {
    final db = await getDB();
    final result = await db.query(
      'comments',
      where: 'postId = ?',
      whereArgs: [postId],
      orderBy: 'commentId ASC',
    );
    return result.map((map) => Comment.fromMap(map)).toList();
  }

  //new event
  Future<int> insertEvent(RunningEvent event) async {
    final db = await getDB();
    return await db.insert('events', event.toMap());
  }

  //fetch event by ID
  Future<RunningEvent?> getRunningEventById(int eventId) async {
    final db = await getDB();
    final result = await db.query(
      'running_events',
      where: 'eventId = ?',
      whereArgs: [eventId],
    );
    if (result.isNotEmpty) {
      return RunningEvent.fromMap(result.first);
    }
    return null;
  }

  //update event
  Future<int> updateRunningEvent(RunningEvent event) async {
    final db = await getDB();
    return await db.update(
      'running_events',
      event.toMap(),
      where: 'eventId = ?',
      whereArgs: [event.eventId],
    );
  }

  // join event
  Future<int> joinEvent(int eventId, int userId) async {
    // Fetch the event by ID
    RunningEvent? event = await getRunningEventById(eventId);

    if (event != null) {
      // Check if the user is already a participant
      if (!event.participants.contains(userId)) {
        // Add the user to the participants list
        event.participants.add(userId);

        // Update the event in the database
        return await updateRunningEvent(event);
      } else {
        return -1; // User is already a participant
      }
    }

    return -2; // Event not found
  }

  //fetch all events for particular user
  Future<List<RunningEvent>> getEventsByParticipant(int userId) async {
    final db = await getDB();
    final result = await db.query('running_events');
    // Filter results to include only events where the userId is in participants
    List<RunningEvent> events =
        result.map((map) => RunningEvent.fromMap(map)).toList();
    // Filter events where the user is a participant
    return events
        .where((event) => event.participants.contains(userId))
        .toList();
  }

  Future<List<RunningEvent>> getRecommendedEvents() async {
    final db = await getDB();
    // Fetch up to 3 random events
    final result = await db.query(
      'running_events',
      orderBy: 'RANDOM()', // Randomly order events
      limit: 3, // Limit to 3 results
    );
    // Convert results into a list of RunningEvent objects
    return result.map((map) => RunningEvent.fromMap(map)).toList();
    // Replace random selection with a recommendation algorithm
    // based on user interests, location, participation history, etc.
  }

  //insertRoute
  Future<int> insertRunningRoute(RunningRoute route) async {
    final db = await getDB();
    return await db.insert('running_routes', route.toMap());
  }

  //fetch all routes for a user
  Future<List<RunningRoute>> getRoutesByUser(int userId) async {
    final db = await getDB();
    final result = await db.query(
      'running_routes',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'routeId DESC',
    );

    return result.map((map) => RunningRoute.fromMap(map)).toList();
  }

  //insert achievement
  Future<int> insertAchievement(Achievement achievement) async {
    final db = await getDB();

    try {
      return await db.insert('achievements', achievement.toMap());
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return -1; // Achievement with the same title already exists
      }
      return -2; // Other error
    }
  }

  //fetch all achievements
  Future<List<Achievement>> getAllAchievements() async {
    final db = await getDB();

    final result =
        await db.query('achievements', orderBy: 'distanceRequired ASC');

    return result.map((map) => Achievement.fromMap(map)).toList();
  }

  //user gained achievement
  Future<int> insertUserAchievement(UserAchievement userAchievement) async {
    final db = await getDB();

    // Check if the achievement is already earned by the user
    final existing = await db.query(
      'user_achievements',
      where: 'userId = ? AND achievementId = ?',
      whereArgs: [userAchievement.userId, userAchievement.achievementId],
    );

    if (existing.isNotEmpty) {
      return -1; // User already earned this achievement
    }

    // Insert the new user achievement
    return await db.insert('user_achievements', userAchievement.toMap());
  }

  //fetch earned achievements
  Future<List<Achievement>> getUserAchievements(int userId) async {
    final db = await getDB();

    final result = await db.rawQuery('''
    SELECT a.achievementId, a.title, a.description, a.distanceRequired
    FROM achievements a
    INNER JOIN user_achievements ua ON a.achievementId = ua.achievementId
    WHERE ua.userId = ?
    ORDER BY ua.dateAchieved DESC
  ''', [userId]);

    return result.map((map) => Achievement.fromMap(map)).toList();
  }

  //send message
  Future<int> insertPrivateMessage(PrivateMessage message) async {
    final db = await getDB();

    return await db.insert('private_messages', message.toMap());
  }

  //fetch conversation
  Future<List<PrivateMessage>> getPrivateMessages(
      int userId1, int userId2) async {
    final db = await getDB();

    final result = await db.query(
      'private_messages',
      where:
          '(senderId = ? AND receiverId = ?) OR (senderId = ? AND receiverId = ?)',
      whereArgs: [userId1, userId2, userId2, userId1],
      orderBy: 'timestamp ASC',
    );

    return result.map((map) => PrivateMessage.fromMap(map)).toList();
  }

  //insert group
  Future<int> insertGroup(Group group) async {
    final db = await getDB();

    return await db.insert('groups', group.toMap());
  }

  //fetch groups
  Future<List<Group>> getAllGroups() async {
    final db = await getDB();

    final result = await db.query('groups', orderBy: 'groupName ASC');

    return result.map((map) => Group.fromMap(map)).toList();
  }

  //fetch a group
  Future<Group?> getGroupById(int groupId) async {
    final db = await getDB();

    final result = await db.query(
      'groups',
      where: 'groupId = ?',
      whereArgs: [groupId],
    );

    if (result.isNotEmpty) {
      return Group.fromMap(result.first);
    }
    return null; // Group not found
  }

  //add member to group
  Future<int> addMemberToGroup(int groupId, int userId) async {
    final db = await getDB();

    // Fetch the group
    Group? group = await getGroupById(groupId);

    if (group != null) {
      // Check if the user is already a member
      if (!group.members.contains(userId)) {
        group.members.add(userId);

        // Update the group in the database
        return await db.update(
          'groups',
          group.toMap(),
          where: 'groupId = ?',
          whereArgs: [groupId],
        );
      } else {
        return -1; // User already a member
      }
    }

    return -2; // Group not found
  }

  //send group message
  Future<int> insertGroupMessage(GroupMessage message) async {
    final db = await getDB();

    return await db.insert('group_messages', message.toMap());
  }

  //fetch group messages
  Future<List<GroupMessage>> getGroupMessages(int groupId) async {
    final db = await getDB();

    final result = await db.query(
      'group_messages',
      where: 'groupId = ?',
      whereArgs: [groupId],
      orderBy: 'timestamp ASC',
    );

    return result.map((map) => GroupMessage.fromMap(map)).toList();
  }
}
