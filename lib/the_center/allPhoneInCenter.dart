// ignore_for_file: file_names, unnecessary_import, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:graduation_mobile/bar/custom_drawer.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/the_center/cubit/all_phone_in_center_cubit.dart';
import '../Controllers/crud_controller.dart';
import '../allDevices/screen/cubit/edit_cubit.dart';
import '../allDevices/screen/device_info_card.dart';
import '../allDevices/screen/edit.dart';
import '../models/device_model.dart';
import 'searchAllPhoneInCenter.dart';

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
        'orderBy': 'client_priority',
        'client_id': id,
        'deliver_to_client': 0,
        'repaired_in_center': 1,
        'with': 'customer',
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
                'deliver_to_client': 0,
                'client_id': id,
                'repaired_in_center': 1,
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
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 87, 42, 170),
            title: const Text('MYP'),
          ),
          drawer: const CustomDrawer(),
          body: const Center(child: CircularProgressIndicator()),
        );
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
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showSearch(
                        context: context, delegate: searchAllPhoneInCenter());
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
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                devices.insert(newIndex, item);
                                context
                                    .read<AllPhoneInCenterCubit>()
                                    .reorderDevices(
                                        item.id, newIndex, oldIndex);
                              });
                            },
                            children: List.generate(
                              devices.length + 1,
                              (i) {
                                if (i < devices.length) {
                                  return Card(
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
                                                                Radius.circular(
                                                                    10))),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Column(children: [
                                                      Row(
                                                        children: [
                                                          const Expanded(
                                                              child: Text(
                                                                  "العطل")),
                                                          const Expanded(
                                                              child: Text(":")),
                                                          Expanded(
                                                              child: Text(
                                                                  "${devices[i].problem}")),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Expanded(
                                                              child: Text(
                                                                  "التكلفة ")),
                                                          const Expanded(
                                                              child: Text(":")),
                                                          Expanded(
                                                              child: Text(
                                                                  "${devices[i].costToCustomer}")),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Expanded(
                                                              child: Text(
                                                                  "الحالة")),
                                                          const Expanded(
                                                              child: Text(":")),
                                                          Expanded(
                                                              child: Text(
                                                                  "${devices[i].status}")),
                                                        ],
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            _showDeviceDetailsDialog(
                                                                devices[i]);
                                                          },
                                                          child: const Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                                'عرض جميع البيانات'),
                                                          )),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                    ])))
                                          ],
                                        )
                                      ],
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
                                    return _buildNoMoreDevices();
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

  void _showDeviceDetailsDialog(dynamic device) {
    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          width: 50,
          height: 50,
          child: DeviceInfoCard(
            device: device,
          ),
        );
      },
    );
  }

  Widget _buildNoMoreDevices() {
    if (devices.isEmpty) {
      if (totalCount == 0) {
        return const Center(
          key: ValueKey('no_devices_first_time'),
          child: Text('لا يوجد أجهزة'),
        );
      }
      return const Center(
        key: ValueKey('loading_more_devices'),
        child: CircularProgressIndicator(),
      );
    } else if (devices.length >= 20) {
      return const Center(
        key: ValueKey('no_more_devices'),
        child: Text('لا يوجد المزيد'),
      );
    } else {
      return const SizedBox(key: ValueKey('no_devices_first_time'));
    }
  }
}
