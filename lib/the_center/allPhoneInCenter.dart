// ignore_for_file: file_names, unnecessary_import, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:graduation_mobile/bar/custom_drawer.dart';

import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/the_center/center.dart';
import 'package:graduation_mobile/the_center/cubit/all_phone_in_center_cubit.dart';

import '../Controllers/crud_controller.dart';
import '../allDevices/cubit/all_devices_cubit.dart';
import '../allDevices/screen/allDevices.dart';
import '../allDevices/screen/cubit/edit_cubit.dart';
import '../allDevices/screen/edit.dart';
import '../bar/SearchAppBar.dart';
import '../models/device_model.dart';

class allPhoneInCenter extends StatefulWidget {
  const allPhoneInCenter({super.key});

  @override
  State<allPhoneInCenter> createState() => _allPhoneInCenter();
}

int? selectedDeviceId;

class _allPhoneInCenter extends State<allPhoneInCenter> {
  int perPage = 20;
  int currentPage = 1;
  int pagesCount = 0;
  int totalCount = 0;
  List<dynamic> devices = [];
  bool firstTime = true;
  bool readyToBuild = false;
  Future<void> fetchDevices([int page = 1, int perPage = 20]) async {
    try {
      if (currentPage > pagesCount) {
        return;
      }
      int? id = await InstanceSharedPrefrences().getId();
      var data = await CrudController<Device>().getAll({
        'page': currentPage,
        'per_page': perPage,
        'orderBy': 'date_receipt',
        'dir': 'desc',
        'client_id': id
      });
      final List<Device>? devices = data.items;
      if (devices != null) {
        int currentPage = data.pagination?['current_page'];
        int lastPage = data.pagination?['last_page'];
        int totalCount = data.pagination?['total'];
        setState(() {
          this.currentPage = currentPage;
          pagesCount = lastPage;
          this.devices.addAll(devices);
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
              BlocProvider.of<AllPhoneInCenterCubit>(Get.context!)
                  .getDeviceData({
                'with': 'customer',
                'page': 1,
                'per_page': perPage,
                'orderBy': 'client_priority',
                // 'dir': 'desc',
                'client_id': id
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
        await fetchDevices(currentPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllPhoneInCenterCubit, AllPhoneInCenterState>(
        builder: (context, state) {
      if (state is AllPhoneInCenterLoading || readyToBuild == false) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is AllPhoneInCenterSuccess) {
        if (firstTime) {
          totalCount = state.data.pagination?['total'];
          currentPage = state.data.pagination?['current_page'];
          pagesCount = state.data.pagination?['last_page'];
          devices.addAll(state.data.items!);
          firstTime = false;
        }

        return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 87, 42, 170),
              title: const Text('MYP'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    showSearch(context: context, delegate: search());
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
                        child: ReorderableListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollController: controller,
                            onReorder: (oldIndex, newIndex) async {
                              setState(() {
                                final item = devices.removeAt(oldIndex);
                                devices.insert(newIndex, item);

                                context
                                    .read<AllDevicesCubit>()
                                    .reorderDevices(item.id, newIndex, oldIndex)
                                    .then((value) {
                                  Get.offAll(() => center());
                                });
                              });
                            },
                            children: List.generate(
                              devices.length + 1,
                              (i) {
                                if (i < devices.length) {
                                  return Dismissible(
                                    key: ValueKey(devices[i].id),
                                    onDismissed: (direction) {
                                      setState(() {
                                        devices.removeAt(i);
                                      });
                                    },
                                    child: Card(
                                      key: ValueKey(devices[i].id),
                                      color: const Color.fromARGB(
                                          255, 252, 234, 251),
                                      child: Column(
                                        children: [
                                          ExpansionTile(
                                            title: Text(devices[i].model),
                                            subtitle: Text(devices[i].imei),
                                            trailing: IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                if (devices[i].id != null) {
                                                  selectedDeviceId =
                                                      devices[i].id;
                                                  BlocProvider.of<EditCubit>(
                                                          context)
                                                      .exitIdDevice(
                                                          id: selectedDeviceId!);
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return edit();
                                                    },
                                                  );
                                                }
                                              },
                                            ),
                                            children: <Widget>[
                                              Padding(
                                                  key: ValueKey(devices[i].id),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 25,
                                                          top: 5,
                                                          bottom: 5,
                                                          right: 25),
                                                  child: Container(
                                                      transformAlignment:
                                                          Alignment.topRight,
                                                      decoration: const BoxDecoration(
                                                          color: Color.fromARGB(
                                                              255,
                                                              242,
                                                              235,
                                                              247),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      padding: const EdgeInsets
                                                          .all(10),
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Column(children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: Text(
                                                                    "${devices[i].problem}")),
                                                            const Expanded(
                                                                child:
                                                                    Text(":")),
                                                            const Expanded(
                                                                child: Text(
                                                                    "العطل")),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: Text(
                                                                    "${devices[i].costToCustomer}")),
                                                            const Expanded(
                                                                child:
                                                                    Text(":")),
                                                            const Expanded(
                                                                child: Text(
                                                                    "التكلفة ")),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: Text(
                                                                    "${devices[i].status}")),
                                                            const Expanded(
                                                                child:
                                                                    Text(":")),
                                                            const Expanded(
                                                                child: Text(
                                                                    "الحالة")),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                      ])))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  if (currentPage <= pagesCount &&
                                      pagesCount > 1) {
                                    return const Padding(
                                      key: ValueKey('loading'),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 32),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  } else {
                                    return devices.isNotEmpty
                                        ? firstTime
                                            ? const Center(
                                                key: ValueKey(
                                                    'no_devices_first_time'),
                                                child: Text('لا يوجد اجهزة'))
                                            : devices.length >= 20
                                                ? const Center(
                                                    key: ValueKey(
                                                        'no_more_devices'),
                                                    child:
                                                        Text('لا يوجد المزيد'))
                                                : const SizedBox(
                                                    key: ValueKey(
                                                        'no_devices_first_time'),
                                                  )
                                        : const Center(
                                            key: ValueKey(
                                                'loading_more_devices'),
                                            child: CircularProgressIndicator());
                                  }
                                }
                              },
                            ))))));

        // Example: Print the name of the second user
      } else if (state is AllPhoneInCenterFailuer) {
        return Center(child: Text(state.errorMessage));
      }
      return const Center(child: Text("done"));
    });
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      currentPage = 1;
      devices.clear();
      fetchDevices(currentPage);
    });
  }
}
