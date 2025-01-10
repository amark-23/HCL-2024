import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/custom_button.dart'; // Import the CustomButton widget

class EventInfoPage extends StatefulWidget {
  @override
  _EventInfoPageState createState() => _EventInfoPageState();
}

class _EventInfoPageState extends State<EventInfoPage> {
  bool _isJoined = false; // Track whether the "Join" button is pressed
  late GoogleMapController _mapController; // Controller for the Google Map

  // Define the starting and ending points
  final LatLng _startingPoint =
      const LatLng(37.9755, 23.7348); // Museum of Ancient Greece
  final LatLng _endPoint =
      const LatLng(37.9942, 23.7320); // Athens University of Economics

  // Create markers for the starting and ending points
  final Set<Marker> _markers = {
    Marker(
      markerId: const MarkerId('startingPoint'),
      position: const LatLng(37.9755, 23.7348),
      infoWindow: const InfoWindow(
        title: 'Starting Point',
        snippet: 'Museum of Ancient Greece',
      ),
    ),
    Marker(
      markerId: const MarkerId('endPoint'),
      position: const LatLng(37.9942, 23.7320),
      infoWindow: const InfoWindow(
        title: 'End Point',
        snippet: 'Athens University of Economics',
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
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
                      color: _isJoined
                          ? Colors.green.withOpacity(
                              0.7) // Change color to green when joined
                          : const Color.fromARGB(
                              255, 34, 170, 68), // Original Join color
                      textColor: _isJoined
                          ? Colors.white
                          : Colors
                              .black, // Change text color to white if joined
                      onPressed: () {
                        setState(() {
                          _isJoined = !_isJoined; // Toggle button state
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8), // Adjust space between the buttons
                  Expanded(
                    child: CustomButton(
                      label: "Message",
                      color: Colors.blue, // Use blue color for Message button
                      onPressed: () {
                        // Add functionality for the Message button
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Map Section
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight:
                          Radius.circular(15)), // Rounded corners for the map
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller; // Save the map controller
                    },
                    initialCameraPosition: CameraPosition(
                      target: _startingPoint,
                      zoom: 14.0, // Initial zoom level
                    ),
                    markers: _markers,
                  ),
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
                      bottomRight: Radius.circular(15)),
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
                    const Text(
                      "Museum of Ancient Greece",
                      style: TextStyle(
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
                    const Text(
                      "Athens University of Economics",
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.grey),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Distance:",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "4.5 km",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
