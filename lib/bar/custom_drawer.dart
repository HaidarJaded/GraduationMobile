// ignore_for_file: file_names, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/Controllers/auth_controller.dart';
import 'package:graduation_mobile/allDevices/cubit/all_devices_cubit.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/login/loginScreen/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../allDevices/screen/allDevices.dart';
import '../drawerScreen/anyQuestion.dart';
import '../drawerScreen/oldPhone.dart';
import '../order/cubit/order_cubit.dart';
import '../order/screenOrder.dart';
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
                                onPressed: () {},
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
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => const allDevices()));
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
                              "Center",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      onPressed: () {
                        BlocProvider.of<AllDevicesCubit>(context)
                            .getDeviceData();
                        Get.off(center());
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) =>
                        //         const CustomBottomNavigationBar()));
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      onPressed: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => const oldPhone()));
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
                              "Old Phone",
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
                    MaterialButton(
                      onPressed: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => const anyQuestion()));
                        Get.off(() => const anyQuestion());
                      },
                      // ignore: avoid_unnecessary_containers
                      child: Container(
                        child: const Row(
                          children: [
                            Icon(
                              Icons.help,
                              size: 23,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              "Any question",
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
                    MaterialButton(
                      onPressed: () {
                        BlocProvider.of<OrderCubit>(context).getOrder();

                        Get.offAll(const order());
                      },
                      // ignore: avoid_unnecessary_containers
                      child: Container(
                        child: const Row(
                          children: [
                            Icon(
                              Icons.list_alt_sharp,
                              size: 23,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              "order",
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
                    MaterialButton(
                      onPressed: () {},
                      // ignore: avoid_unnecessary_containers
                      child: Container(
                        child: const Row(
                          children: [
                            Icon(
                              Icons.settings,
                              size: 23,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              "Settings",
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
