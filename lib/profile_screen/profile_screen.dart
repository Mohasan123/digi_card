import 'dart:io';
import 'package:digi_card/business_card_screen/business_card.dart';
import 'package:digi_card/constant/color_pallete.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  List<String> customFields = [];
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

  Future<void> _generateQRCode() async {
    showDialog(
      context: context,
      builder: (context) {
        String qrData = 'Phone: ${controllers['phone']![0].text}\n'
            'Email: ${controllers['email']![0].text}\n'
            'Website: ${controllers['website']![0].text}';

        return AlertDialog(
          title: const Text('Generated QR Code'),
          content: QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: 200.0,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
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
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.qr_code_2,
                  color: Colors.blue,
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
                  Navigator.pop(context);
                  _generateQRCode();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showQrCodeOptions() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              "Generate QR Code",
              style: TextStyle(color: Colors.black87),
            ),
            content: Column(
              children: [
                _buildQRCodeOption('Phones', controllers['phone']?.first.text),
                _buildQRCodeOption('Emails', controllers['email']?.first.text),
                _buildQRCodeOption(
                    'WebSites', controllers['website']?.first.text),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'close',
                  style: TextStyle(color: ColorPallete.colorSelect),
                ),
              ),
            ],
          );
        });
  }

  Widget _buildQRCodeOption(String label, String? value) {
    return value != null && value.isNotEmpty
        ? ListTile(
            leading: QrImageView(
              data: value,
              size: 50,
              backgroundColor: Colors.white,
            ),
            title: Text(label),
            subtitle: Text(value),
          )
        : Container();
  }
  // Future<void> _showLabelDialog() async {
  //   String? labelText;

  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.white,
  //         title: const Text(
  //           "Enter Label",
  //           style: TextStyle(color: Colors.black87),
  //         ),
  //         content: TextField(
  //           style: const TextStyle(
  //               color: ColorPallete.colorSelect, fontWeight: FontWeight.w400),
  //           onChanged: (value) {
  //             labelText = value;
  //           },
  //           decoration: const InputDecoration(
  //             border: InputBorder.none,
  //             hintStyle: TextStyle(color: ColorPallete.colorSelect),
  //             hintText: 'Label',
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               if (labelText != null && labelText!.isNotEmpty) {
  //                 setState(() {
  //                   // Add the new label to the fieldLabels list if it doesn't exist
  //                   if (!fieldLabels.contains(labelText)) {
  //                     fieldLabels.add(labelText!);
  //                     controllers[labelText!] = [TextEditingController()];
  //                     print(
  //                         "Field created successfully with label: $labelText");
  //                     print(
  //                         "Current field labels: $fieldLabels"); // Debug print
  //                   } else {
  //                     _addTextField(labelText!);
  //                     print("Additional field added for label: $labelText");
  //                   }
  //                 });
  //                 Navigator.pop(context); // Close the dialog
  //               } else {
  //                 print("Label text is null or empty");
  //               }
  //             },
  //             child: const Text(
  //               'Add',
  //               style: TextStyle(color: ColorPallete.colorSelect),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context); // Close the dialog
  //             },
  //             child: const Text(
  //               'Cancel',
  //               style: TextStyle(color: ColorPallete.colorSelect),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    print("Building UI with fields: $fieldLabels"); // Debug print
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
                          if (label == 'phone')
                            buildPhoneNumberField(label)
                          else
                            ...controllers[label]!.map((controller) =>
                                buildTextField(label, controller,
                                    controllers[label]!.indexOf(controller))),
                          const Divider(),
                        ],
                      )),
                  IconButton(
                      onPressed: _showAddFieldDialog,
                      icon: const Icon(
                        Iconsax.additem_copy,
                        size: 30.0,
                        color: ColorPallete.colorSelect,
                      )),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
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
    final String labelCapitalized = capitalize(label);
    bool showAddButton =
        ['phone', 'email', 'address', 'website'].contains(label);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  labelCapitalized,
                  style: const TextStyle(
                      color: ColorPallete.colorSelect,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Enter ${labelCapitalized}',
                    border: InputBorder.none, // No border for text fields
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (showAddButton && controllers[label]!.length > 1)
                IconButton(
                  icon:
                      const Icon(Icons.remove_circle, color: Colors.redAccent),
                  onPressed: () => _removeTextField(label, index),
                ),
              if (showAddButton && controllers[label]!.length < 3)
                IconButton(
                  icon: const Icon(Iconsax.add_circle,
                      color: Colors.lightBlueAccent),
                  onPressed: () => _addTextField(label),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPhoneNumberField(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 5.0),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  capitalize(label),
                  style: const TextStyle(
                    color: ColorPallete.colorSelect,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                  child: IntlPhoneField(
                controller: controllers[label]!.first,
                initialCountryCode: 'US',
                decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
                onChanged: (phone) {
                  setState(() {
                    controllers[label]!.first.text = phone.completeNumber;
                  });
                },
              ))
            ],
          ),
        ],
      ),
    );
  }

  void _saveProfile() {
    bool allFieldsFilled = true;

    controllers.forEach((label, controllerList) {
      for (var controller in controllerList) {
        if (controller.text.isEmpty) {
          allFieldsFilled = false;
          break;
        }
      }
    });
    if (!allFieldsFilled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please Fill out all fields before saving."),
        backgroundColor: Colors.redAccent,
      ));
    } else {
      // Saving logic, possibly saving to a database or state management solution
      // Prepare the cardInfo map from controllers to pass it
      Map<String, String> cardInfo = {};
      controllers.forEach((key, controllerList) {
        for (var controller in controllerList) {
          cardInfo[key] = controller.text;
        }
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BusinessCardScreen(
            controllers: cardInfo,
            avatarFile: _avatarFile,
          ),
        ),
      );
    }
  }

  String capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
}
