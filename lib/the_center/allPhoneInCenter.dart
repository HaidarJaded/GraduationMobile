// ignore_for_file: file_names, unnecessary_import, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/the_center/cubit/all_phone_in_center_cubit.dart';

import '../Controllers/crud_controller.dart';
import '../allDevices/screen/cubit/edit_cubit.dart';
import '../allDevices/screen/edit.dart';
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
            // ignore: avoid_unnecessary_containers
            body: Container(
                child: Container(
          padding: const EdgeInsets.all(5),
          child: ListView.builder(
            controller: controller,
            itemCount: devices.length + 1,
            itemBuilder: (context, i) {
              if (i < devices.length) {
                return Card(
                  // key: ValueKey(state.data[index].itemName),
                  color: const Color.fromARGB(255, 252, 234, 251),
                  child: Column(
                    children: [
                      ExpansionTile(
                        // key: ValueKey(),
                        expandedAlignment: FractionalOffset.topRight,
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

                              BlocProvider.of<EditCubit>(context)
                                  .exitIdDevice(id: selectedDeviceId!);
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
                              padding: const EdgeInsets.only(
                                  left: 25, top: 5, bottom: 5, right: 25),
                              child: Container(
                                  transformAlignment: Alignment.topRight,
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 242, 235, 247),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  padding: const EdgeInsets.all(10),
                                  alignment: Alignment.topLeft,
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child:
                                                Text("${devices[i].problem}")),
                                        const Expanded(child: Text(":")),
                                        const Expanded(child: Text("العطل")),
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
                                        const Expanded(child: Text(":")),
                                        const Expanded(child: Text("التكلفة ")),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child:
                                                Text("${devices[i].status}")),
                                        const Expanded(child: Text(":")),
                                        const Expanded(child: Text("الحالة")),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                                "${devices[i].customer.name + devices[i].customer.lastName}")),
                                        const Expanded(child: Text(":")),
                                        const Expanded(
                                            child: Text("اسم المالك")),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                                "${devices[i].customer.phone}")),
                                        const Expanded(child: Text(":")),
                                        const Expanded(
                                            child: Text("رقم المالك")),
                                      ],
                                    ),
                                  ])))
                        ],
                      )
                    ],
                  ),
                );
              } else if (currentPage <= pagesCount && pagesCount > 1) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return devices.isEmpty
                    ? const Center(child: Text('لا يوجد اجهزة'))
                    : devices.length >= 20
                        ? const Center(child: Text('لا يوجد المزيد'))
                        : null;
              }
            },
            // onReorder: (int oldIndex, int newIndex) {
            //   context
            //       .read<AllDevicesCubit>()
            //       .reorderDevices(oldIndex, newIndex);
            // },
          ),
        )));

        // Example: Print the name of the second user
      } else if (state is AllPhoneInCenterFailuer) {
        return Center(child: Text(state.errorMessage));
      }
      return const Center(child: Text("done"));
    });
  }
}
