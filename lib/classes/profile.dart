import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final String name;
  final String username;
  final String profileImage;
  final int posts; // Add posts to the profile
  final int followers;
  final int following;
  final String occupation;
  final String location;

  Profile({
    required this.name,
    required this.username,
    required this.profileImage,
    required this.posts, // Include posts in the constructor
    required this.followers,
    required this.following,
    required this.occupation,
    required this.location,
  });

  // Method to fetch profile data based on the userId and calculate posts
  static Future<Profile> fetchProfile(String userId) async {
    // Fetch the user's profile data from the 'profiles' collection
    QuerySnapshot profileSnapshot = await FirebaseFirestore.instance
        .collection('profils')
        .where('user_id', isEqualTo: userId)
        .get();

    if (profileSnapshot.docs.isEmpty) {
      throw Exception('Profile not found');
    }

    // The profile document should exist, fetch the first document
    var profileData = profileSnapshot.docs[0].data() as Map<String, dynamic>;

    // Fetch the user's username and profile image from the 'users' collection
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (!userSnapshot.exists) {
      throw Exception('User data not found');
    }

    var userData = userSnapshot.data() as Map<String, dynamic>;

    // Calculate the number of posts for the user
    int postsCount = await _getPostsCount(userId);

    // Create and return the Profile object
    return Profile(
      name: profileData['name'] ?? 'Unknown',
      username: userData['username'] ?? 'Guest',
      profileImage: userData['profile_pic'] ?? 'assets/user_image.png',
      posts: postsCount, // Pass the calculated posts count
      followers: profileData['followers'] ?? 0,
      following: profileData['following'] ?? 0,
      occupation: profileData['occupation'] ?? 'Unknown',
      location: profileData['location'] ?? 'Unknown',
    );
  }

  // Helper function to calculate the number of posts for the given userId
  static Future<int> _getPostsCount(String userId) async {
    try {
      // Query the 'posts' collection and count the number of posts by the userId
      QuerySnapshot postsSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('user_id', isEqualTo: userId)
          .get();

      return postsSnapshot.docs.length; // Return the count of posts
    } catch (e) {
      print("Error fetching posts count: $e");
      return 0; // Return 0 in case of error
    }
  }
}
