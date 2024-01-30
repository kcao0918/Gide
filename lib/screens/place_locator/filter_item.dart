import 'package:flutter/material.dart';

class FilterItem extends StatelessWidget {
  final String name;

  const FilterItem({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4)
      ),
      child: Text(
        name, 
        style: const TextStyle(
          color: Color(0xFF797979)
        )
      ),
    );
  }
}
