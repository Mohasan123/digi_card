import 'dart:io';
import 'package:digi_card/constant/color_pallete.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final File? imageFile;
  final Map<String, String> cardInfo;

  const ProfileScreen({Key? key, this.imageFile, required this.cardInfo})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Map<String, TextEditingController> controllers;
  File? _avatarFile;
  List<String> fieldLabels = [
    'name',
    'title',
    'company',
    'phone',
    'email',
    'address',
    'website'
  ];

  @override
  void initState() {
    super.initState();
    controllers = {
      'name': TextEditingController(text: widget.cardInfo['name'] ?? ''),
      'title': TextEditingController(text: widget.cardInfo['title'] ?? ''),
      'company': TextEditingController(text: widget.cardInfo['company'] ?? ''),
      'phone': TextEditingController(text: widget.cardInfo['phone'] ?? ''),
      'email': TextEditingController(text: widget.cardInfo['email'] ?? ''),
      'address': TextEditingController(text: widget.cardInfo['address'] ?? ''),
      'website': TextEditingController(text: widget.cardInfo['website'] ?? ''),
    };
    _avatarFile = widget.imageFile;
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarFile = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _avatarFile = null;
    });
  }

  void _addTextField() {
    String newLabel = 'field${controllers.length + 1}';
    setState(() {
      controllers[newLabel] = TextEditingController();
      fieldLabels.add(newLabel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: ColorPallete.color,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      _avatarFile != null ? FileImage(_avatarFile!) : null,
                  backgroundColor: Colors.grey[300],
                  child: _avatarFile == null
                      ? Icon(Icons.person, size: 60, color: Colors.grey[600])
                      : null,
                ),
                Positioned(
                  bottom: -8,
                  left: -5,
                  child: IconButton(
                    icon: const Icon(Icons.photo_camera,
                        color: Colors.lightBlueAccent),
                    onPressed: _pickImage,
                    tooltip: 'Edit',
                    color: Colors.black54,
                  ),
                ),
                Positioned(
                  bottom: -5,
                  right: -8,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: _removeImage,
                    tooltip: 'Remove',
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          const Divider(
            thickness: 10.0,
            color: ColorPallete.colorDivider,
          ),
          const SizedBox(height: 10),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                ...fieldLabels.map((label) => Column(
                      children: [
                        buildTextField(label, controllers[label]!),
                        const Divider(),
                      ],
                    )),
                TextButton(
                    style: ButtonStyle(
                        // shape: ,
                        ),
                    onPressed: () {
                      setState(() {
                        _addTextField();
                      });
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          color: ColorPallete.colorSelect,
                          size: 30.0,
                        ),
                      ],
                    )),
              ],
            ),
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorPallete.colorSelect,
        onPressed: _saveProfile,
        child: const Icon(
          Icons.save,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
                child: Text(
                  label.capitalize(),
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                  child: TextField(
                textAlign: TextAlign.end,
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter $label',
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  void _saveProfile() {
    controllers.forEach((key, controller) {
      print('$key: ${controller.text}');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile information saved')),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
