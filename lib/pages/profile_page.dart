import 'package:flutter/material.dart';
import '../classes/profile.dart'; // Import Profile class
import '../widgets/tap_bar.dart'; // Import TapBar

class ProfilePage extends StatefulWidget {
  final String userId; // User ID passed to the widget to fetch the profile

  ProfilePage({required this.userId}); // Constructor receives userId

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<Profile>
      _profileFuture; // Store the Future to load profile only once

  @override
  void initState() {
    super.initState();
    // Initialize the TabController with 3 tabs
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged); // Listen for tab changes

    // Fetch profile data only once when the page is first initialized
    _profileFuture = Profile.fetchProfile(widget.userId);
  }

  @override
  void dispose() {
    _tabController
        .removeListener(_onTabChanged); // Remove listener when disposed
    _tabController.dispose();
    super.dispose();
  }

  // Method to handle tab changes
  void _onTabChanged() {
    if (mounted) {
      setState(() {}); // Rebuild the widget when tab changes
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<Profile>(
      future: _profileFuture, // Load the profile only once
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // Loading indicator
        }

        if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}')); // Error handling
        }

        if (!snapshot.hasData) {
          return Center(child: Text('No data available')); // Handle empty data
        }

        Profile profile = snapshot.data!; // Get profile data

        return Scaffold(
          body: Column(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight - 58,
                color: Colors.indigo[300],
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: screenWidth,
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.08, // 8% of screen height
                          left: screenWidth * 0.02, // 2% of screen width
                          right: screenWidth * 0.025, // 2.5% of screen width
                          bottom: screenHeight * 0.55, // 55% of screen height
                        ),
                        clipBehavior: Clip.none,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: screenWidth * 0.30),
                                  Text(
                                    profile
                                        .username, // Dynamically use username
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.05,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.30),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Container(
                              width: double.infinity,
                              height: screenHeight * 0.14,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: screenWidth * 0.24,
                                    height: screenWidth * 0.24,
                                    decoration: ShapeDecoration(
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(profile.profileImage),
                                        fit: BoxFit.fill,
                                      ),
                                      shape: OvalBorder(),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 30.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              profile.posts.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: screenWidth * 0.05,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              'Posts',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: screenWidth * 0.04,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: screenWidth * 0.07),
                                        Column(
                                          children: [
                                            Text(
                                              profile.followers.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: screenWidth * 0.05,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              'Followers',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: screenWidth * 0.04,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: screenWidth * 0.07),
                                        Column(
                                          children: [
                                            Text(
                                              profile.following.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: screenWidth * 0.05,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              'Following',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: screenWidth * 0.04,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenWidth * 0.05,
                      top: screenHeight * 0.27,
                      child: Container(
                        height: screenHeight * 0.09,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  profile.name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenWidth * 0.05,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  profile.occupation,
                                  style: TextStyle(
                                    color: Color(0xFF8E8E8E),
                                    fontSize: screenWidth * 0.04,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Live in ${profile.location}',
                                  style: TextStyle(
                                    color: Color(0xFFD4E0ED),
                                    fontSize: screenWidth * 0.045,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenWidth * 0.03,
                      top: screenHeight * 0.38,
                      child: Container(
                        width: screenWidth * 0.95,
                        height: screenHeight * 0.045,
                        decoration: ShapeDecoration(
                          color: Color(0xFF757575),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.73),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Edit your profile...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xA5180B0B),
                              fontSize: screenWidth * 0.04,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Add TapBar widget here
                    Positioned(
                      left: screenWidth * 0.03,
                      top: screenHeight * 0.44, // Adjust position as needed
                      child: TapBar(
                          userId: widget.userId,
                          tabController:
                              _tabController), // Pass the TabController
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
