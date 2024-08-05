import 'package:digi_card/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  final TextRecognizer _textRecognizer = TextRecognizer();
  bool _isCameraInitialized = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (!await _requestCameraPermission()) {
      setState(() {
        _errorMessage = 'Camera permission denied';
      });
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = 'No cameras found';
        });
        return;
      }

      final firstCamera = cameras.first;
      _controller = CameraController(
        firstCamera,
        ResolutionPreset.high,
      );

      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture;

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error initializing camera: $e';
      });
    }
  }

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<Map<String, String>> _processImage(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    return _parseBusinessCardText(recognizedText.text);
  }

  Map<String, String> _parseBusinessCardText(String text) {
    final lines = text.split('\n');
    final cardInfo = <String, String>{};

    String? name;
    String? title;
    String? company;
    String? phone;
    String? email;
    String? address;
    String? website;

    for (var line in lines) {
      line = line.trim();
      if (name == null &&
          line.split(' ').length > 1 &&
          !line.contains('@') &&
          !line.contains('www.')) {
        name = line;
      } else if (title == null &&
          !line.contains('@') &&
          !line.contains(RegExp(r'\d')) &&
          line.split(' ').length <= 5 &&
          line != line.toUpperCase()) {
        title = line;
      } else if (company == null &&
          line.toUpperCase() == line &&
          line != name) {
        company = line;
      } else if (phone == null &&
          line.contains(RegExp(r'\d{3}[-\.\s]?\d{3}[-\.\s]?\d{4}'))) {
        phone = line;
      } else if (email == null && line.contains('@')) {
        email = line;
      } else if (address == null &&
          (line.contains('St.') ||
              line.contains('Ave.') ||
              line.contains('Rd.'))) {
        address = line;
      } else if (website == null && line.contains('www.')) {
        website = line;
      }
    }

    if (name != null) cardInfo['name'] = name;
    if (title != null) cardInfo['title'] = title;
    if (company != null) cardInfo['company'] = company;
    if (phone != null) cardInfo['phone'] = phone;
    if (email != null) cardInfo['email'] = email;
    if (address != null) cardInfo['address'] = address;
    if (website != null) cardInfo['website'] = website;

    return cardInfo;
  }

  @override
  void dispose() {
    _controller?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Text(_errorMessage),
        ),
      );
    }

    if (!_isCameraInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller!),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton(
                onPressed: () async {
                  try {
                    // Inside the FloatingActionButton's onPressed callback
                    final image = await _controller!.takePicture();

                    // Process the image and recognize text
                    final cardInfo = await _processImage(image);

                    // Save the image to a file
                    final directory = await getApplicationDocumentsDirectory();
                    final imagePath =
                        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
                    await File(image.path).copy(imagePath);

// Navigate to ProfileScreen with the image file and extracted information
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          imageFile: File(imagePath),
                          cardInfo: cardInfo,
                        ),
                      ),
                    );
                  } catch (e) {
                    print('Error capturing or processing image: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Error capturing or processing image')),
                    );
                  }
                },
                child: Icon(Icons.camera_alt),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
