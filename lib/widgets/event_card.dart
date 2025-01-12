import 'package:flutter/material.dart';
import '../pages/event_info_page.dart'; // Import the EventInfoPage

class EventCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath; // This could be a URL or local asset path
  final String eventId; // Add eventId to pass it to EventInfoPage
  final String userId;

  const EventCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.imagePath,
      required this.eventId, // Accept eventId as a parameter
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          // Navigate to EventInfoPage on tap, passing necessary data including eventId
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventInfoPage(
                title: title, // Pass the title
                subtitle: subtitle, // Pass the subtitle
                imagePath: imagePath, // Pass the image path
                eventId: eventId, // Pass the eventId here
                userId: userId,
              ),
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
              backgroundImage: _getImageProvider(imagePath), // Update this line
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

  // Helper method to determine whether the image is a local asset or a network URL
  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      // If the path starts with http or https, treat it as a network URL
      return NetworkImage(imagePath);
    } else {
      // Otherwise, treat it as a local asset path
      return AssetImage(imagePath);
    }
  }
}
