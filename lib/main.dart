import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'pages/feed_page.dart'; // Import the FeedPage
import 'pages/message_page.dart'; // Import the MessagesPage
import 'pages/add_page.dart'; // Import the AddContentPage
import 'pages/events_page.dart'; // Import the EventsPage
import 'pages/profile_page.dart'; // Import the ProfilePage
import 'pages/user_selection_screen.dart'; // Import the User Selection Screen
import 'widgets/bottom_bar.dart'; // Custom Bottom NavBar Widget
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'pages/intro_page.dart'; // Import the IntroPage

final cloudinary = Cloudinary.full(
  apiKey: '271545551245224',
  apiSecret: 'dJARs-6KCBwgU7_oYyvV08dz0lY',
  cloudName: 'dm5wyzkma',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Concurro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/intro', // Start with the Figma-inspired intro screen
      routes: {
        '/intro': (context) => const IntroPage(),
        '/user-selection': (context) => const UserSelectionScreen(),
        '/home': (context) => const MainPage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments passed from UserSelectionScreen
    final userArgs = ModalRoute.of(context)!.settings.arguments as Map?;
    final username = userArgs?['username'] ?? 'Guest';
    final profilePic = userArgs?['profilePic'] ?? 'assets/user_image.png';
    final userId = userArgs?['userId'] ?? '';

    // Define the pages with their arguments
    final List<Widget> pages = [
      FeedPage(
        userId: userId, // Pass userId to FeedPage
        username: username, // Pass username to FeedPage
        profilePic: profilePic, // Pass profilePic to FeedPage
      ),
      const MessagesPage(),
      AddContentPage(
        userId: userId, // Pass userId to AddContentPage
        username: username, // Pass username to AddContentPage
        profilePic: profilePic,
      ),
      EventsPage(
        userId: userId, // Pass userId to EventsPage
      ),
      ProfilePage(userId: userId), // Pass userId to ProfilePage
    ];

    void onNavItemTapped(int index) {
      setState(() {
        _selectedIndex = index; // Update the selected page
      });
    }

    return Scaffold(
      body: pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: onNavItemTapped,
        userProfilePicUrl: profilePic, // Pass profile pic to bottom navigation
      ),
    );
  }
}
