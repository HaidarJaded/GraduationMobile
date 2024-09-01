// ignore_for_file: file_names, unused_local_variable, unnecessary_import
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/Controllers/auth_controller.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/login/loginScreen/loginPage.dart';
import 'package:graduation_mobile/pages/client/Home_Page.dart';
import 'package:graduation_mobile/pages/client/drawer/notification/notificationScreen.dart';
import 'package:graduation_mobile/pages/client/drawer/oldPhoneUser/old_phone_user.dart';
import 'package:graduation_mobile/pages/client/drawer/profile_user.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({
    super.key,
  });

  void logout() async {
    if (await BlocProvider.of<loginCubit>(Get.context!).logout()) {
      SnackBarAlert().alert("تم تسجيل الخروج بنجاح",
          color: const Color.fromRGBO(0, 200, 0, 1), title: "إلى اللقاء");
      Get.offAll(() => const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: IconButton(
                    onPressed: () {
                      Get.to(() => const UserProfilePage());
                    },
                    icon: const Icon(Icons.person),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<String?>(
                    future: InstanceSharedPrefrences().getName(),
                    builder: (context, nameSnapshot) {
                      return FutureBuilder<String?>(
                        future: InstanceSharedPrefrences().getEmail(),
                        builder: (context, emailSnapshot) {
                          if (nameSnapshot.hasData && emailSnapshot.hasData) {
                            return ListTile(
                              title: Text(nameSnapshot.data!),
                              subtitle: Text(emailSnapshot.data!),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.home_sharp),
              title: const Text("الصفحة الرئيسية"),
              onTap: () {
                Get.to(const HomePages());
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active_sharp),
              title: const Text("الإشعارات"),
              onTap: () {
                Get.to(const NotificationScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt_rounded),
              title: const Text("الاجهزة المسلمة"),
              onTap: () {
                Get.to(const oldPhoneUser());
              },
            ),
            InkWell(
              onTap: logout,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255, 203, 139, 248),
                    Color.fromARGB(255, 67, 25, 146),
                  ]),
                ),
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
