import 'package:digi_card/constant/color_pallete.dart';
import 'package:flutter/material.dart';

class SearchBarField extends StatefulWidget {
  @override
  _SearchBarFieldState createState() => _SearchBarFieldState();
}

class _SearchBarFieldState extends State<SearchBarField> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          filled: true,
          fillColor: ColorPallete.color,
          hintText: 'Enter your search query',
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black38,
          ),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          // Perform search operation here
          print('Search query: $value');
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
