import 'package:flutter/material.dart';
import '../widgets/event_card.dart'; // Reusable EventCard widget
//import '../classes/event.dart'; // Event model
import '../data/following_events.dart'; // Dummy data for following events
import '../data/recommended_events.dart'; // Dummy data for recommended events
import '../widgets/custom_button.dart'; // CustomButton widget
import '../pages/history_events_page.dart';
import '../pages/create_event_page.dart'; // Import the CreateEventPage

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  int _currentIndex = 0; // Track the current page index

  // Create a PageController to manage the pages
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[300], // Matches the blue background
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar with Back Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(
                          context); // Navigate back to the previous page
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
            // Tab Navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
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
                        _pageController.animateToPage(1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
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
            // PageView for Swipe Navigation
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index; // Update the current index
                  });
                },
                children: [
                  // Following Events List
                  ListView.builder(
                    itemCount: followingEvents.length,
                    itemBuilder: (context, index) {
                      final event = followingEvents[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0), // Add spacing
                        child: EventCard(
                          title: event.title,
                          subtitle: event.subtitle,
                          imagePath: event.imagePath,
                        ),
                      );
                    },
                  ),
                  // Recommended Events List
                  ListView.builder(
                    itemCount: recommendedEvents.length,
                    itemBuilder: (context, index) {
                      final event = recommendedEvents[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0), // Add spacing
                        child: EventCard(
                          title: event.title,
                          subtitle: event.subtitle,
                          imagePath: event.imagePath,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Buttons Above Bottom Navigation Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'History',
                      color: Colors.grey[400]!,
                      onPressed: () {
                        // Navigate to the History Events Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HistoryEventsPage(),
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
                        // Navigate to the Create Event Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateEventPage(),
                          ),
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
    );
  }
}
