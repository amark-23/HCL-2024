import 'package:flutter/material.dart';
import '../pages/event_info_page.dart'; // Import the EventInfoPage

class EventCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const EventCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          // Navigate to EventInfoPage on tap
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EventInfoPage(), // Pass necessary data here if needed
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.indigo[100],
            borderRadius: BorderRadius.circular(50),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(
                  imagePath), // Event image (e.g., user profile image)
            ),
            title: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.orange,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
