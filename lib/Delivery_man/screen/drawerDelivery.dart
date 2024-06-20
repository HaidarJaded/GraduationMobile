// ignore_for_file: file_names, unnecessary_import, camel_case_types, must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:graduation_mobile/Delivery_man/screen/profile_delivery.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controllers/auth_controller.dart';
import '../../helper/snack_bar_alert.dart';
import '../../login/loginScreen/loginPage.dart';

class draweDelivery extends StatelessWidget {
  draweDelivery({super.key, required this.userId});
  int userId;
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
      child: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final prefs = snapshot.data!;
              final String? userInfoString = prefs.getString('profile');
              if (userInfoString != null) {
                final Map<String, dynamic> userInfo =
                    jsonDecode(userInfoString);
                final String name = userInfo['name'] ?? 'اسم المستخدم';
                final String email = userInfo['email'] ?? 'البريد الإلكتروني';
                return ListView(
                  children: [
                    Row(children: [
                      // ignore: avoid_unnecessary_containers
                      Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: IconButton(
                                onPressed: () {
                                  Get.to(DeliveryProfilePage(
                                    userId: userId,
                                  ));
                                },
                                icon: const Icon(Icons.person))),
                      ),
                      Expanded(
                          child: ListTile(
                        title: Text(name),
                        subtitle: Text(email),
                      ))
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: logout,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
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
                            'Log out',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
            return Center(
              child: snapshot.hasError
                  ? const Text('حدث خطأ')
                  : const CircularProgressIndicator(),
            );
          }),
    ));
  }
}
