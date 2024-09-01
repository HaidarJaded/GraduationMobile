// ignore: file_names
// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_local_variable, unused_element, file_names, duplicate_ignore, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/models/completed_device_model.dart';
import 'package:graduation_mobile/pages/client/cubit/completed_ccbit/completed_cubit.dart';
import 'package:graduation_mobile/pages/client/drawer/oldPhoneUser/searchClientCompleted.dart';
import 'package:graduation_mobile/pages/client/widget/compelted_info_device.dart';
import 'package:graduation_mobile/pages/client/widget/drawer_user.dart';

class oldPhoneUser extends StatefulWidget {
  const oldPhoneUser({super.key});

  @override
  State<oldPhoneUser> createState() => _oldPhoneUserState();
}

class _oldPhoneUserState extends State<oldPhoneUser> {
  int perPage = 20;
  int currentPage = 1;
  int pagesCount = 0;
  int totalCount = 0;
  List<CompletedDevice> completedDevices = [];
  bool firstTime = true;
  bool readyToBuild = false;

  Future<void> fetchCompletedDevice([int page = 1, int perPage = 20]) async {
    try {
      if (currentPage > pagesCount) {
        return;
      }
      int? id = await InstanceSharedPrefrences().getId();

      var data = await CrudController<CompletedDevice>().getAll({
        'page': currentPage,
        'per_page': perPage,
        'orderBy': 'date_delivery_client',
        'dir': 'desc',
        'user_id': id,
        'with': 'client',
        'deliver_to_client': 1
      });

      final List<CompletedDevice>? fetchedDevices = data.items;
      if (fetchedDevices != null) {
        int currentPage = data.pagination?['current_page'];
        int lastPage = data.pagination?['last_page'];
        int totalCount = data.pagination?['total'];

        setState(() {
          this.currentPage = currentPage;
          pagesCount = lastPage;
          // ignore: unnecessary_this
          this.completedDevices.addAll(fetchedDevices);
          this.totalCount = totalCount;
        });

        return;
      }
      return;
    } catch (e) {
      Get.snackbar("title", e.toString());
      return;
    }
  }

  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    readyToBuild = false;

    // Load initial data
    InstanceSharedPrefrences().getId().then((id) {
      return BlocProvider.of<CompletedDeviceUserCubit>(Get.context!)
          .getCompletedDeviceData({
        'page': 1,
        'per_page': perPage,
        'orderBy': 'date_delivery_client',
        'dir': 'desc',
        'user_id': id,
        'with': 'client',
        'deliver_to_client': 1
      });
    }).then((value) {
      readyToBuild = true;
    });

    // Setup scroll listener for pagination
    controller.addListener(() async {
      if (controller.position.maxScrollExtent == controller.offset) {
        setState(() {
          if (currentPage <= pagesCount) {
            currentPage++;
          }
        });
        await fetchCompletedDevice(currentPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompletedDeviceUserCubit, CompletedState>(
      builder: (context, state) {
        if (state is CompletedLoading || !readyToBuild) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 87, 42, 170),
                title: const Text('MYP'),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: searchCompletedDeviceUser());
                    },
                  ),
                ],
              ),
              drawer: const UserDrawer(),
              body: Container(
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator())));
        } else if (state is CompletedSucces) {
          if (firstTime) {
            totalCount = state.data.pagination?['total'];
            currentPage = state.data.pagination?['current_page'];
            pagesCount = state.data.pagination?['last_page'];
            completedDevices
                .addAll(state.data.items! as Iterable<CompletedDevice>);
            firstTime = false;
          }

          return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 87, 42, 170),
                title: const Text('MYP'),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: searchCompletedDeviceUser());
                    },
                  ),
                ],
              ),
              drawer: const UserDrawer(),
              body: Container(
                  padding: const EdgeInsets.all(5),
                  child: RefreshIndicator(
                      onRefresh: _refreshData,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: controller,
                        itemCount: completedDevices.length + 1,
                        itemBuilder: (context, i) {
                          if (i < completedDevices.length) {
                            CompletedDevice completedDevice =
                                completedDevices[i];
                            return Card(
                              color: completedDevice.repairedInCenter == 1
                                  ? const Color.fromARGB(255, 194, 177, 204)
                                  : const Color.fromARGB(255, 252, 234, 251),
                              child: Column(
                                children: [
                                  ExpansionTile(
                                    expandedAlignment:
                                        FractionalOffset.topRight,
                                    title: Text(completedDevice.model),
                                    subtitle: Text(completedDevice.imei ?? ''),
                                    children: <Widget>[
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25,
                                              top: 5,
                                              bottom: 5,
                                              right: 25),
                                          child: Container(
                                              transformAlignment:
                                                  Alignment.topRight,
                                              decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 242, 235, 247),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              padding: const EdgeInsets.all(10),
                                              alignment: Alignment.topLeft,
                                              child: Column(children: [
                                                Row(
                                                  children: [
                                                    const Expanded(
                                                        child: Text("الشكوى")),
                                                    const Expanded(
                                                        child: Text(":")),
                                                    Expanded(
                                                        child: Text(
                                                            "${completedDevice.customerComplaint}")),
                                                  ],
                                                ),
                                                const SizedBox(height: 3),
                                                Row(
                                                  children: [
                                                    const Expanded(
                                                        child: Text("العطل")),
                                                    const Expanded(
                                                        child: Text(":")),
                                                    Expanded(
                                                        child: Text(
                                                            "${completedDevice.problem}")),
                                                  ],
                                                ),
                                                const SizedBox(height: 3),
                                                Row(
                                                  children: [
                                                    const Expanded(
                                                        child: Text(
                                                            "التكلفة على العميل")),
                                                    const Expanded(
                                                        child: Text(":")),
                                                    Expanded(
                                                        child: Text(
                                                            "${completedDevice.costToClient}")),
                                                  ],
                                                ),
                                                const SizedBox(height: 3),
                                                Row(
                                                  children: [
                                                    const Expanded(
                                                        child: Text("الحالة")),
                                                    const Expanded(
                                                        child: Text(":")),
                                                    Expanded(
                                                        child: Text(
                                                            "${completedDevice.status}")),
                                                  ],
                                                ),
                                                TextButton(
                                                    onPressed: () {
                                                      _showCompletedDeviceDetailsDialog(
                                                          completedDevice);
                                                    },
                                                    child: const Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                          'عرض جميع البيانات'),
                                                    )),
                                              ])))
                                    ],
                                  )
                                ],
                              ),
                            );
                          } else if (currentPage <= pagesCount &&
                              pagesCount > 1) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else {
                            return completedDevices.isEmpty
                                ? firstTime
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : const Center(child: Text('لا يوجد اجهزة'))
                                : completedDevices.length >= 20
                                    ? const Center(
                                        child: Text('لا يوجد المزيد'))
                                    : null;
                          }
                        },
                      ))));
        } else if (state is CompletedFailure) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 87, 42, 170),
                title: const Text('MYP'),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: searchCompletedDeviceUser());
                    },
                  ),
                ],
              ),
              drawer: const UserDrawer(),
              body: Center(child: Text(state.errorMessage)));
        }
        return Container();
      },
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      currentPage = 1;
      completedDevices.clear();
      fetchCompletedDevice(currentPage);
    });
  }

  void _showCompletedDeviceDetailsDialog(CompletedDevice completedDevice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تفاصيل الجهاز: ${completedDevice.model}'),
          content: completedDeviceInfoUserCard(
            completedDevice: completedDevice,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('إغلاق'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
