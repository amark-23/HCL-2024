import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../widgets/event_card.dart'; // Reusable EventCard widget
import '../widgets/custom_button.dart'; // CustomButton widget
import '../pages/history_events_page.dart';
import '../pages/create_event_page.dart'; // Import the CreateEventPage

class EventsPage extends StatefulWidget {
  final String userId; // User's ID passed to this page

  const EventsPage({super.key, required this.userId});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  int _currentIndex = 0; // Track the current tab index
  List<Map<String, dynamic>> _followingEvents = [];
  List<Map<String, dynamic>> _recommendedEvents = [];
  bool _isLoading = true; // Track loading state

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _fetchEvents(); // Fetch events on page initialization
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true; // Show loading indicator while fetching events
    });

    try {
      final currentTime = Timestamp.now();
      print("[DEBUG] Current time: ${currentTime.toDate()}");

      // Fetch all events from Firestore
      final eventsSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .orderBy('datetime', descending: true)
          .get();

      print("[DEBUG] Number of events fetched: ${eventsSnapshot.docs.length}");

      List<Map<String, dynamic>> followingEvents = [];
      List<Map<String, dynamic>> recommendedEvents = [];

      for (var doc in eventsSnapshot.docs) {
        final data = doc.data();
        final eventId = doc.id;
        print("[DEBUG] Processing event: $eventId, Data: $data");

        // Check for required fields and log missing ones
        if (!data.containsKey('joined_list') || !data.containsKey('datetime')) {
          print("[ERROR] Missing fields in event: $eventId");
          continue;
        }

        final joinedList = List<String>.from(data['joined_list'] ?? []);
        final name = data['name'] ?? 'Unnamed Event';
        final creatorId = data['creator'] ?? '';
        final profilePic = await _getProfilePicture(creatorId);

        // Handle datetime type mismatch (String vs Timestamp)
        Timestamp datetime;
        try {
          if (data['datetime'] is String) {
            datetime = Timestamp.fromDate(DateTime.parse(data['datetime']));
            print("[DEBUG] Parsed datetime from string: ${datetime.toDate()}");
          } else if (data['datetime'] is Timestamp) {
            datetime = data['datetime'] as Timestamp;
          } else {
            print("[ERROR] Unsupported datetime format for event: $eventId");
            continue;
          }
        } catch (e) {
          print(
              "[ERROR] Error parsing datetime for event: $eventId, Error: $e");
          continue;
        }

        // Skip past events
        if (datetime.toDate().isBefore(currentTime.toDate())) {
          print(
              "[DEBUG] Skipping past event: $eventId (Date: ${datetime.toDate()})");
          continue;
        }

        final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(datetime.toDate()); // Format datetime for display

        print("[DEBUG] Event: $name, Date: $formattedDate");

        if (joinedList.contains(widget.userId)) {
          print("[DEBUG] Adding to following events: $name");
          followingEvents.add({
            'eventId': eventId,
            'title': name,
            'subtitle': formattedDate,
            'creatorId': creatorId,
            'profilePic': profilePic,
          });
        } else {
          print("[DEBUG] Adding to recommended events: $name");
          recommendedEvents.add({
            'eventId': eventId,
            'title': name,
            'subtitle': formattedDate,
            'creatorId': creatorId,
            'profilePic': profilePic,
          });
        }
      }

      setState(() {
        _followingEvents = followingEvents;
        _recommendedEvents = recommendedEvents;
        _isLoading = false; // Stop loading when data is fetched
      });

      print("[DEBUG] Following events count: ${_followingEvents.length}");
      print("[DEBUG] Recommended events count: ${_recommendedEvents.length}");
    } catch (e) {
      print("[ERROR] Error fetching events: $e");
      setState(() {
        _isLoading = false; // Stop loading even if there was an error
      });
    }
  }

  Future<String> _getProfilePicture(String creatorId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(creatorId)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot.data()?['profile_pic'] ?? 'assets/user_image.png';
      }
      return 'assets/user_image.png'; // Default profile picture
    } catch (e) {
      print("Error fetching profile picture: $e");
      return 'assets/user_image.png'; // Default in case of error
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[300],
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Navigate back
                    },
                  ),
                  const Text(
                    'Events',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Tabs for Following and Recommended
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            'Following',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _currentIndex == 0
                                  ? Colors.white
                                  : Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Divider(
                            color: _currentIndex == 0
                                ? Colors.white
                                : Colors.transparent,
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            'Recommended',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _currentIndex == 1
                                  ? Colors.white
                                  : Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Divider(
                            color: _currentIndex == 1
                                ? Colors.white
                                : Colors.transparent,
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // PageView for Following and Recommended Events
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      children: [
                        // Following Events List
                        ListView.builder(
                          itemCount: _followingEvents.length,
                          itemBuilder: (context, index) {
                            final event = _followingEvents[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 4.0,
                              ),
                              child: EventCard(
                                title: event['title'],
                                subtitle: event['subtitle'],
                                imagePath: event['profilePic'],
                                eventId: event['eventId'],
                                userId: widget.userId,
                              ),
                            );
                          },
                        ),
                        // Recommended Events List
                        ListView.builder(
                          itemCount: _recommendedEvents.length,
                          itemBuilder: (context, index) {
                            final event = _recommendedEvents[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 4.0,
                              ),
                              child: EventCard(
                                title: event['title'],
                                subtitle: event['subtitle'],
                                imagePath: event['profilePic'],
                                eventId: event['eventId'],
                                userId: widget.userId,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
            ),
            // History and Create Event Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'History',
                      color: Colors.grey[400]!,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HistoryEventsPage(userId: widget.userId),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      label: 'Create Event',
                      color: Colors.green,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CreateEventPage(userId: widget.userId),
                          ),
                        ).then((_) => _fetchEvents()); // Refresh events
                      },
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
