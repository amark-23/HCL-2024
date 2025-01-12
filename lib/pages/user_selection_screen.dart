import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSelectionScreen extends StatelessWidget {
  const UserSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          // Login Page Container
          Container(
            width: screenWidth,
            height: screenHeight,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: Colors.white),
            child: Stack(
              children: [
                // Background color
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: screenWidth,
                    height: screenHeight,
                    decoration: BoxDecoration(color: Color(0xFF4749B5)),
                  ),
                ),
                // Back arrow and Login Title
                Positioned(
                  left: 0,
                  top: screenHeight * 0.04,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Colors.white), // Back arrow icon
                    onPressed: () {
                      // Navigate back to the IntroPage
                      Navigator.pushReplacementNamed(context, '/intro');
                    },
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.25,
                  top: screenHeight * 0.05,
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    height: 30,
                    child: Text(
                      'Login to your Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Email field
                Positioned(
                  left: 36,
                  top: screenHeight * 0.15, // Adjust top value here
                  child: Text(
                    'E-mail',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  left: 36,
                  top: screenHeight * 0.2, // Adjust top value here
                  child: Container(
                    width: screenWidth * 0.8,
                    height: 43,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: 'Enter your email',
                      ),
                    ),
                  ),
                ),
                // Password field
                Positioned(
                  left: 36,
                  top: screenHeight * 0.3, // Adjust top value here
                  child: Text(
                    'Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  left: 36,
                  top: screenHeight * 0.35, // Adjust top value here
                  child: Container(
                    width: screenWidth * 0.8,
                    height: 43,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: TextField(
                      obscureText: true, // Hides the text for password
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: 'Enter your password',
                      ),
                    ),
                  ),
                ),
                // Log In button
                Positioned(
                  left: screenWidth * 0.35,
                  top: screenHeight * 0.5,
                  child: InkWell(
                    onTap: () {
                      // Implement login logic here
                    },
                    child: Container(
                      width: screenWidth * 0.3,
                      height: 37,
                      decoration: ShapeDecoration(
                        color: Color(0xFFB2BCFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Log In!',
                          style: TextStyle(
                            color: Color(0xFF0002AB),
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Forgot password link
                Positioned(
                  left: screenWidth * 0.31,
                  top: screenHeight * 0.6,
                  child: InkWell(
                    onTap: () {
                      // Navigate to password reset page
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Quick login section (User icons)
                Positioned(
                  left: screenWidth * 0.05,
                  top: screenHeight * 0.7,
                  child: Column(
                    children: [
                      Text(
                        'Quick Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                      // StreamBuilder to fetch users for quick login
                      Container(
                        width: screenWidth * 0.9,
                        height: 100,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .snapshots(),
                          builder: (context, snapshot) {
                            // Show a loading indicator while waiting for data
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            // Handle errors in case of failure
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }

                            // If no data is found in the users collection
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Center(
                                  child: Text("No users available."));
                            }

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: snapshot.data!.docs.map((userDoc) {
                                final userId = userDoc.id;
                                final username = userDoc['username'];
                                final profilePic = userDoc['profile_pic'];

                                return InkWell(
                                  onTap: () {
                                    // Implement quick login logic here
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/home', // Ensure this route is defined in your MaterialApp
                                      arguments: {
                                        'userId': userId,
                                        'username': username,
                                        'profilePic': profilePic,
                                      },
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(profilePic),
                                    onBackgroundImageError: (_, __) =>
                                        const Icon(Icons.person),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
