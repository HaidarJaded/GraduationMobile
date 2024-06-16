// ignore_for_file: camel_case_types, non_constant_identifier_names, unnecessary_const, avoid_unnecessary_containers, must_be_immutable, body_might_complete_normally_nullable, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graduation_mobile/bar/SearchAppBar.dart';

class orders extends StatefulWidget {
  orders({super.key, required this.Client_id});
  int Client_id;

  @override
  State<orders> createState() => _ordersState();
}

List order = [{}, {}];

class _ordersState extends State<orders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 87, 42, 170),
          title: const Text('ClientName'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: search());
              },
            ),
          ],
        ),
        body: Container(
            child: Container(
                padding: const EdgeInsets.all(5),
                child: RefreshIndicator(
                    onRefresh: _refreshData,
                    child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        // controller: controller,
                        itemCount: order.length + 1,
                        itemBuilder: (context, i) {
                          if (i < order.length) {
                            return Card(
                              // key: ValueKey(state.data[index].itemName),
                              color: const Color.fromARGB(255, 252, 234, 251),
                              child: ListTile(
                                title: const Text("device.model"),
                                subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('device.imei'),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      const Text('device.code'),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      InkWell(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          gradient:
                                              const LinearGradient(colors: [
                                            Color.fromARGB(255, 235, 233, 245),
                                            Color.fromARGB(255, 255, 255, 255),
                                          ]),
                                        ),
                                        child: const Text("تم الاستيلام"),
                                      ))
                                    ]),
                              ),
                            );
                          }
                        })))));
  }
}

Future<void> _refreshData() async {
  await Future.delayed(const Duration(milliseconds: 500));
  // setState(() {

  // });
}
