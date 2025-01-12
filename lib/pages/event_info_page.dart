import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import '../widgets/custom_button.dart'; // Import the CustomButton widget
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth for user ID

class EventInfoPage extends StatefulWidget {
  final String title; // Add the event title
  final String subtitle; // Add the event subtitle
  final String imagePath; // Add the image path
  final String eventId; // The eventId is the Firestore document ID
  final String userId;

  const EventInfoPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.eventId,
    required this.userId,
  });

  @override
  _EventInfoPageState createState() => _EventInfoPageState();
}

LatLng _startingPoint = LatLng(0.0, 0.0); // Default to (0.0, 0.0)
LatLng _endPoint = LatLng(0.0, 0.0); // Default to (0.0, 0.0)

class _EventInfoPageState extends State<EventInfoPage> {
  bool _isJoined = false; // Track whether the "Join" button is pressed
  late GoogleMapController _mapController; // Controller for the Google Map
  String eventDescription = ''; // Store the event description

  double eventDistance = 0.0;
  String startName = '';
  String endName = '';
  DateTime eventDatetime =
      DateTime.now(); // Initializes with the current date and time

  final Set<Marker> _markers = {};

  Future<void> _fetchEventData() async {
    try {
      // Fetch the event document from Firestore using eventId
      DocumentSnapshot eventDoc = await FirebaseFirestore.instance
          .collection('events') // Ensure this is the correct collection name
          .doc(widget.eventId) // Use widget.eventId to fetch specific event
          .get();

      if (eventDoc.exists) {
        // Debug: Print the fetched document data
        print('Fetched Event Data: ${eventDoc.data()}');

        setState(() {
          // Check if the start_geo and end_geo fields exist and are GeoPoints
          if (eventDoc['start_geo'] != null &&
              eventDoc['start_geo'] is GeoPoint) {
            _startingPoint = LatLng(
              (eventDoc['start_geo'] as GeoPoint).latitude,
              (eventDoc['start_geo'] as GeoPoint).longitude,
            );
          } else {
            _startingPoint =
                LatLng(0.0, 0.0); // Set to default or error location
          }

          if (eventDoc['end_geo'] != null && eventDoc['end_geo'] is GeoPoint) {
            _endPoint = LatLng(
              (eventDoc['end_geo'] as GeoPoint).latitude,
              (eventDoc['end_geo'] as GeoPoint).longitude,
            );
          } else {
            _endPoint = LatLng(0.0, 0.0); // Set to default or error location
          }

          eventDescription =
              eventDoc['description'] ?? 'No description available';

          // Update the markers dynamically
          _markers.add(Marker(
            markerId: const MarkerId('startingPoint'),
            position: _startingPoint,
            infoWindow: InfoWindow(
              title: eventDoc['starting_point'] ?? 'Starting Point',
            ),
          ));

          _markers.add(Marker(
            markerId: const MarkerId('endPoint'),
            position: _endPoint,
            infoWindow: InfoWindow(
              title: eventDoc['end_point'] ?? 'End Point',
            ),
          ));

          eventDistance = (eventDoc['distance'] is int)
              ? eventDoc['distance']
                  .toDouble() // If it's an int, convert it to double
              : eventDoc['distance']; // Otherwise, it's already a double

          startName = eventDoc['starting_point'];
          endName = eventDoc['end_point'];

          // Set the event datetime
          eventDatetime = (eventDoc['datetime'] as Timestamp).toDate();

          // Check if the current user is in the joined_list
          List<dynamic> joinedList = eventDoc['joined_list'] ?? [];
          _isJoined = joinedList
              .contains(widget.userId); // Check if userId is in the joined_list
        });
      } else {
        // Handle case where the document doesn't exist
        setState(() {
          eventDescription = 'Event not found.';
        });
      }

      if (_startingPoint.latitude != 0.0 && _startingPoint.longitude != 0.0) {
        _mapController.animateCamera(
          CameraUpdate.newLatLng(_startingPoint),
        );
      }
    } catch (e) {
      print('Error fetching event data: $e');
    }
  }

  void _showDescriptionOverlay() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Rounded corners
          ),
          backgroundColor: Colors.white, // Set background color to white
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Add padding around content
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // To make the dialog wrap its content
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Event Description",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  eventDescription,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign:
                      TextAlign.justify, // Justify text for better readability
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _toggleJoinEvent() async {
    if (_isJoined) return; // If already joined, do nothing

    try {
      // Add the user's ID to the joined_list
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
          .update({
        'joined_list': FieldValue.arrayUnion([widget.userId]),
      });

      setState(() {
        _isJoined = true; // Set the button state to "Joined"
      });
    } catch (e) {
      print('Error adding user to joined_list: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchEventData(); // Fetch event data when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    // Check if the event has passed and disable the button if true
    bool isEventPassed = eventDatetime.isBefore(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.indigo[300], // Matches the blue background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  const Expanded(
                    child: Text(
                      'Event Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Spacer to balance alignment
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Buttons (Join & Message) above the map
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      label: _isJoined
                          ? "Joined!"
                          : "Join", // Change label based on state
                      color: isEventPassed
                          ? Colors.red.withOpacity(0.5)
                          : (_isJoined
                              ? Colors.green.withOpacity(0.7)
                              : const Color.fromARGB(255, 34, 170, 68)),
                      textColor: _isJoined || isEventPassed
                          ? Colors.white
                          : Colors.black,
                      onPressed: isEventPassed
                          ? () {} // Empty function does nothing
                          : _toggleJoinEvent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomButton(
                      label: "Message",
                      color: Colors.blue,
                      onPressed: () {
                        // Add functionality for the Message button
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Map Section - Increase size of the map
            Container(
              height: 300,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                    // Move the camera if starting point is valid
                    if (_startingPoint.latitude != 0.0 ||
                        _startingPoint.longitude != 0.0) {
                      _mapController.animateCamera(
                        CameraUpdate.newLatLng(_startingPoint),
                      );
                    }
                  },
                  initialCameraPosition: CameraPosition(
                    target: _startingPoint,
                    zoom: 14.0,
                  ),
                  markers: _markers,
                ),
              ),
            ),

            // Event Details Box
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Starting Point:",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      startName, // Display the starting point name
                      style: const TextStyle(
                        color: Colors.indigo,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "End Point:",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      endName, // Display the end point name
                      style: const TextStyle(
                        color: Colors.indigo,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.grey),

                    // Distance Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Distance:",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${eventDistance.toStringAsFixed(2)} km',
                          style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 8),

                    // Description Section
                    GestureDetector(
                      onTap: _showDescriptionOverlay,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 27, 28, 29),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
