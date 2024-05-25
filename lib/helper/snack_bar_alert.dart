// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarAlert {
  void alert(String message,
      {Color? color = const Color.fromRGBO(201, 0, 0, 0.911),
      String title = "Error"}) {
    Get.snackbar(title, message,
        colorText: const Color.fromRGBO(255, 255, 255, 1),
        backgroundColor: color);
  }
}

class SnackBarAlertWithButton {
  void alert(String message,
      {Color color = const Color.fromARGB(255, 229, 183, 237),
      String title = "Error",
      MaterialButton? yesButton,
      MaterialButton? noButton}) {
    Get.showSnackbar(GetBar(
      messageText: Text(message),
      backgroundColor: color,
      snackPosition: SnackPosition.BOTTOM,
      titleText: Text(title),
      mainButton: yesButton,
      onTap: (snack) {
        noButton?.onPressed!();
      },
    ));
  }
}
