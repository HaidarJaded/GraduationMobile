// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';

import '../main.dart';

class CustomNavItem extends StatelessWidget {
  final IconData icon;
  final int id;
  final Function setPage;

  const CustomNavItem(
      {super.key, required this.setPage, required this.icon, required this.id});

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        currentIndex = id;
        setPage();
      },
      child: CircleAvatar(
        radius: 30,
        backgroundColor: const Color.fromARGB(255, 87, 42, 170),
        child: CircleAvatar(
          radius: 25,
          backgroundColor: currentIndex == id
              ? Colors.white.withOpacity(0.9)
              : const Color.fromARGB(255, 87, 42, 170),
          child: Icon(
            icon,
            color: currentIndex == id
                ? Colors.black
                : Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    );
  }
}
