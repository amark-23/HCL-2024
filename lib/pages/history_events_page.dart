import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/event_card.dart'; // Reusable EventCard widget

class HistoryEventsPage extends StatefulWidget {
  final String userId; // User's ID passed to this page

  const HistoryEventsPage({super.key, required this.userId});

  @override
  _HistoryEventsPageState createState() => _HistoryEventsPageState();
}

class _HistoryEventsPageState extends State<HistoryEventsPage> {
  bool _isLoading = true; // Track loading state
  List<Map<String, dynamic>> _historyEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchHistoryEvents();
  }

  Future<void> _fetchHistoryEvents() async {
    try {
      // Fetch events that the user has joined and the event datetime is in the past
      final eventsSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('joined_list', arrayContains: widget.userId)
          .get();

      List<Map<String, dynamic>> historyEvents = [];

      // Loop through each event and gather the necessary data
      for (var doc in eventsSnapshot.docs) {
        final data = doc.data();
        final eventId = doc.id; // Get the event ID (document ID)
        final name = data['name']; // Event name (title)
        final datetime =
            data['datetime'] as Timestamp; // Event datetime (timestamp)
        final creatorId = data['creator']; // User ID of the event creator

        // Convert Timestamp to DateTime
        final eventDateTime = datetime.toDate(); // Convert to DateTime object

        // Only add events that have already passed
        if (eventDateTime.isBefore(DateTime.now())) {
          // Fetch the profile picture of the event creator
          final profilePic = await _getProfilePicture(creatorId);

          historyEvents.add({
            'eventId': eventId,
            'title': name,
            'subtitle': DateFormat('dd-MM-yyyy')
                .format(eventDateTime), // Change date format to dd-MM-yyyy
            'creatorId': creatorId,
            'profilePic': profilePic,
          });
        }
      }

      setState(() {
        _historyEvents = historyEvents; // Update the list of history events
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching history events: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fetch the profile picture of the user by their user ID
  Future<String> _getProfilePicture(String creatorId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(creatorId)
          .get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data();
        return userData?['profile_pic'] ??
            'assets/user_image.png'; // Default if not found
      }
      return 'assets/user_image.png'; // Default if user doesn't exist
    } catch (e) {
      print("Error fetching profile picture: $e");
      return 'assets/user_image.png'; // Default if error occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[300], // Matches the blue background
      appBar: AppBar(
        backgroundColor: Colors.indigo[400],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
        title: const Text(
          'History Events',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _historyEvents.isEmpty
                ? const Center(child: Text("No past events found"))
                : ListView.builder(
                    itemCount: _historyEvents.length,
                    itemBuilder: (context, index) {
                      final event = _historyEvents[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 16.0),
                        child: EventCard(
                          title: event['title'],
                          subtitle: event['subtitle'],
                          imagePath: event['profilePic'],
                          eventId: event['eventId'], // Pass eventId here
                          userId: widget.userId,
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
