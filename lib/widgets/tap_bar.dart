import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/bottom_frame.dart';
import 'gpsrecorder.dart'; // Import the GPS recorder screen
import '../pages/feed_page.dart'; // Import the FeedPage

class TapBar extends StatefulWidget {
  final TabController tabController;
  final String userId; // Only the userId is passed now

  TapBar({
    required this.tabController,
    required this.userId, // Pass only userId
  });

  @override
  _TapBarState createState() => _TapBarState();
}

class _TapBarState extends State<TapBar> {
  late Future<Map<String, String>>
      userInfoFuture; // To store username and profile pic
  late String username;
  late String profilePic;

  @override
  void initState() {
    super.initState();
    // Initialize the user information future
    userInfoFuture = _fetchUserInfo(widget.userId);
  }

  Future<Map<String, String>> _fetchUserInfo(String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data()!;
        username = userData['username'] ?? 'Unknown';
        profilePic = userData['profile_pic'] ?? 'assets/user_image.png';
        return {'username': username, 'profile_pic': profilePic};
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return {'username': 'Unknown', 'profile_pic': 'assets/user_image.png'};
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Opacity(
      opacity: 0.75,
      child: Container(
        width: screenWidth * 0.9,
        height: 400,
        child: Column(
          children: [
            // Tap Bar (Icons with text)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIcon(0, widget.tabController.index == 0,
                    'assets/icons/navigation1.png'),
                _buildIcon(1, widget.tabController.index == 1,
                    'assets/icons/navigation2.png'),
                _buildIcon(2, widget.tabController.index == 2,
                    'assets/icons/navigation3.png'),
              ],
            ),
            Expanded(
              child: FutureBuilder<Map<String, String>>(
                future: userInfoFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('User data not found.'));
                  } else {
                    username = snapshot.data!['username']!;
                    profilePic = snapshot.data!['profile_pic']!;

                    return TabBarView(
                      controller: widget.tabController,
                      children: [
                        _TabContentTab1(
                          username: username,
                          userId: widget.userId,
                          profilePic: profilePic,
                        ),
                        _TabContentTab2(),
                        _TabContentTab3(),
                      ],
                      physics: BouncingScrollPhysics(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(int index, bool isSelected, String iconPath) {
    return GestureDetector(
      onTap: () {
        widget.tabController.animateTo(index); // Switch tabs when tapped
        setState(() {}); // Force a rebuild to update the selected tab
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            width: 30,
            height: 30,
            color: isSelected ? Colors.white : Colors.grey,
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            height: 2,
            width: 30,
            color: isSelected ? Colors.white : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class ImageViewPage extends StatefulWidget {
  final Map<String, dynamic> post;
  final String userId;
  final String profilePic; // Receive profilePic as a parameter

  ImageViewPage(
      {required this.post, required this.userId, required this.profilePic});

  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    // Initialize the 'isLiked' value based on the initial liked status
    isLiked = widget.post['likedBy'].contains(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen Image
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Image.network(
              widget.post['postPicture'],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Back Button (Arrow) at the top-left
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context); // Pop the current screen to go back
              },
            ),
          ),

          // Bottom Frame with User Info
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomFrame(
              username: widget.post['username'],
              isLiked: isLiked, // Pass the current like status
              onLikeToggle: (bool liked) {
                _toggleLike(liked);
              },
              profilePicUrl: widget.profilePic, // Use the passed profilePic
            ),
          ),
        ],
      ),
    );
  }

  // Function to toggle like and update Firestore
  void _toggleLike(bool liked) {
    setState(() {
      isLiked = liked;
    });

    final postId = widget.post['postId'];
    List<String> likedBy = List<String>.from(widget.post['likedBy']);
    if (liked) {
      likedBy.add(widget.userId); // Add userId to liked list
    } else {
      likedBy.remove(widget.userId); // Remove userId from liked list
    }

    // Update Firestore document with the new likedBy list
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update({'liked_by': likedBy});
  }
}

class _TabContentTab1 extends StatelessWidget {
  final String userId;
  final String username;
  final String profilePic; // Receive profilePic as a parameter

  _TabContentTab1(
      {required this.userId, required this.username, required this.profilePic});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchPostsByUsername(username),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No posts available.'));
        } else {
          List<Map<String, dynamic>> posts = snapshot.data!;
          // Sort posts by the 'created_at' field in descending order
          posts.sort((a, b) {
            Timestamp aTimestamp = a['createdAt'];
            Timestamp bTimestamp = b['createdAt'];
            return bTimestamp.compareTo(aTimestamp);
          });

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                var post = posts[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to the new ImageViewPage and pass the profilePic URL
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageViewPage(
                          post: post,
                          userId: userId,
                          profilePic:
                              profilePic, // Pass profilePic to the new page
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(post['postPicture']),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchPostsByUsername(
      String username) async {
    try {
      final postsSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('username', isEqualTo: username)
          .get();

      List<Map<String, dynamic>> posts = postsSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "postId": doc.id,
          "username": data['username'],
          "postPicture": data['post_picture'],
          "likedBy": List<String>.from(data['liked_by']),
          "createdAt": data['created_at'],
        };
      }).toList();

      return posts;
    } catch (e) {
      print("Error fetching posts: $e");
      return [];
    }
  }
}

class _TabContentTab2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LocationRecorderWithMap()),
          );
        },
        child: Text('Press me'),
      ),
    );
  }
}

class _TabContentTab3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Achievements',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // List of achievements
            for (int i = 1; i <= 3; i++)
              ListTile(
                title: Text('Made it $i'),
                leading: Icon(Icons.star, color: Colors.yellow),
              ),
          ],
        ),
      ),
    );
  }
}
