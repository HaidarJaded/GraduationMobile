// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  CustomCard(
      {required title,
      required subtitle,
      this.leading,
      this.trailing,
      this.color});
  String? title;
  String? subtitle;
  dynamic leading;
  dynamic trailing;
  dynamic color;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: leading,
        title: Text('$title'),
        subtitle: Text('$subtitle'),
        trailing: trailing,
      ),
    );
  }
}
