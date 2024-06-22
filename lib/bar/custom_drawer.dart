// ignore_for_file: file_names, unused_local_variable, unnecessary_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/Controllers/auth_controller.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/login/loginScreen/loginPage.dart';
import 'package:graduation_mobile/models/user_model.dart';
import 'package:graduation_mobile/pages/client/drawer/client_profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../allDevices/screen/allDevices.dart';
import '../drawerScreen/notification/notifications.dart';
import '../drawerScreen/oldPhone/oldPhone.dart';
import '../order/orders_page.dart';
import '../the_center/center.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
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
                                  Get.to(() => const ClientProfilePage());
                                },
                                icon: const Icon(Icons.person))),
                      ),
                      Expanded(
                          child: ListTile(
                        title: Text(name),
                        subtitle: Text(email),
                      ))
                    ]),
                    MaterialButton(
                      // ignore: avoid_unnecessary_containers
                      child: Container(
                        child: const Row(
                          children: [
                            Icon(
                              Icons.phone_android_rounded,
                              size: 23,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              "MYP",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      onPressed: () {
                        Get.off(() => const allDevices());
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      // ignore: avoid_unnecessary_containers
                      child: Container(
                        child: const Row(
                          children: [
                            Icon(
                              Icons.home_filled,
                              size: 23,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              "المركز",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      onPressed: () {
                        Get.off(() => center());
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      // ignore: avoid_unnecessary_containers
                      child: Container(
                        child: const Row(
                          children: [
                            Icon(
                              Icons.notification_add,
                              size: 23,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              "الاشعارات",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      onPressed: () {
                        Get.off(() => const notificationsScreen());
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      onPressed: () {
                        Get.off(() => const oldPhone());
                      },
                      // ignore: avoid_unnecessary_containers
                      child: Container(
                        child: const Row(
                          children: [
                            Icon(
                              Icons.list_alt_rounded,
                              size: 23,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              "الاجهزة المسلمة",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FutureBuilder(
                        future: User.hasPermission('الاسنعلام عن الطلبات'),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData &&
                              snapshot.data!) {
                            return MaterialButton(
                              onPressed: () {
                                Get.offAll(() => const ordersPage());
                              },
                              // ignore: avoid_unnecessary_containers
                              child: Container(
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.local_shipping_outlined,
                                      size: 23,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      "الطلبات",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        })),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 10,
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
