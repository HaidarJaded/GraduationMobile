// ignore: file_names
// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_local_variable, unused_element, file_names, duplicate_ignore, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/allDevices/screen/edit.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/models/device_model.dart';
import '../../bar/custom_drawer.dart';
import '../../bar/SearchAppBar.dart';
import '../cubit/all_devices_cubit.dart';

import 'search_for_a _customer.dart';
import 'cubit/edit_cubit.dart';

class allDevices extends StatefulWidget {
  const allDevices({super.key});

  @override
  State<allDevices> createState() => _allDevicesState();
}

int? selectedDeviceId;

class _allDevicesState extends State<allDevices> {
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
              BlocProvider.of<AllDevicesCubit>(Get.context!).getDeviceData({
                'page': 1,
                'per_page': perPage,
                'orderBy': 'date_receipt',
                'dir': 'desc',
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
    return BlocBuilder<AllDevicesCubit, AllDevicesState>(
      builder: (context, state) {
        if (state is AllDevicesLoading || readyToBuild == false) {
          return Scaffold(
              appBar: SearchAppBar(),
              drawer: const CustomDrawer(),
              body: const Center(child: CircularProgressIndicator()));
        } else if (state is AllDevicesSucces) {
          if (firstTime) {
            totalCount = state.data.pagination?['total'];
            currentPage = state.data.pagination?['current_page'];
            pagesCount = state.data.pagination?['last_page'];
            devices.addAll(state.data.items!);
            firstTime = false;
          }
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Search_for_a_customer(
                        title: "اضف جهاز",
                      );
                    },
                  );
                },
                child: const Icon(Icons.add),
              ),
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 87, 42, 170),
                title: const Text('MYP'),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate:
                              search(data: state.data.items as List<Device>));
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
                            itemCount: devices.length + 1,
                            itemBuilder: (context, i) {
                              if (i < devices.length) {
                                return Card(
                                  // key: ValueKey(state.data[index].itemName),
                                  color:
                                      const Color.fromARGB(255, 252, 234, 251),
                                  child: Column(
                                    children: [
                                      ExpansionTile(
                                        // key: ValueKey(),
                                        expandedAlignment:
                                            FractionalOffset.topRight,
                                        title: Text(
                                          devices[i].model,
                                        ),

                                        subtitle:
                                            // ignore: prefer_interpolation_to_compose_strings
                                            Text(devices[i].imei),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            if (devices[i].id != null) {
                                              selectedDeviceId = devices[i].id;

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
                                                        Expanded(
                                                            child: Text(
                                                                "${devices[i].problem ?? "لم يحدد بعد"}")),
                                                        const Expanded(
                                                            child: Text(":")),
                                                        const Expanded(
                                                            child:
                                                                Text("العطل")),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 3,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                                "${devices[i].costToCustomer ?? "لم تحدد بعد"}")),
                                                        const Expanded(
                                                            child: Text(":")),
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
                                                            child: Text(":")),
                                                        const Expanded(
                                                            child:
                                                                Text("الحالة")),
                                                      ],
                                                    ),
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
                                return devices.isNotEmpty
                                    ? firstTime
                                        ? const Center(
                                            child: Text('لا يوجد اجهزة'))
                                        : devices.length >= 20
                                            ? const Center(
                                                child: Text('لا يوجد المزيد'))
                                            : null
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      );
                              }
                            },
                            // onReorder: (int oldIndex, int newIndex) {
                            //   context
                            //       .read<AllDevicesCubit>()
                            //       .reorderDevices(oldIndex, newIndex);
                            // },
                          )))));

          // Example: Print the name of the second user
        } else if (state is AllDevicesfailure) {
          return Scaffold(
              appBar: SearchAppBar(),
              drawer: const CustomDrawer(),
              body: Center(child: Text(state.errorMessage)));
        }
        return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Search_for_a_customer(
                      title: "اضف جهاز",
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
            appBar: SearchAppBar(),
            drawer: const CustomDrawer(),
            body: const Center(
              child: CircularProgressIndicator(),
            ));
      },
    );
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
