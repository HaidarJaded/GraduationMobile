// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarAlert {
  void alert(String message,
      {Color? color = const Color.fromRGBO(201, 0, 0, 0.911),
      String title = "Error",
      TextButton? yesButton,
      TextButton? noButton}) {
    Get.snackbar(
      title,
      message,
      colorText: const Color.fromRGBO(255, 255, 255, 1),
      backgroundColor: color,
      mainButton: yesButton,
      onTap: (snack) {
        noButton?.onPressed!();
      },
    );
  }
}
