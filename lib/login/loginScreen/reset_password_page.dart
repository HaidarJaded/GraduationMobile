import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> myform = GlobalKey<FormState>();
  bool isMessageSent = false;
  int _resendTime = 60;
  Timer? _timer;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    setState(() {
      _resendTime = 60;
    });
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_resendTime == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _resendTime--;
          });
        }
      },
    );
  }

  Future<bool> sendResetPasswordRequest(String email) async {
    if (email.isEmpty) {
      SnackBarAlert().alert('الرجاء إدخال البريد الالكتروني');
      return false;
    }
    var response = await Api()
        .post(path: 'password/reset/request', body: {'email': email});
    if (response == null) {
      return false;
    }
    SnackBarAlert().alert(
        'تم ارسال رابط استعادة كلمة المرور على البريد الاكتروني',
        title: 'يرجى مراجعة البريد',
        color: const Color.fromRGBO(0, 150, 150, 1));
    return true;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('استعادة كلمة المرور'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: myform,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                validator: (value) {
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value!)) {
                    return 'ادخل عنوان بريد إلكتروني صحيح';
                  }
                  return null;
                },
                controller: emailController,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(
                    labelText: 'البريد الالكتروني',
                    hintText: 'أدخل البريد الالكتروني',
                    hintStyle: TextStyle(fontSize: 12)),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: !isMessageSent || _resendTime == 0
                    ? () async {
                        if (myform.currentState?.validate() ?? false) {
                          startTimer();
                          bool sentSuccessful = await sendResetPasswordRequest(
                              emailController.text);
                          setState(() {
                            if (sentSuccessful) {
                              isMessageSent = true;
                            }
                          });
                        }
                      }
                    : null,
                child: isMessageSent
                    ? _resendTime == 0
                        ? const Text("إعادة الارسال")
                        : Text("إعادة الارسال خلال $_resendTime ثانية")
                    : const Text('ارسال رابط الاستعادة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
