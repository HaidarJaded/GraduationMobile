// ignore_for_file: file_names, unnecessary_string_interpolations, body_might_complete_normally_nullable, camel_case_types, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';

import 'package:graduation_mobile/models/device_model.dart';

import '../allDevices/screen/cubit/edit_cubit.dart';
import '../allDevices/screen/device_info_card.dart';
import '../allDevices/screen/edit_device.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueNotifier<bool> _isSearching = ValueNotifier(false);

  SearchAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isSearching,
      builder: (context, bool isSearching, _) {
        return AppBar(
          backgroundColor: const Color.fromARGB(255, 87, 42, 170),
          title: isSearching
              ? const TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search',
                  ),
                )
              : const Text('MYP'),
          actions: <Widget>[
            isSearching
                ? IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      _isSearching.value = false;
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _isSearching.value = true;
                      // showSearch(context: context, delegate: search());
                    },
                  ),
          ],
        );
      },
    );
  }
}

class search extends SearchDelegate {
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
                'orderBy': 'date_receipt',
                'dir': 'desc',
                'client_id': idSnapShot.data,
                'deliver_to_client': 0,
                'all_data': 1
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
                                  Device device = filter[i];
                                  return Card(
                                    // key: ValueKey(state.data[index].itemName),
                                    color: device.repairedInCenter == 1
                                        ? const Color.fromARGB(
                                            255, 194, 177, 204)
                                        : const Color.fromARGB(
                                            255, 252, 234, 251),
                                    child: Column(
                                      children: [
                                        ExpansionTile(
                                          // key: ValueKey(),
                                          expandedAlignment:
                                              FractionalOffset.topRight,

                                          title: Text(filter[i].model),

                                          subtitle:
                                              // ignore: prefer_interpolation_to_compose_strings
                                              Text(filter[i].imei),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () {
                                              if (filter[i].id != null) {
                                                selectedDeviceId = filter[i].id;

                                                BlocProvider.of<EditCubit>(
                                                        context)
                                                    .exitIdDevice(
                                                        id: selectedDeviceId!);
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
                                                          Expanded(
                                                              child: Text(
                                                                  "${filter[i].problem ?? "لم تحدد بعد"}")),
                                                          const Expanded(
                                                              child: Text(":")),
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
                                                                  "${filter[i].costToCustomer ?? "لم تحدد بعد"}")),
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
                                                                  "${filter[i].status}")),
                                                          const Expanded(
                                                              child: Text(":")),
                                                          const Expanded(
                                                              child: Text(
                                                                  "الحالة")),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
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
                                }
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
          width: 100,
          height: 50,
          child: DeviceInfoCard(
            device: device,
          ),
        );
      },
    );
  }
}
