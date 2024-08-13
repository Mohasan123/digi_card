import 'dart:io';
import 'package:digi_card/constant/color_pallete.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class BusinessCardScreen extends StatelessWidget {
  final Map<String, String> controllers;
  final File? avatarFile;

  const BusinessCardScreen({
    Key? key,
    required this.controllers,
    this.avatarFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Back and Add buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Iconsax.arrow_square_left_copy,
                      color: ColorPallete.colorSelect,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Iconsax.add_square_copy,
                      color: ColorPallete.colorSelect,
                      size: 30,
                    ),
                    onPressed: () {
                      // Implement the functionality to add another business card
                    },
                  ),
                ],
              ),
            ),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 16), // Add padding here
                  child: Column(
                    children: [
                      // Main Business Card with enhancements
                      buildBusinessCard(context, Colors.blueGrey, Colors.white,
                          Colors.amber.shade100),
                      SizedBox(height: 12),
                      // Additional Business Cards with variations
                      buildBusinessCard(
                          context, Colors.indigo, Colors.white, Colors.white54),
                      SizedBox(height: 12),
                      buildBusinessCard(context, Colors.teal, Colors.white,
                          Colors.teal.shade500),
                      SizedBox(height: 12),

                      buildBusinessCard(context, Colors.deepOrange,
                          Colors.white, Colors.deepOrange.shade400),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBusinessCard(
      BuildContext context, Color startColor, Color endColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: 600,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [startColor, endColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -60,
                right: -60,
                child: Icon(
                  Icons.business_center,
                  size: 180,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
              Row(
                children: [
                  // Left side: Company logo and name
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 45,
                              backgroundImage: avatarFile != null
                                  ? FileImage(avatarFile!)
                                  : null,
                              backgroundColor: Colors.grey[300],
                              child: avatarFile == null
                                  ? Icon(
                                      Icons.business,
                                      size: 50,
                                      color: Colors.grey[600],
                                    )
                                  : null,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            controllers['company'] ?? 'Company Name',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Right side: Other information
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controllers['name'] ?? 'Name',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          Text(
                            controllers['title'] ?? 'Title',
                            style: TextStyle(
                              fontSize: 20,
                              color: textColor.withOpacity(0.8),
                            ),
                          ),
                          SizedBox(height: 8),
                          Divider(
                            color: textColor.withOpacity(0.7),
                            thickness: 1.5,
                            indent: 20,
                            endIndent: 20,
                          ),
                          SizedBox(height: 8),
                          buildContactRow(Icons.phone,
                              controllers['phone'] ?? 'Phone', textColor),
                          buildContactRow(Icons.email,
                              controllers['email'] ?? 'Email', textColor),
                          buildContactRow(Icons.web,
                              controllers['website'] ?? 'Website', textColor),
                          buildContactRow(Icons.location_on,
                              controllers['address'] ?? 'Address', textColor),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContactRow(IconData icon, String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: textColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(6),
            child: Icon(icon, color: textColor),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
