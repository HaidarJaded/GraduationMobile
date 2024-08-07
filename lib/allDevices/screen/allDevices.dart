// ignore: file_names
// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_local_variable, unused_element, file_names, duplicate_ignore, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/allDevices/screen/Search_for_a_customer.dart';
import 'package:graduation_mobile/allDevices/screen/deliver_device_form.dart';
import 'package:graduation_mobile/allDevices/screen/device_info_card.dart';
import 'package:graduation_mobile/allDevices/screen/edit_device.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/models/user_model.dart';
import '../../bar/custom_drawer.dart';
import '../../bar/SearchAppBar.dart';
import '../cubit/all_devices_cubit.dart';

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
        'orderBy': 'date_receipt_from_customer',
        'dir': 'desc',
        'client_id': id,
        'with': 'customer',
        'deliver_to_customer': 0,
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
                'orderBy': 'date_receipt_from_customer',
                'dir': 'desc',
                'client_id': id,
                'with': 'customer',
                'deliver_to_customer': 0,
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
              body: Container(
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator())));
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
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
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
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: controller,
                            itemCount: devices.length + 1,
                            itemBuilder: (context, i) {
                              if (i < devices.length) {
                                Device device = devices[i];
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
                                          device.model,
                                        ),

                                        subtitle:
                                            // ignore: prefer_interpolation_to_compose_strings
                                            Text(device.imei),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                if (device.id != null) {
                                                  selectedDeviceId = device.id;

                                                  // BlocProvider.of<EditCubit>(
                                                  //         context)
                                                  //     .exitIdDevice(
                                                  //         id: selectedDeviceId!);
                                                  showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return EditDevice(
                                                        device: device,
                                                      );
                                                    },
                                                  ).then((_) {
                                                    setState(() {});
                                                  });
                                                }
                                              },
                                            ),
                                            if (device.deliverToClient == 1 ||
                                                device.dateReceipt == null) ...[
                                              FutureBuilder(
                                                  future: User.hasPermission(
                                                      'تسليم جهاز'),
                                                  builder:
                                                      ((BuildContext context,
                                                          AsyncSnapshot<bool>
                                                              snapshot) {
                                                    if (snapshot.hasData &&
                                                        snapshot.data!) {
                                                      return IconButton(
                                                        onPressed: () {
                                                          if (device
                                                                  .repairedInCenter ==
                                                              0) {
                                                            showDialog(
                                                                context: Get
                                                                    .context!,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return DeliverDeviceForm(
                                                                      device:
                                                                          device);
                                                                }).then((value) {
                                                              if (value !=
                                                                      null &&
                                                                  value) {
                                                                setState(() {
                                                                  devices.remove(
                                                                      device);
                                                                });
                                                              }
                                                            });
                                                            return;
                                                          }
                                                          if (device.status ==
                                                              'جاهز') {
                                                            showDialog(
                                                                context: Get
                                                                    .context!,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return DeliverDeviceForm(
                                                                      device:
                                                                          device);
                                                                }).then((value) {
                                                              if (value) {
                                                                setState(() {
                                                                  devices.remove(
                                                                      device);
                                                                });
                                                              }
                                                            });
                                                            return;
                                                          }
                                                          _showConfirmProcessDialog(
                                                              device.id!,
                                                              () async {
                                                            var response =
                                                                await Api().put(
                                                                    path:
                                                                        'api/devices/${device.id}',
                                                                    body: {
                                                                  'deliver_to_customer':
                                                                      1
                                                                });
                                                            if (response !=
                                                                null) {
                                                              setState(() {
                                                                devices.remove(
                                                                    device);
                                                              });
                                                            }
                                                            Navigator.pop(
                                                                Get.context!);
                                                          });
                                                        },
                                                        icon: const Icon(Icons
                                                            .local_shipping_outlined),
                                                      );
                                                    } else {
                                                      return const SizedBox(); // Placeholder widget if permission check is pending or user doesn't have permission
                                                    }
                                                  }))
                                            ]
                                          ],
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
                                                        const Expanded(
                                                            child: Text(
                                                                "شكوى الزبون")),
                                                        const Expanded(
                                                            child: Text(":")),
                                                        Expanded(
                                                            child: Text(
                                                                "${device.customerComplaint}")),
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
                                                                "${device.problem ?? "لم يحدد بعد"}")),
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
                                                                "${device.costToClient ?? "لم تحدد بعد"}")),
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
                                                                "${device.status}")),
                                                      ],
                                                    ),
                                                    if (device.status ==
                                                        'بانتظار استجابة العميل')
                                                      Row(
                                                        children: [
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                if (await changeClientApproval(
                                                                    false,
                                                                    device
                                                                        .id!)) {
                                                                  setState(() {
                                                                    device.status =
                                                                        'تم رفض العمل به';
                                                                  });
                                                                }
                                                              },
                                                              child:
                                                                  const Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                    'رفض العمل به'),
                                                              )),
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                if (await changeClientApproval(
                                                                    true,
                                                                    device
                                                                        .id!)) {
                                                                  setState(() {
                                                                    device.status =
                                                                        'قيد العمل';
                                                                  });
                                                                }
                                                              },
                                                              child:
                                                                  const Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                    'الموافقة على العمل به'),
                                                              )),
                                                        ],
                                                      ),
                                                    TextButton(
                                                        onPressed: () {
                                                          _showDeviceDetailsDialog(
                                                              device);
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
                                return _buildNoMoreDevices();
                              }
                            },
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
              child: Center(
                child: Text("لا يوجد اجهزة"),
              ),
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
          child: Text('لا يوجد أجهزة'),
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (devices.length >= 20) {
      return const Center(
        child: Text('لا يوجد المزيد'),
      );
    } else {
      return const SizedBox();
    }
  }

  Future<bool> changeClientApproval(bool isClientApproval, int deviceId) async {
    try {
      var response = await Api().put(path: 'api/devices/$deviceId', body: {
        'status': isClientApproval ? 'قيد العمل' : 'لم يوافق على العمل به',
        'client_approval': isClientApproval ? 1 : 0
      });
      if (response == null) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}

void _showConfirmProcessDialog(int deviceId, Function() action) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
            'هل انت متأكد من رغبتك بتسليم الجهاز؟\n لا يمكن التراجع عن الخطوة'),
        actions: <Widget>[
          TextButton(
            child: const Text('لا'),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            onPressed: action,
            child: const Text('نعم'),
          ),
        ],
      );
    },
  );
}
