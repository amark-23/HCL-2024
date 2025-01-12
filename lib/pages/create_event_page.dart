import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // For datetime formatting
import 'dart:math';

double _calculateDistance(GeoPoint start, GeoPoint end) {
  const double radius = 6371; // Radius of Earth in kilometers

  double lat1 = start.latitude;
  double lon1 = start.longitude;
  double lat2 = end.latitude;
  double lon2 = end.longitude;

  double dlat = _degreesToRadians(lat2 - lat1);
  double dlon = _degreesToRadians(lon2 - lon1);

  double a = sin(dlat / 2) * sin(dlat / 2) +
      cos(_degreesToRadians(lat1)) *
          cos(_degreesToRadians(lat2)) *
          sin(dlon / 2) *
          sin(dlon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return radius * c; // Distance in kilometers
}

double _degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

class CreateEventPage extends StatefulWidget {
  final String userId;

  const CreateEventPage({super.key, required this.userId});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _startingLocationController =
      TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _maxParticipants = 1;

  final String googleMapsApiKey =
      'AIzaSyA1HQnt2TvfmbiBBVh8PGaE_cw5MVdu9_A'; // Replace with your API key

  // Function to pick date and time for the event
  Future<void> _pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
        });
      }
    }
  }

  // Function to fetch coordinates using Geocoding API
  Future<GeoPoint?> _getCoordinates(String address) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$googleMapsApiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final location = data['results'][0]['geometry']['location'];
          return GeoPoint(location['lat'], location['lng']);
        } else {
          print('Error: ${data['status']}');
        }
      } else {
        print(
            'Failed to fetch coordinates. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching coordinates: $e');
    }
    return null;
  }

  Future<void> _createEvent() async {
    try {
      // Get input values
      String eventName = _eventNameController.text.trim();
      String startingLocation = _startingLocationController.text.trim();
      String endLocation = _endLocationController.text.trim();
      String description = _descriptionController.text.trim();

      // Ensure date and time are selected
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select date and time.')),
        );
        return;
      }

      // Combine date and time into a single DateTime object
      DateTime dateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // Validate other input fields
      if (eventName.isEmpty ||
          startingLocation.isEmpty ||
          endLocation.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields.')),
        );
        return;
      }

      // Fetch coordinates for starting and ending locations
      GeoPoint? startGeo = await _getCoordinates(startingLocation);
      GeoPoint? endGeo = await _getCoordinates(endLocation);

      if (startGeo == null || endGeo == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to get location coordinates.')),
        );
        return;
      }

      // Calculate the distance between the two locations
      double distance = _calculateDistance(startGeo, endGeo);

      // Event data to upload
      Map<String, dynamic> eventData = {
        'name': eventName,
        'starting_point': startingLocation,
        'end_point': endLocation,
        'description': description,
        'datetime': dateTime, // Directly store the DateTime object
        'max': _maxParticipants,
        'distance': distance, // Use calculated distance
        'creator': widget.userId,
        'start_geo': startGeo,
        'end_geo': endGeo,
        'joined_list': [widget.userId]
      };

      // Upload to Firebase
      await FirebaseFirestore.instance.collection('events').add(eventData);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created successfully!')),
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      print('Error creating event: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create event.')),
      );
    }
  }

  // Modal for adding description
  void _showDescriptionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Enter event description...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[300],
      appBar: AppBar(
        backgroundColor: Colors.indigo[400],
        title: const Text(
          'Creating Event',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Event Name', style: TextStyle(color: Colors.white)),
            TextField(
              controller: _eventNameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.indigo[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text('Starting Location',
                style: TextStyle(color: Colors.white)),
            TextField(
              controller: _startingLocationController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.indigo[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text('End Location', style: TextStyle(color: Colors.white)),
            TextField(
              controller: _endLocationController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.indigo[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Max Participants',
                          style: TextStyle(color: Colors.white)),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (_maxParticipants > 1) _maxParticipants--;
                              });
                            },
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.white),
                          ),
                          Text('$_maxParticipants',
                              style: const TextStyle(color: Colors.white)),
                          IconButton(
                            onPressed: () => setState(() => _maxParticipants++),
                            icon: const Icon(Icons.add_circle,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Date & Time',
                          style: TextStyle(color: Colors.white)),
                      GestureDetector(
                        onTap: () => _pickDateTime(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.indigo[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _selectedDate != null && _selectedTime != null
                                ? '${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.year} ${_selectedTime!.format(context)}'
                                : 'Select Date & Time',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text('Add Description',
                style: TextStyle(color: Colors.white)),
            GestureDetector(
              onTap: _showDescriptionModal,
              child: Container(
                width: double.infinity,
                height: 100,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.indigo[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  _descriptionController.text.isNotEmpty
                      ? _descriptionController.text
                      : 'Add Description...',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: _createEvent,
                    child: const Text('Create'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
