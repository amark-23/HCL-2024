import 'package:flutter/material.dart';
import '../pages/feed_page.dart'; // Import the FeedPage
import '../pages/message_page.dart'; // Import the MessagesPage
import '../pages/add_page.dart'; // Import the AddContentPage
import '../pages/events_page.dart'; // Import the EventsPage
import '../pages/profile_page.dart'; // Import the ProfilePage

import 'widgets/bottom_bar.dart'; // Custom Bottom NavBar Widget

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Namer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // List of pages, excluding CreateEventPage and HistoryEventPage
  final List<Widget> _pages = [
    const FeedPage(),
    const MessagesPage(),
    const AddContentPage(),
    const EventsPage(),
    const ProfilePage(),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex, // Pass currentIndex
        onTap: _onNavItemTapped, // Pass onTap function
      ),
    );
  }
}
