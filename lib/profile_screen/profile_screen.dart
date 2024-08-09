import 'dart:io';
import 'package:digi_card/constant/color_pallete.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
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
  late Map<String, List<TextEditingController>> controllers;
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
      'name': [TextEditingController(text: widget.cardInfo['name'] ?? '')],
      'title': [TextEditingController(text: widget.cardInfo['title'] ?? '')],
      'company': [
        TextEditingController(text: widget.cardInfo['company'] ?? '')
      ],
      'phone': [TextEditingController(text: widget.cardInfo['phone'] ?? '')],
      'email': [TextEditingController(text: widget.cardInfo['email'] ?? '')],
      'address': [
        TextEditingController(text: widget.cardInfo['address'] ?? '')
      ],
      'website': [
        TextEditingController(text: widget.cardInfo['website'] ?? '')
      ],
    };
    _avatarFile = widget.imageFile;
  }

  @override
  void dispose() {
    for (var controllerList in controllers.values) {
      for (var controller in controllerList) {
        controller.dispose();
      }
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

  void _addTextField(String label) {
    setState(() {
      if (!controllers.containsKey(label)) {
        controllers[label] = [TextEditingController()];
      } else {
        controllers[label]!.add(TextEditingController());
      }
    });
  }

  void _removeTextField(String label, int index) {
    setState(() {
      if (controllers[label]!.length > 1) {
        controllers[label]![index].dispose();
        controllers[label]!.removeAt(index);
      }
    });
  }

  Future<void> _showAddFieldDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Add Field",
            style: TextStyle(color: Colors.black87),
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // Ensure dialog content doesn't overflow
            children: [
              ListTile(
                leading: const Icon(
                  Icons.text_fields_outlined,
                  color: ColorPallete.colorSelect,
                  size: 30.0,
                ),
                title: const Text(
                  'Text Field',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the current dialog
                  _showLabelDialog(); // Open the label dialog
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.qr_code_2,
                  color: ColorPallete.colorSelect,
                  size: 30.0,
                ),
                title: const Text(
                  'QR code',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                onTap: () {
                  // Handle QR code addition here
                  print("QR code option selected");
                  Navigator.pop(context); // Close the current dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showLabelDialog() async {
    String? labelText;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Enter Label",
            style: TextStyle(color: Colors.black87),
          ),
          content: TextField(
            style: const TextStyle(
                color: ColorPallete.colorSelect, fontWeight: FontWeight.w400),
            onChanged: (value) {
              labelText = value;
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(color: ColorPallete.colorSelect),
              hintText: 'Label',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (labelText != null && labelText!.isNotEmpty) {
                  setState(() {
                    if (!controllers.containsKey(labelText)) {
                      controllers[labelText!] = [TextEditingController()];
                      print("create field success !!");
                    } else {
                      _addTextField(labelText!);
                      print("create field not success !!");
                    }
                  });
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text(
                'Add',
                style: TextStyle(color: ColorPallete.colorSelect),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: ColorPallete.colorSelect),
              ),
            ),
          ],
        );
      },
    );
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
                        ...controllers[label]!.map((controller) =>
                            buildTextField(label, controller,
                                controllers[label]!.indexOf(controller))),
                        const Divider(),
                      ],
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _showAddFieldDialog();
                      });
                    },
                    icon: const Icon(
                      Iconsax.additem_copy,
                      size: 30.0,
                      color: ColorPallete.colorSelect,
                    )),
                const SizedBox(height: 10.0),
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

  Widget buildTextField(
      String label, TextEditingController controller, int index) {
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
                ),
              ),
              Row(
                children: [
                  // Only show the "+" and "-" buttons for the last TextField in the list
                  if ((label == 'phone' ||
                          label == 'email' ||
                          label == 'address' ||
                          label == 'website') &&
                      index == controllers[label]!.length - 1)
                    Row(
                      children: [
                        if (controllers[label]!.length < 3)
                          IconButton(
                            onPressed: () => _addTextField(label),
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.green,
                            ),
                          ),
                        if (controllers[label]!.length > 1)
                          IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () => _removeTextField(label, index),
                          ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveProfile() {
    controllers.forEach((key, controllerList) {
      for (var controller in controllerList) {
        print('$key: ${controller.text}');
      }
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
