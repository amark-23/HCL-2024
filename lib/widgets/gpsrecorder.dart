import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationRecorderWithMap extends StatefulWidget {
  const LocationRecorderWithMap({Key? key}) : super(key: key);

  @override
  _LocationRecorderWithMapState createState() =>
      _LocationRecorderWithMapState();
}

class _LocationRecorderWithMapState extends State<LocationRecorderWithMap> {
  bool _isRecording = false;
  LatLng? _startLocation;
  LatLng? _endLocation;
  StreamSubscription<Position>? _positionSubscription;
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  List<LatLng> _routePoints = []; // For the polyline

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _stopRecording();
    super.dispose();
  }

  // Fetch current location
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(_currentLocation!),
    );
  }

  // Toggle recording
  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (_isRecording) {
      _startRecording();
    } else {
      _stopRecording();
    }
  }

  // Start recording
  Future<void> _startRecording() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _startLocation = LatLng(position.latitude, position.longitude);
      _endLocation = null; // Clear the previous ending location
      _routePoints = []; // Clear the previous route
    });

    // Start listening to location updates
    _positionSubscription = Geolocator.getPositionStream().listen((position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    });
  }

  // Stop recording
  Future<void> _stopRecording() async {
    if (_currentLocation != null) {
      setState(() {
        _endLocation = _currentLocation;
      });
    }
    _positionSubscription?.cancel();
    _positionSubscription = null;

    // Fetch and draw the route
    if (_startLocation != null && _endLocation != null) {
      await _fetchRoute(_startLocation!, _endLocation!);
    }
  }

  // Fetch the route from Google Maps Directions API
  Future<void> _fetchRoute(LatLng start, LatLng end) async {
    const apiKey = 'AIzaSyA1HQnt2TvfmbiBBVh8PGaE_cw5MVdu9_A';
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final points = data['routes'][0]['overview_polyline']['points'];
      setState(() {
        _routePoints = _decodePolyline(points);
      });
    } else {
      print('Failed to fetch directions: ${response.body}');
    }
  }

  // Decode the polyline from the API response
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }

  // Build markers for starting and ending locations
  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};
    if (_startLocation != null) {
      markers.add(
        Marker(
          markerId: MarkerId("start"),
          position: _startLocation!,
          infoWindow: const InfoWindow(title: "Starting Location"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }
    if (_endLocation != null) {
      markers.add(
        Marker(
          markerId: MarkerId("end"),
          position: _endLocation!,
          infoWindow: const InfoWindow(title: "Ending Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GPS Recorder"),
      ),
      body: Stack(
        children: [
          if (_currentLocation != null)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              markers: _buildMarkers(),
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: _routePoints,
                  color: Colors.blue,
                  width: 5,
                ),
              },
              myLocationEnabled: true,
            ),
          if (_currentLocation == null)
            const Center(
                child: CircularProgressIndicator()), // Show a loading spinner
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _toggleRecording,
              child: Icon(_isRecording ? Icons.stop : Icons.play_arrow),
              backgroundColor: _isRecording ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
