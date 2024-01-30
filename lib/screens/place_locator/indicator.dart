import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator({ Key? key, required this.isActive }) : super(key: key);
  
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      width: isActive ? 22.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.orange : Colors.grey,
        borderRadius: BorderRadius.circular(8.0)
      ),
    );
  }
}