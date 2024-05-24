// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/Controllers/auth_controller.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/login/loginScreen/loginPage.dart';

import '../allDevices/screen/allDevices.dart';
import '../drawerScreen/anyQuestion.dart';
import '../drawerScreen/oldPhone.dart';
import '../the_center/center.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });
  void logout() async {
    if (await BlocProvider.of<loginCubit>(Get.context!).logout()) {
      SnackBarAlert().alert("Logout successfuly",
          color: const Color.fromRGBO(0, 200, 0, 1), title: "Successfuly");
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
            Row(children: [
              // ignore: avoid_unnecessary_containers
              Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.person))),
              ),
              const Expanded(
                  child: ListTile(
                title: Text("Ghina Alazmeh"),
                subtitle: Text("ghinaalazmeh@gmail.com"),
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const allDevices()));
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const center()));
              },
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const oldPhone()));
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const anyQuestion()));
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
        ),
      ),
    );
  }
}
