// ignore_for_file: file_names, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: camel_case_types
class textFormField extends StatelessWidget {
  textFormField({
    super.key,
    required this.labelText,
    required this.icon,
    required this.controller,
    this.inputFormatters,
    this.validator,
  });
  final String labelText;
  final Icon icon;

  final TextEditingController controller;
  List<TextInputFormatter>? inputFormatters;
  final validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        // labelStyle: const TextStyle(fontFamily: "Roboto"),
        prefixIcon: icon,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
      inputFormatters: inputFormatters,
    );
  }
}
