// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../bar/custom_drawer.dart';
import '../bar/SearchAppBar.dart';

// ignore: camel_case_types
class anyQuestion extends StatelessWidget {
  const anyQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(),
      drawer: const CustomDrawer(),
    );
  }
}
