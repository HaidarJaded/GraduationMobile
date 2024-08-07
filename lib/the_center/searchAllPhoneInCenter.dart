// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/pages/client/widget/device_info.dart';

import '../../Controllers/crud_controller.dart';
import '../../helper/shared_perferences.dart';
import '../allDevices/screen/edit_device.dart';

class searchAllPhoneInCenter extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.cancel))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text("data");
  }

  int? selectedDeviceId;
  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: InstanceSharedPrefrences().getId(),
        builder: (context, idSnapShot) {
          if (idSnapShot.connectionState == ConnectionState.done) {
            return FutureBuilder(
              future: CrudController<Device>().getAll({
                'search': query,
                'orderBy': 'client_priority',
                'client_id': idSnapShot.data,
                'repaired_in_center': 1,
                'with': 'customer',
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("لم يتم العثور على نتائج"),
                  );
                } else {
                  final filter = snapshot.data?.items;
                  if (filter == null || filter.isEmpty) {
                    return const Center(
                      child: Text("لم يتم العثور على نتائج"),
                    );
                  }
                  // ignore: avoid_unnecessary_containers
                  return Container(
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          child: ListView.builder(
                              itemCount: filter.length,
                              itemBuilder: (context, i) {
                                if (i < filter.length) {
                                  return Card(
                                    key: ValueKey(filter[i].id),
                                    color: const Color.fromARGB(
                                        255, 252, 234, 251),
                                    child: Column(
                                      children: [
                                        ExpansionTile(
                                          title: Text(filter[i].model),
                                          subtitle: Text(filter[i].imei),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () {
                                              if (filter[i].id != null) {
                                                selectedDeviceId = filter[i].id;
                                                // BlocProvider.of<EditCubit>(
                                                //         context)
                                                //     .exitIdDevice(
                                                //         id: selectedDeviceId!);
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return EditDevice(
                                                      device: filter[i],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                          children: <Widget>[
                                            Padding(
                                                key: ValueKey(filter[i].id),
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
                                                                  "${filter[i].problem}")),
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
                                                                  "${filter[i].costToCustomer}")),
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
                                                          Expanded(child: Text(
                                                              // ignore: unnecessary_string_interpolations
                                                              "${filter[i].status}")),
                                                        ],
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            _showDeviceDetailsDialog(
                                                                filter[i]);
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
                                }
                                return null;
                              })));
                }
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _showDeviceDetailsDialog(dynamic device) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return SizedBox(
          width: 50,
          height: 50,
          child: DeviceInfo(
            device: device,
          ),
        );
      },
    );
  }
}
