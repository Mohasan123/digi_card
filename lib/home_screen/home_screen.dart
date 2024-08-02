import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:digi_card/camera_screen/camera_screen.dart';
import 'package:digi_card/constant/color_pallete.dart';
import 'package:digi_card/home_content/home_content.dart';
import 'package:digi_card/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

int visit = 0;
double height = 30;

final List<Widget> _screens = [
  const HomeContent(),
  const CameraScreen(),
  const ProfileScreen(),
];
const List<TabItem> items = [
  TabItem(
    icon: Icons.home,
    // title: 'Home',
  ),
  TabItem(
    icon: Icons.camera,
    // title: 'camera',
  ),
  TabItem(
    icon: Icons.person,
    // title: 'profile',
  ),
];

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[visit],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
        child: BottomBarCreative(
          iconSize: 30.0,
          borderRadius: BorderRadius.circular(20.0),
          items: items,
          backgroundColor: ColorPallete.bgColor,
          color: ColorPallete.color,
          colorSelected: ColorPallete.colorSelect,
          indexSelected: visit,
          highlightStyle: const HighlightStyle(
            isHexagon: true,
          ),
          onTap: (int index) => setState(() {
            visit = index;
          }),
        ),
      ),
    );
  }
}
