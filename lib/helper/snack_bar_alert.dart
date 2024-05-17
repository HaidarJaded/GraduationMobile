import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarAlert {
  void alert(String message,
      {Color? color = const Color.fromRGBO(201, 0, 0, 0.911),
      String title = "Error"}) {
    Get.snackbar(
      title,
      message,
      colorText: const Color.fromRGBO(255, 255, 255, 1),
      backgroundColor: color
    );
  }
}
