// ignore_for_file: file_names, avoid_print, use_build_context_synchronously, avoid_unnecessary_containers, unnecessary_import, unused_element
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/Controllers/auth_controller.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/client_model.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/models/user_model.dart';
import 'package:graduation_mobile/pages/client/devices_by_client.dart';
import 'package:graduation_mobile/pages/client/widget/drawer_user.dart';
import '../../login/loginScreen/loginPage.dart';
import 'cubit/phone_cubit/phone_cubit.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  bool isAtWork = false;
  bool readyToBuild = false;
  final scrollController = ScrollController();
  int? userId;
  User? user;
  Map<String, dynamic> clients = {};
  List<String> clientsId = [];
  late PhoneCubit _phoneCubit;

  @override
  void dispose() {
    _phoneCubit.close();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    readyToBuild = false;
    _phoneCubit = PhoneCubit();
    InstanceSharedPrefrences().isAtWork().then((isAtWork) {
      setState(() {
        this.isAtWork = isAtWork;
      });
    });
    InstanceSharedPrefrences().getId().then((id) {
      userId = id;
      Api().get(path: 'api/devices_grouped', queryParams: {
        'all_data': 1,
        'deliver_to_client': 0,
      }).then((value) {
        setState(() {
          clients = (value['body']).length == 0 ? {} : value['body'];
          clientsId.addAll(clients.keys);
        });
      }).then((value) => readyToBuild = true);
    });
  }

  Future<bool> editAtWork(int newStatus) async {
    int? userId = await InstanceSharedPrefrences().getId();
    Map<String, dynamic> body = {'at_work': newStatus};
    try {
      var response = await Api().put(
        path: 'api/users/$userId',
        body: body,
      );
      if (response == null) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() async {
    if (await BlocProvider.of<loginCubit>(Get.context!).logout()) {
      SnackBarAlert().alert("تم تسجيل الخروج بنجاح",
          color: const Color.fromRGBO(0, 200, 0, 1), title: "إلى اللقاء");
      Get.offAll(() => const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 87, 42, 170),
        title: const Text('MYP'),
        actions: [
          Switch(
            value: isAtWork,
            onChanged: (newStatus) async {
              setState(() {
                isAtWork = newStatus;
              });
              if (await editAtWork(newStatus ? 1 : 0)) {
                InstanceSharedPrefrences().editAtWork(newStatus ? 1 : 0);
              } else {
                setState(() {
                  isAtWork = !newStatus;
                });
              }
            },
          ),
        ],
      ),
      drawer: const UserDrawer(),
      body: BlocProvider(
        create: (context) => _phoneCubit,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: BlocConsumer<PhoneCubit, PhoneState>(
                listener: (context, state) {
                  if (!readyToBuild) {
                    Container(
                      color: Colors.white,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                },
                builder: (context, state) {
                  if (!readyToBuild) {
                    return Container(
                      color: Colors.white,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: clientsId.length + 1,
                      itemBuilder: (context, index) {
                        if (index >= clientsId.length) {
                          if (clientsId.isEmpty) {
                            return const Center(
                              child: Text('لا يوجد اجهزة'),
                            );
                          }
                          return null;
                        }
                        var client = Client.fromJson(clients[clientsId[index]]);
                        return Column(
                          children: [
                            MaterialButton(
                                color: const Color.fromARGB(255, 247, 236, 240),
                                onPressed: () {
                                  Get.to(() => DevicesByClient(client: client));
                                },
                                minWidth: 300,
                                height: 50,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        client.centerName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        client.address,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                )),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    Api().get(path: 'api/devices_grouped', queryParams: {
      'all_data': 1,
      'deliver_to_client': 0,
    }).then((value) {
      setState(() {
        clients = value['body'];
        clientsId.clear();
        clientsId.addAll(clients.keys);
      });
    }).then((value) => readyToBuild = true);
  }
}
