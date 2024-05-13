// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class codepage extends StatelessWidget {
  codepage({super.key});
  TextEditingController code = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 87, 42, 170),
        shadowColor: Colors.grey,
        elevation: 20.20,
        title: Text("My phone"),
      ),
      body: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.emailAddress,
        controller: code,
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: const TextStyle(fontFamily: "Roboto"),
          prefixIcon: const Icon(Icons.email),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          // Add more email validation if needed
          return null;
        },
      ),
    );
  }
}
