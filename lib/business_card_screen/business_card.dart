import 'dart:io';
import 'dart:math';
import 'package:digi_card/constant/color_pallete.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class BusinessCardScreen extends StatefulWidget {
  final Map<String, String> controllers;
  final File? avatarFile;

  const BusinessCardScreen({
    Key? key,
    required this.controllers,
    this.avatarFile,
  }) : super(key: key);

  @override
  State<BusinessCardScreen> createState() => _BusinessCardScreenState();
}

class _BusinessCardScreenState extends State<BusinessCardScreen>
    with SingleTickerProviderStateMixin {
  // Track the selected cards
  final List<int> selectedCards = [];

  // List of ScreenshotControllers, one for each card
  final List<ScreenshotController> screenshotControllers =
      List.generate(4, (_) => ScreenshotController());
  final List<bool> isFlipped = List.generate(4, (_) => false);
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  // Function to build selectable cards
  Widget buildSelectableCard(BuildContext context, int index, Color startColor,
      Color endColor, Color textColor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedCards.contains(index)) {
            selectedCards.remove(index);
          } else {
            selectedCards.add(index);
          }
        });
      },
      onLongPress: () {
        setState(() {
          isFlipped[index] = !isFlipped[index];
          if (isFlipped[index]) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        });
      },
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final rotate = animation.drive(Tween(begin: pi, end: 0.0));
          return AnimatedBuilder(
              animation: rotate,
              builder: (BuildContext context, Widget? child) {
                final isUnder = ValueKey(isFlipped[index]) != child?.key;
                var tilt = (animation.value - 0.5).abs() - 0.5;
                tilt *= isUnder ? -0.003 : 0.003;
                final value =
                    isUnder ? min(rotate.value, pi / 2) : rotate.value;
                return Transform(
                  transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
                  alignment: Alignment.center,
                  child: child,
                );
              },
              child: child);
        },
        layoutBuilder: (Widget? currentChild, List<Widget> prevoiusChildren) {
          return Stack(
            children: <Widget>[
              if (prevoiusChildren.isNotEmpty) prevoiusChildren.last,
              if (currentChild != null) currentChild,
            ],
          );
        },
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: isFlipped[index]
            ? buildQrCodeCard(index)
            : Screenshot(
                controller: screenshotControllers[index],
                child:
                    buildBusinessCard(context, startColor, endColor, textColor),
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
          height: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [startColor, endColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: const [
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
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
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
                              backgroundImage: widget.avatarFile != null
                                  ? FileImage(widget.avatarFile!)
                                  : null,
                              backgroundColor: Colors.grey[300],
                              child: widget.avatarFile == null
                                  ? Icon(
                                      Icons.business,
                                      size: 50,
                                      color: Colors.grey[600],
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.controllers['company'] ?? 'Company Name',
                            style: TextStyle(
                              fontSize: 20,
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
                            widget.controllers['name'] ?? 'Name',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          Text(
                            widget.controllers['title'] ?? 'Title',
                            style: TextStyle(
                              fontSize: 20,
                              color: textColor.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Divider(
                            color: textColor.withOpacity(0.7),
                            thickness: 1.5,
                            indent: 20,
                            endIndent: 20,
                          ),
                          const SizedBox(height: 8),
                          buildContactRow(
                              Icons.phone,
                              widget.controllers['phone'] ?? 'Phone',
                              textColor),
                          buildContactRow(
                              Icons.email,
                              widget.controllers['email'] ?? 'Email',
                              textColor),
                          buildContactRow(
                              Icons.web,
                              widget.controllers['website'] ?? 'Website',
                              textColor),
                          buildContactRow(
                              Icons.location_on,
                              widget.controllers['address'] ?? 'Address',
                              textColor),
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

  Widget buildQrCodeCard(int index) {
    final phone = widget.controllers['phone'] ?? '';
    final email = widget.controllers['email'] ?? '';
    final website = widget.controllers['website'] ?? '';

    String qrdata = '';
    if (phone.isNotEmpty) qrdata += 'Phone: $phone\n';
    if (email.isNotEmpty) qrdata += 'Email: $email\n';
    if (website.isNotEmpty) qrdata += 'Website: $website\n';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          width: 600,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: QrImageView(
              data: qrdata,
              version: QrVersions.auto,
              size: 100,
            ),
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
            padding: const EdgeInsets.all(6),
            child: Icon(icon, color: textColor),
          ),
          const SizedBox(width: 8),
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

  // Function to handle downloading selected cards
  Future<void> downloadSelectedCards() async {
    for (int index in selectedCards) {
      final capturedImage = await screenshotControllers[index].capture();

      if (capturedImage != null) {
        final result = await ImageGallerySaver.saveImage(
          capturedImage,
          quality: 80,
          name: 'business_card_$index',
        );
        print('Saved to gallery: $result');
      }
    }
  }

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
                    icon: const Icon(
                      Iconsax.arrow_square_left_copy,
                      color: ColorPallete.colorSelect,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Iconsax.add_square_copy,
                      color: ColorPallete.colorSelect,
                      size: 30,
                    ),
                    onPressed: () {
                      // Implement the functionality to add another business card
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Iconsax.save_2_copy,
                      color: Colors.blue,
                      size: 30,
                    ),
                    onPressed: selectedCards.isEmpty
                        ? null
                        : () {
                            downloadSelectedCards();
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
                      buildSelectableCard(context, 0, Colors.blueGrey,
                          Colors.white, Colors.amber.shade300),
                      const SizedBox(height: 12),
                      buildSelectableCard(context, 1, Colors.indigo,
                          Colors.white, Colors.white70),
                      const SizedBox(height: 12),
                      buildSelectableCard(context, 2, Colors.teal, Colors.white,
                          Colors.white70),
                      const SizedBox(height: 12),
                      buildSelectableCard(context, 3, Colors.deepOrange,
                          Colors.white, Colors.white70),
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
}
