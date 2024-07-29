import 'package:digi_card/constant/color_pallete.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Contacts",
                  style: TextStyle(fontSize: 30.0, color: Colors.black87),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.person_add,
                    size: 30.0,
                    color: ColorPallete.colorSelect,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
