// ignore: file_names
// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_local_variable, unused_element, file_names, duplicate_ignore, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';

import 'package:graduation_mobile/drawerScreen/oldPhone/cubit/completed_device_cubit.dart';
import 'package:graduation_mobile/drawerScreen/oldPhone/searchCompletedDevice.dart';

import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/models/completed_device_model.dart';

import '../../../bar/custom_drawer.dart';
import '../../../bar/SearchAppBar.dart';

import 'completedDeviceInfoCard.dart';

class oldPhone extends StatefulWidget {
  const oldPhone({super.key});

  @override
  State<oldPhone> createState() => _oldPhoneState();
}

class _oldPhoneState extends State<oldPhone> {
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
        'orderBy': 'date_delivery_customer',
        'dir': 'desc',
        'client_id': id,
        'with': 'customer',
        'deliver_to_customer': 1
      });
      final List<CompletedDevice>? completedDevices = data.items;
      if (completedDevices != null) {
        int currentPage = data.pagination?['current_page'];
        int lastPage = data.pagination?['last_page'];
        int totalCount = data.pagination?['total'];
        setState(() {
          this.currentPage = currentPage;
          pagesCount = lastPage;
          this.completedDevices.addAll(completedDevices);
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
    InstanceSharedPrefrences()
        .getId()
        .then((id) => {
              BlocProvider.of<CompletedDeviceCubit>(Get.context!)
                  .getCompletedDeviceData({
                'page': 1,
                'per_page': perPage,
                'orderBy': 'date_delivery_customer',
                'dir': 'desc',
                'client_id': id,
                'with': 'customer',
                'deliver_to_customer': 1
              })
            })
        .then((value) => readyToBuild = true);

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
    return BlocBuilder<CompletedDeviceCubit, CompletedDeviceState>(
      builder: (context, state) {
        if (state is CompletedDeviceLoading || readyToBuild == false) {
          return Scaffold(
              appBar: SearchAppBar(),
              drawer: const CustomDrawer(),
              body: Container(
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator())));
        } else if (state is CompletedDeviceSucces) {
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
                          context: context, delegate: searchCompletedDevice());
                    },
                  ),
                ],
              ),
              drawer: const CustomDrawer(),
              // ignore: avoid_unnecessary_containers
              body: Container(
                  child: Container(
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
                                  color:
                                      const Color.fromARGB(255, 252, 234, 251),
                                  child: Column(
                                    children: [
                                      ExpansionTile(
                                        expandedAlignment:
                                            FractionalOffset.topRight,
                                        title: Text(
                                          completedDevice.model,
                                        ),
                                        subtitle:
                                            // ignore: prefer_interpolation_to_compose_strings
                                            Text(completedDevice.imei ?? ''),
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets
                                                  .only(
                                                  left: 25,
                                                  top: 5,
                                                  bottom: 5,
                                                  right: 25),
                                              child: Container(
                                                  transformAlignment: Alignment
                                                      .topRight,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Color
                                                              .fromARGB(
                                                                  255,
                                                                  242,
                                                                  235,
                                                                  247),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10))),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  alignment: Alignment.topLeft,
                                                  child: Column(children: [
                                                    Row(
                                                      children: [
                                                        const Expanded(
                                                            child:
                                                                Text("الشكوى")),
                                                        const Expanded(
                                                            child: Text(":")),
                                                        Expanded(
                                                            child: Text(
                                                                "${completedDevice.customerComplaint}")),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 3,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Expanded(
                                                            child:
                                                                Text("العطل")),
                                                        const Expanded(
                                                            child: Text(":")),
                                                        Expanded(
                                                            child: Text(
                                                                "${completedDevice.problem}")),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 3,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Expanded(
                                                            child: Text(
                                                                "التكلفة على الزبون")),
                                                        const Expanded(
                                                            child: Text(":")),
                                                        Expanded(
                                                            child: Text(
                                                                "${completedDevice.costToCustomer}")),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 3,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Expanded(
                                                            child:
                                                                Text("الحالة")),
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
                                                          alignment: Alignment
                                                              .centerLeft,
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
                                        : const Center(
                                            child: Text('لا يوجد اجهزة'))
                                    : completedDevices.length >= 20
                                        ? const Center(
                                            child: Text('لا يوجد المزيد'))
                                        : null;
                              }
                            },
                          )))));

          // Example: Print the name of the second user
        } else if (state is CompletedDeviceFailure) {
          return Scaffold(
              appBar: SearchAppBar(),
              drawer: const CustomDrawer(),
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

  void _showCompletedDeviceDetailsDialog(dynamic completedDevice) {
    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          width: 50,
          height: 50,
          child: completedDeviceInfoCard(
            completedDevice: completedDevice,
          ),
        );
      },
    );
  }
}
