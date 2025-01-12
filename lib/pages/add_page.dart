import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore
import 'package:cloudinary_sdk/cloudinary_sdk.dart'; // Cloudinary SDK
import 'package:fluttertoast/fluttertoast.dart'; // Toast Notifications
import '../widgets/custom_button.dart'; // Import your custom button

class AddContentPage extends StatefulWidget {
  final String userId; // Pass the user ID to the page
  final String username; // Pass the username to the page
  final String profilePic; // Pass the user's profile picture URL to the page

  const AddContentPage({
    super.key,
    required this.userId,
    required this.username,
    required this.profilePic,
  });

  @override
  _AddContentPageState createState() => _AddContentPageState();
}

class _AddContentPageState extends State<AddContentPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  String? _capturedImagePath; // Store the captured or selected image path
  bool _isImageDisplayed = false; // Track if an image is displayed
  bool _hasPosted = false; // Track if the image is postedA
  final _cloudinary = Cloudinary.full(
    apiKey: '271545551245224', // Replace with your Cloudinary API key
    apiSecret: 'dJARs-6KCBwgU7_oYyvV08dz0lY', // Replace with your API secret
    cloudName: 'dm5wyzkma', // Replace with your Cloudinary cloud name
  );

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Get available cameras
      _cameras = await availableCameras();

      if (_cameras != null && _cameras!.isNotEmpty) {
        // Initialize the camera controller with the first camera
        _cameraController = CameraController(
          _cameras![0], // Use the first available camera
          ResolutionPreset.high,
          enableAudio: false, // Disable audio if not needed
        );

        await _cameraController!.initialize();
        setState(() {
          _isCameraInitialized = true; // Mark camera as initialized
        });
      } else {
        debugPrint("No cameras available");
      }
    } catch (e) {
      debugPrint("Error initializing camera: $e");
      setState(() {
        _isCameraInitialized =
            false; // Update UI if camera initialization fails
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  // Function to pick an image from the gallery
  Future<void> _openGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      setState(() {
        _capturedImagePath = selectedImage.path; // Display the selected image
        _isImageDisplayed = true; // Move to the "Post it" stage
      });
    }
  }

  // Function to capture an image
  Future<void> _captureImage() async {
    if (_cameraController != null) {
      try {
        final XFile file = await _cameraController!.takePicture();

        setState(() {
          _capturedImagePath = file.path;
          _isImageDisplayed = true; // Show the captured image
        });
      } catch (e) {
        debugPrint("Error capturing image: $e");
      }
    }
  }

  // Function to upload an image to Cloudinary and post to Firestore
  Future<void> _postImage() async {
    if (_capturedImagePath != null && !_hasPosted) {
      try {
        // Show a loading indicator during the upload
        Fluttertoast.showToast(msg: 'Uploading image...');
        final response = await _cloudinary.uploadResource(
          CloudinaryUploadResource(
            filePath: _capturedImagePath!,
            resourceType: CloudinaryResourceType.image,
            folder: 'flutter_uploads', // Optional: Cloudinary folder name
          ),
        );

        if (response.isSuccessful) {
          final uploadedImageUrl = response.secureUrl;

          // Save the post to Firestore
          await FirebaseFirestore.instance.collection('posts').add({
            'username': widget.username, // Replace with dynamic username
            'post_picture': uploadedImageUrl,
            'liked_by': [], // Default empty list of likes
            'created_at': FieldValue.serverTimestamp(), // Add a timestamp
          });

          setState(() {
            _hasPosted = true; // Mark as posted
          });

          Fluttertoast.showToast(msg: 'Image posted successfully!');
        } else {
          Fluttertoast.showToast(
              msg: 'Failed to upload image: ${response.error}');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[300],
      body: SafeArea(
        child: Stack(
          children: [
            // Fullscreen Camera Preview or Fullscreen Image
            if (_isImageDisplayed && _capturedImagePath != null)
              Positioned.fill(
                child: Image.file(
                  File(_capturedImagePath!),
                  fit: BoxFit.cover,
                ),
              )
            else if (_isCameraInitialized && _cameraController != null)
              Positioned.fill(
                child: CameraPreview(_cameraController!),
              ),

            // Top Navigation Bar with Back Button and Title
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_isImageDisplayed) {
                            // Return to camera preview when an image is displayed
                            setState(() {
                              _isImageDisplayed = false;
                              _capturedImagePath = null; // Clear image path
                              _hasPosted = false; // Reset post state
                            });
                          } else {
                            Navigator.pop(
                                context); // Navigate to the previous page
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Text(
                          'Add Content',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),

            // Bottom Capture Button
            if (!_isImageDisplayed)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: _captureImage,
                    child: Image.asset(
                      'assets/capture_button.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
              ),

            // Bottom-Left Gallery Icon
            if (!_isImageDisplayed)
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 25.0, horizontal: 25.0),
                  child: GestureDetector(
                    onTap: _openGallery,
                    child: const Icon(
                      Icons.photo_library,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),

            // "Post it" Button in Display Mode
            if (_isImageDisplayed)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomButton(
                    label: _hasPosted ? "Posted it!" : "Post it ✅",
                    color: _hasPosted
                        ? Colors.grey.withOpacity(0.7)
                        : Colors.green,
                    textColor: Colors.white,
                    onPressed:
                        _postImage, // Call the function to post the image
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
