import 'package:flutter/material.dart';
import 'package:graduation_mobile/helper/app_context.dart';

class SnackBarAlert {
  void alert(String text, {Color? color}) {
    if (AppContext.navigatorKey.currentContext != null) {
      color ??= const Color.fromRGBO(201, 0, 0, 0.911);
      ScaffoldMessenger.of(AppContext.navigatorKey.currentContext!)
          .showSnackBar(SnackBar(
        content: SizedBox(
          height: 40,
          child: Center(
            child: Text(text),
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: color,
      ));
    }
  }
}
