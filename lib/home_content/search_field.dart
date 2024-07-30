import 'package:flutter/material.dart';

class SimpleSearchBar extends StatelessWidget {
  final ValueChanged<String> onSearch;

  const SimpleSearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.blue[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.black45),
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.black45),
          hintText: 'Search...',
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black45,
          ),
          border: InputBorder.none,
          contentPadding:
               EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
        onChanged: onSearch,
      ),
    );
  }
}
