// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';

class allPhoneInCenter extends StatefulWidget {
  const allPhoneInCenter({super.key});
  static String id = 'allPhoneInCenter';

  @override
  State<allPhoneInCenter> createState() => _allPhoneInCenterState();
}

// ignore: non_constant_identifier_names

class _allPhoneInCenterState extends State<allPhoneInCenter> {
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    // return BlocBuilder<GetDevicesFromCenterCubit, GetDevicesFromCenterState>(
    //   builder: (context, state) {
    //     if (state is GetDevicesFromCenterLoading) {
    //       return const Center(child: CircularProgressIndicator());
    //     } else if (state is GetDevicesFromCentersSucsses) {
    //       // ignore: avoid_unnecessary_containers
    //       return Container(
    // child: Container(
    //     padding: const EdgeInsets.all(5),
    //     child: ListView.builder(
    //         itemCount: state.DevicesData.length,
    //         itemBuilder: (context, i) {
    //           return phoneInCenter_card(
    //             devicesM: state.DevicesData[i],
    //           );
    //         })));
    //     } else if (state is GetDevicesFromCenterFailure) {
    //       return Text(state.errMessage);
    //     }
    // ignore: avoid_unnecessary_containers
    return Container(
        child: Container(
      padding: const EdgeInsets.all(5),
      // child: ListView.builder(
      //     itemCount: ,
      //     itemBuilder: (context, i) {
      //       return phoneInCenter_card(
      //         devicesM:,
      //       );
      //     })
    ));
  }
}
