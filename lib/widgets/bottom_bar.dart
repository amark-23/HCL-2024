import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

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
          _buildNavItem(4, "assets/icons/navigation5.png", currentIndex == 4),
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
}
