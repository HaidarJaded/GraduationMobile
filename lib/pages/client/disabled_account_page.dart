import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/Controllers/auth_controller.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/login/loginScreen/loginPage.dart';
import 'package:url_launcher/url_launcher.dart';

class DisabledAccountPage extends StatelessWidget {
  const DisabledAccountPage({super.key});
  final String phoneNumber = "963997403504";

  void _sendMessage() async {
    final String? email = await InstanceSharedPrefrences().getEmail();
    final String message = "الرجاء تفعيل الحساب\n$email";
    final String url =
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(FontAwesomeIcons.whatsapp, size: 50),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: const Text("فتح واتساب"),
                ),
              ],
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
