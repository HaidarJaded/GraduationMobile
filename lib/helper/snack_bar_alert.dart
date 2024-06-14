// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarAlert {
  void alert(String message,
      {Color? color = const Color.fromRGBO(201, 0, 0, 0.911),
      String title = "خطأ",
      TextButton? yesButton,
      TextButton? noButton,
      Duration? duration=const Duration(seconds: 3)
      }) {
    Get.snackbar(
      title,
      message,
      colorText: const Color.fromRGBO(255, 255, 255, 1),
      backgroundColor: color,
      duration: duration,
      mainButton: yesButton,
      onTap: (snack) {
        noButton?.onPressed!();
      },
    );
  }
}
