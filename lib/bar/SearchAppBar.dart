// ignore_for_file: file_names, unnecessary_string_interpolations, body_might_complete_normally_nullable, camel_case_types, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:graduation_mobile/models/device_model.dart';

import '../allDevices/screen/cubit/edit_cubit.dart';
import '../allDevices/screen/edit.dart';

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
  List<Device> data;
  search({required this.data});

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
    List filter = data.where((element) {
      return element.model.contains(query) || element.imei.contains(query);
    }).toList();

    return Container(
        child: Container(
            padding: const EdgeInsets.all(5),
            child: ListView.builder(
                itemCount: query == "" ? data.length : filter.length,
                itemBuilder: (context, i) {
                  if (i < data.length) {
                    return Card(
                      // key: ValueKey(state.data[index].itemName),
                      color: const Color.fromARGB(255, 252, 234, 251),
                      child: Column(
                        children: [
                          ExpansionTile(
                            // key: ValueKey(),
                            expandedAlignment: FractionalOffset.topRight,

                            title: Text(
                                query == "" ? data[i].model : filter[i].model),

                            subtitle:
                                // ignore: prefer_interpolation_to_compose_strings
                                Text(query == ""
                                    ? data[i].imei
                                    : filter[i].imei),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                if (data[i].id != null) {
                                  selectedDeviceId = data[i].id;

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
                                          color: Color.fromARGB(
                                              255, 242, 235, 247),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      padding: const EdgeInsets.all(10),
                                      alignment: Alignment.topLeft,
                                      child: Column(children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text(query == ""
                                                    ? "${data[i].problem}"
                                                    : "${filter[i].problem}")),
                                            const Expanded(child: Text(":")),
                                            const Expanded(
                                                child: Text("العطل")),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text(query == ""
                                                    ? "${data[i].costToCustomer}"
                                                    : "${filter[i].costToCustomer}")),
                                            const Expanded(child: Text(":")),
                                            const Expanded(
                                                child: Text("التكلفة ")),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text(query == ""
                                                    ? "${data[i].status}"
                                                    : "${filter[i].status}")),
                                            const Expanded(child: Text(":")),
                                            const Expanded(
                                                child: Text("الحالة")),
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
                    );
                  }
                })));
  }
}
