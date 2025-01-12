import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String userProfilePicUrl; // User's profile picture URL

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.userProfilePicUrl = 'assets/user_image.png', // Default image path
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue, // Blue background
      padding: const EdgeInsets.symmetric(vertical: 10), // Optional padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, "assets/icons/navigation1.png", currentIndex == 0),
          _buildNavItem(1, "assets/icons/navigation2.png", currentIndex == 1),
          _buildNavItem(2, "assets/icons/navigation3.png", currentIndex == 2),
          _buildNavItem(3, "assets/icons/navigation4.png", currentIndex == 3),
          _buildUserNavItem(
            4,
            userProfilePicUrl,
            currentIndex == 4,
          ), // Custom user button
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, bool isSelected) {
    return GestureDetector(
      onTap: () {
        onTap(index); // Trigger the callback to update the current index
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            height: 24, // Adjust the size of the icon
            fit: BoxFit.contain, // Ensures the image fits properly
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.error, // Fallback icon if asset is missing
              color: Colors.red,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 4,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserNavItem(int index, String profilePicUrl, bool isSelected) {
    return GestureDetector(
      onTap: () {
        onTap(index); // Trigger the callback to update the current index
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 30, // Circle size
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: profilePicUrl.startsWith('http')
                    ? NetworkImage(profilePicUrl)
                    : AssetImage(profilePicUrl)
                        as ImageProvider, // Dynamic image
                fit: BoxFit.cover,
              ),
              border: isSelected
                  ? Border.all(
                      color: Colors.white, width: 2) // Highlight when selected
                  : null,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 4,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}
