// ignore: file_names
// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_local_variable, unused_element, file_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/allDevices/screen/addDevice.dart';

import '../../bar/CustomDrawer.dart';
import '../../bar/SearchAppBar.dart';
import '../cubit/all_devices_cubit.dart';

class allDevices extends StatefulWidget {
  const allDevices({super.key});

  @override
  State<allDevices> createState() => _allDevicesState();
}

final List<Map<String, String>> _devicesData = [];

class _allDevicesState extends State<allDevices> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllDevicesCubit, AllDevicesState>(
      builder: (context, state) {
        if (state is AllDevicesLoading) {
          return Scaffold(
              appBar: SearchAppBar(),
              drawer: const CustomDrawer(),
              body: const Center(child: CircularProgressIndicator()));
        } else if (state is AllDevicesSucces) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return addDevices(
                        title: "اضف جهاز",
                      );
                    },
                  );
                },
                child: const Icon(Icons.add),
              ),
              appBar: SearchAppBar(),
              drawer: const CustomDrawer(),
              // ignore: avoid_unnecessary_containers
              body: Container(
                  child: Container(
                padding: const EdgeInsets.all(5),
                child: ListView.builder(
                  itemCount: state.device.length,
                  itemBuilder: (context, i) {
                    return Card(
                      // key: ValueKey(state.data[index].itemName),
                      color: const Color.fromARGB(255, 252, 234, 251),
                      child: Column(
                        children: [
                          ExpansionTile(
                            // key: ValueKey(),
                            expandedAlignment: FractionalOffset.topRight,
                            title: Text(state.device[i].model),
                            subtitle:
                                // ignore: prefer_interpolation_to_compose_strings
                                Text(state.device[i].imei),
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
                                                child: Text(
                                                    state.device[i].status)),
                                            const Expanded(child: Text(":")),
                                            const Expanded(
                                                child: Text("العطل")),
                                          ],
                                        ),
                                        // Row(
                                        //   children: [
                                        //     Expanded(child: state.device[i].costToClient),
                                        //     const Expanded(child: Text(":")),
                                        //     const Expanded(child: Text("التكلفة ")),
                                        //   ],
                                        // ),
                                      ])))
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  // onReorder: (int oldIndex, int newIndex) {
                  //   context
                  //       .read<AllDevicesCubit>()
                  //       .reorderDevices(oldIndex, newIndex);
                  // },
                ),
              )));

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
                    return addDevices(
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
}

// Widget deviceData(int index, Map<String, String> device) => Card(
//       key: ValueKey(state.data[index].itemName),
//       color: const Color.fromARGB(255, 252, 234, 251),
//       child: Column(
//         children: [
//           ExpansionTile(
//             key: ValueKey(device['imei']),
//             expandedAlignment: FractionalOffset.topRight,
//             title: Text(device['model']!),
//             subtitle:
//                 // ignore: prefer_interpolation_to_compose_strings
//                 Text(device['imei']!),
//             children: <Widget>[
//               Padding(
//                   padding: const EdgeInsets.only(
//                       left: 25, top: 5, bottom: 5, right: 25),
//                   child: Container(
//                       transformAlignment: Alignment.topRight,
//                       decoration: const BoxDecoration(
//                           color: Color.fromARGB(255, 242, 235, 247),
//                           borderRadius: BorderRadius.all(Radius.circular(10))),
//                       padding: const EdgeInsets.all(10),
//                       alignment: Alignment.topLeft,
//                       child: Column(children: [
//                         Row(
//                           children: [
//                             Expanded(child: Text(device['problem']!)),
//                             const Expanded(child: Text(":")),
//                             const Expanded(child: Text("العطل")),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Expanded(child: Text(device['cost_to_client']!)),
//                             const Expanded(child: Text(":")),
//                             const Expanded(child: Text("التكلفة ")),
//                           ],
//                         ),
//                       ])))
//             ],
//           )
//         ],
//       ),
//     );
