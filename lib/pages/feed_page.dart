import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_frame.dart';

class FeedPage extends StatefulWidget {
  final String userId;
  final String username;
  final String profilePic;

  const FeedPage({
    super.key,
    required this.userId,
    required this.username,
    required this.profilePic,
  });

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final PageController _pageController = PageController();
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final postsSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('created_at', descending: true)
          .get();

      List<Map<String, dynamic>> posts = await Future.wait(
        postsSnapshot.docs.map((doc) async {
          final data = doc.data();
          final username = data['username'] as String;
          final profilePic = await _getProfilePicture(username);

          return {
            "postId": doc.id,
            "username": username,
            "profilePic": profilePic,
            "postPicture": data['post_picture'],
            "likedBy": List<String>.from(data['liked_by']),
            "createdAt": data['created_at'],
          };
        }).toList(),
      );

      setState(() {
        _posts = posts; // Display all posts
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching posts: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _getProfilePicture(String username) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userData = userSnapshot.docs.first.data();
        return userData['profile_pic'] as String;
      }

      return 'assets/user_image.png';
    } catch (e) {
      print("Error fetching profile picture for $username: $e");
      return 'assets/user_image.png';
    }
  }

  void _toggleLike(int index) {
    final userId = widget.userId;
    setState(() {
      if (_posts[index]['likedBy'].contains(userId)) {
        _posts[index]['likedBy'].remove(userId);
      } else {
        _posts[index]['likedBy'].add(userId);
      }
    });

    FirebaseFirestore.instance
        .collection('posts')
        .doc(_posts[index]['postId'])
        .update({'liked_by': _posts[index]['likedBy']});
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Loading or Posts
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      return Stack(
                        children: [
                          // Fullscreen Image
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                            ),
                            child: Image.network(
                              post['postPicture'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          // Bottom Frame with User Info
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: BottomFrame(
                              username: post['username'],
                              isLiked: post['likedBy'].contains(widget.userId),
                              onLikeToggle: (_) => _toggleLike(index),
                              profilePicUrl: post['profilePic'],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

            // Top Ellipses
            Positioned(
              top: -170,
              left: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  color: const Color(0xFF4986F6),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: -250,
              right: -100,
              child: Container(
                width: 400,
                height: 360,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A48BB),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
              ),
            ),

            // Profile Info
            Positioned(
              top: 20,
              right: 20,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.profilePic),
                    radius: 26,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
