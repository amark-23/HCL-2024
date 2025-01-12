import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BottomFrame extends StatelessWidget {
  final bool isLiked;
  final ValueChanged<bool> onLikeToggle;
  final String username;
  final String profilePicUrl;
  final double iconSize;

  const BottomFrame({
    super.key,
    required this.isLiked,
    required this.onLikeToggle,
    required this.username,
    required this.profilePicUrl,
    this.iconSize = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 208,
      decoration: BoxDecoration(
        color: const Color.fromARGB(
            0, 255, 255, 255), // Fully transparent background
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info: Username and Profile Image
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                          profilePicUrl), // Use the passed profilePicUrl
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Displaying the dynamic username
                Text(
                  username, // The passed dynamic username
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Action Icons: Like and Comment
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Like Icon
                GestureDetector(
                  onTap: () => onLikeToggle(!isLiked),
                  child: Image.asset(
                    isLiked
                        ? 'assets/icons/heart_filled.png'
                        : 'assets/icons/heart_outline.png',
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
                const SizedBox(width: 80),
                // Comment Icon
                GestureDetector(
                  onTap: () {
                    _showCommentOverlay(context);
                  },
                  child: Image.asset(
                    'assets/icons/comment_icon.png',
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method to show the overlay for comments
  void _showCommentOverlay(BuildContext context) {
    // Show overlay using showDialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController commentController = TextEditingController();
        return Dialog(
          backgroundColor: Colors.transparent, // Transparent background
          elevation: 0,
          child: Container(
            width: 500, // Increased width of the overlay
            height: 79, // Total height of the overlay
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Column(
              children: [
                // Confirmation message: "Sent your comment!" (Above the input box)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 130, 1),
                  child: Text(
                    'Sent your comment!',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Color.fromARGB(
                          255, 72, 112, 241), // Light color for text
                      fontSize: 14, // Smaller font size
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                // Comment Input Field
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: ShapeDecoration(
                    color: Color(
                        0xFFD9D9D9), // Background color for the input area
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      // TextField for entering comment
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Enter your comment...',
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ),
                      // Upwards Arrow icon next to the text field
                      GestureDetector(
                        onTap: () {
                          String comment = commentController.text.trim();
                          if (comment.isNotEmpty) {
                            // Handle the comment submission (e.g., print to console)
                            print('Comment submitted: $comment');
                          }
                          Navigator.pop(
                              context); // Close the overlay after submission
                        },
                        child: Icon(
                          Icons.arrow_upward,
                          color: Colors.green,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
