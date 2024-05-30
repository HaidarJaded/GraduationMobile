import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/Controllers/auth_controller.dart';
import 'package:graduation_mobile/login/loginScreen/loginPage.dart';

class DisabledAccountPage extends StatelessWidget {
  const DisabledAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
              size: 50,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              'عذراً حسابك معطل أو لم يتم تفعيله بعد، \nيرجى التواصل مع المركز للمزيد من التفاصيل.',
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<loginCubit>(Get.context!)
                    .logout()
                    .then((value) {
                  Get.offAll(() => const LoginPage());
                });
              },
              child: const Text('تسجيل الخروج'),
            ),
          ],
        ),
      ),
    );
  }
}
