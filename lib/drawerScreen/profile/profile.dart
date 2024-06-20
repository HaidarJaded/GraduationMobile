// ignore_for_file: avoid_unnecessary_containers, unnecessary_import, camel_case_types, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/allDevices/screen/allDevices.dart';
import 'package:graduation_mobile/drawerScreen/profile/editProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

GlobalKey<FormState> myform = GlobalKey<FormState>();
TextEditingController phoneController = TextEditingController();
TextEditingController centerNameController = TextEditingController();
TextEditingController adressController = TextEditingController();

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Expanded(
      child: Column(children: [
        Container(
          color: const Color.fromRGBO(87, 42, 170, 1),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Get.off(() => const allDevices());
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: FutureBuilder<SharedPreferences>(
                    future: SharedPreferences.getInstance(),
                    builder: (context, snapshot) {
                      Colors.white;
                      if (snapshot.hasData) {
                        final prefs = snapshot.data!;
                        final String? userInfoString =
                            prefs.getString('profile');
                        if (userInfoString != null) {
                          final Map<String, dynamic> userInfo =
                              jsonDecode(userInfoString);
                          final String name =
                              userInfo['name'] ?? 'اسم المستخدم';
                          final String lastName =
                              userInfo['last_name'] ?? 'كنية المستخدم';
                          final String email =
                              userInfo['email'] ?? 'البريد الإلكتروني';

                          return Row(children: [
                            Container(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.person,
                                        size: 60.5,
                                      ))),
                            ),
                            Expanded(
                                child: ListTile(
                              title: Text(
                                name + " " + lastName,
                                style: const TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontFamily: 'Montserrat'),
                              ),
                              subtitle: Text(
                                email,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 20,
                                    color: Color.fromARGB(95, 255, 255, 255)),
                              ),
                            ))
                          ]);
                        }
                        return Center(
                          child: snapshot.hasError
                              ? const Text('حدث خطأ')
                              : const CircularProgressIndicator(),
                        );
                      }
                      return Center(
                        child: snapshot.hasError
                            ? const Text('حدث خطأ')
                            : const CircularProgressIndicator(),
                      );
                    }),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  child: const Text(
                    "معلومات الحساب",
                    style: TextStyle(
                      color: Color.fromRGBO(87, 42, 170, 1),
                      fontWeight: FontWeight.w200,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                FutureBuilder<SharedPreferences>(
                    future: SharedPreferences.getInstance(),
                    builder: (context, snapshot) {
                      Colors.white;
                      if (snapshot.hasData) {
                        final prefs = snapshot.data!;
                        final String? userInfoString =
                            prefs.getString('profile');
                        if (userInfoString != null) {
                          final Map<String, dynamic> userInfo =
                              jsonDecode(userInfoString);
                          final String centerName =
                              userInfo['center_name'] ?? 'اسم المركز';
                          final String phone = userInfo['phone'] ?? 'الرقم';
                          final String address =
                              userInfo['address'] ?? 'العنوان';
                          return Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        phone,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 200),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          Get.to(editProfile(
                                            controller: phoneController,
                                            labelText: "Phone number",
                                            icon: Icons.phone_android_outlined,
                                          ));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        centerName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 40),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          Get.to(editProfile(
                                            labelText: 'Center name',
                                            icon: const Icon(Icons.home_filled),
                                            controller: centerNameController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your center name';
                                              }
                                            },
                                          ));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        address,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 40),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          Get.to(
                                            editProfile(
                                              labelText: 'adress',
                                              icon: const Icon(Icons.line_axis),
                                              controller: adressController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your adress';
                                                }
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return Center(
                        child: snapshot.hasError
                            ? const Text('حدث خطأ')
                            : const CircularProgressIndicator(),
                      );
                    })
              ],
            ),
          ),
        )
      ]),
    )));
  }
}
