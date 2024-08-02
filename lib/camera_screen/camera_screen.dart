import 'package:digi_card/models/business_card.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  BusinessCard _businessCard = BusinessCard();

  Future<void> scanBussinessCard(ImageSource imageSource) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: imageSource);

    if (image != null) {
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      String text = recognizedText.text;
      _processText(text);
      textRecognizer.close();
    }
  }

  // void _processText(String text) {
  //   final lines = text.split('\n');

  //   if (lines.isNotEmpty) _businessCard.fullName = lines[0];
  //   if (lines.length > 1) _businessCard.jobTitle = lines[1];

  //   for (String line in lines) {
  //     if (line.contains('@')) _businessCard.email = line;
  //     if (line.contains(',')) _businessCard.location = line;
  //   }
  //   setState(() {
  //     nameController.text = _businessCard.fullName;
  //     jobController.text = _businessCard.jobTitle;
  //     emailController.text = _businessCard.email;
  //     locationController.text = _businessCard.location;
  //   });
  // }

  void _processText(String text) {
    final lines = text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    String fullName = '';
    String jobTitle = '';
    String email = '';
    String location = '';

    // Regular expressions
    final emailRegex =
        RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
    final nameRegex = RegExp(r'^[A-Z][a-z]+(?: [A-Z][a-z]+)+$');
    final locationRegex =
        RegExp(r'\b(?:[A-Z][a-z]+(?:,?\s+)){1,3}(?:[A-Z]{2}|[A-Z][a-z]+)\b');

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];

      // Check for email
      if (email.isEmpty) {
        final emailMatch = emailRegex.firstMatch(line);
        if (emailMatch != null &&
            EmailValidator.validate(emailMatch.group(0)!)) {
          email = emailMatch.group(0)!;
          continue;
        }
      }

      // Check for full name (usually one of the first lines)
      if (fullName.isEmpty && i < 3 && nameRegex.hasMatch(line)) {
        fullName = line;
        continue;
      }

      // Check for location (usually one of the last lines)
      if (location.isEmpty &&
          i > lines.length - 4 &&
          locationRegex.hasMatch(line)) {
        location = line;
        continue;
      }

      // If not matched as name, email, or location, consider it as a potential job title
      if (jobTitle.isEmpty && line.split(' ').length <= 5) {
        jobTitle = line;
      }
    }

    // If we couldn't find a job title, try to find the longest line that's not name, email, or location
    if (jobTitle.isEmpty) {
      jobTitle = lines
          .where(
              (line) => line != fullName && line != email && line != location)
          .reduce((a, b) => a.length > b.length ? a : b);
    }

    setState(() {
      nameController.text = fullName;
      jobController.text = jobTitle;
      emailController.text = email;
      locationController.text = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(
            left: 20.0, right: 20.0, top: 50.0, bottom: 25.0),
        child: Column(
          children: [
            const SizedBox(height: 18.0),
            const Text('Enter Business Card Details',
                style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5.0),
            const Text(
              'To save contact details, please enter business card information.',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 35),
            Expanded(
                child: ListView(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              children: [
                _dateField(text: 'Full Name', textEditing: nameController),
                _dateField(text: 'Job Title', textEditing: jobController),
                _dateField(text: 'email', textEditing: emailController),
                _dateField(text: "Location", textEditing: locationController),
                const SizedBox(height: 20.0),
                _getScanBusinessCardBtn(),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget _dateField(
      {required String text, required TextEditingController textEditing}) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(top: 10, bottom: 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: textEditing,
          decoration: InputDecoration(
            labelText: text,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _getScanBusinessCardBtn() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        padding: const EdgeInsets.all(0.0),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Choose an option"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: const Text('Camera'),
                      onTap: () {
                        Navigator.of(context).pop();
                        scanBussinessCard(ImageSource.camera);
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: const Text('Gallery'),
                      onTap: () {
                        Navigator.of(context).pop();
                        scanBussinessCard(ImageSource.gallery);
                      },
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: const EdgeInsets.all(12.0),
        child:
            const Text('Scan Business Card', style: TextStyle(fontSize: 18.0)),
      ),
    );
  }
}
