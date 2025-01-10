import 'package:flutter/material.dart';
import '../widgets/event_card.dart'; // Reusable EventCard widget
import '../classes/event.dart'; // Event model
import '../data/history_events.dart'; // Dummy data for history events

class HistoryEventsPage extends StatelessWidget {
  const HistoryEventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy list of historical events
    final List<Event> historyEvents = historyEventsData;

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
        child: ListView.builder(
          itemCount: historyEvents.length,
          itemBuilder: (context, index) {
            final event = historyEvents[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: EventCard(
                title: event.title,
                subtitle: event.subtitle,
                imagePath: event.imagePath,
              ),
            );
          },
        ),
      ),
    );
  }
}
