// ignore_for_file: file_names, camel_case_types, avoid_unnecessary_containers, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: unnecessary_import
import 'package:get/get_core/src/get_main.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/models/completed_device_model.dart';
import 'package:graduation_mobile/pages/client/drawer/oldPhoneUser/completd_clint_info_card.dart';

class searchCompletedDeviceUser extends SearchDelegate {
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
              future: CrudController<CompletedDevice>().getAll({
                'search': query,
                'orderBy': 'date_delivery_client',
                'dir': 'desc',
                'user_id': idSnapShot.data,
                'with': 'client',
                'deliver_to_client': 1
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
                  return Container(
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          child: ListView.builder(
                              itemCount: filter.length,
                              itemBuilder: (context, i) {
                                if (i < filter.length) {
                                  return Card(
                                    color: const Color.fromARGB(
                                        255, 252, 234, 251),
                                    child: Column(
                                      children: [
                                        ExpansionTile(
                                          expandedAlignment:
                                              FractionalOffset.topRight,
                                          title: Text(
                                            filter[i].model,
                                          ),
                                          subtitle:
                                              // ignore: prefer_interpolation_to_compose_strings
                                              Text(filter[i].imei ?? ''),
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
                                                                  "${filter[i].costToClient}")),
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
                                                                  "${filter[i].status}")),
                                                        ],
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            _showCompletedDeviceDetailsDialog(
                                                                filter[i]);
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

  void _showCompletedDeviceDetailsDialog(dynamic completedDevice) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return SizedBox(
          width: 50,
          height: 50,
          child: completedDeviceInfoUserCard(
            completedDevice: completedDevice,
          ),
        );
      },
    );
  }
}
