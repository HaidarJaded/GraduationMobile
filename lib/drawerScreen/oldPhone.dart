// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';

import '../bar/CustomDrawer.dart';
import '../bar/SearchAppBar.dart';

class oldPhone extends StatelessWidget {
  const oldPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(),
      drawer: const CustomDrawer(),
    );
  }
}
