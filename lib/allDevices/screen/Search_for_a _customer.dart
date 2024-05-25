// ignore_for_file: camel_case_types, must_be_immutable, avoid_print, file_names, unnecessary_string_interpolations, prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/allDevices/screen/addDevce2.dart';

import 'cubit/add_devices_cubit.dart';

class Search_for_a_customer extends StatelessWidget {
  Search_for_a_customer({super.key, required this.title});
  GlobalKey<FormState> myform = GlobalKey<FormState>();
  TextEditingController nationalId = TextEditingController();
  final String title;
  bool exist = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddDevicesCubit, AddDevicesState>(
        builder: (context, state) {
      if (state is AddDevicesLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is AddDevicesFound) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.back();
          Get.dialog(AlertDialog(
              title: const Text("الزبون موجود"),
              content: SizedBox(
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text("الاسم:"),
                    ),
                    Expanded(
                      child: Text('${state.result[0].name}: ' +
                          '${state.result[0].lastName}'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Expanded(
                      child: Text("email:"),
                    ),
                    Expanded(
                      child: Text('${state.result[0].email}'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Expanded(
                      child: Text("الرقم:"),
                    ),
                    Expanded(
                      child: Text('${state.result[0].phone}: الاسم'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Expanded(
                      child: Text("الرقم الوطني:"),
                    ),
                    Expanded(child: Text('${state.result[0].nationalId}')),
                  ],
                ),
              ),
              actions: [
                MaterialButton(
                    onPressed: () {
                      Get.back();
                      Get.off(() => addInfoDevice(
                            customerNationalId: state.result[0].nationalId,
                          ));
                    },
                    color: const Color.fromARGB(255, 200, 188, 202),
                    elevation: 10.10,
                    child: const Text("اضف معلومات الجهاز")),
                MaterialButton(
                    onPressed: () {
                      BlocProvider.of<AddDevicesCubit>(Get.context!).resetState();
                      Get.back();
                    },
                    color: const Color.fromARGB(255, 200, 188, 202),
                    elevation: 10.10,
                    child: const Text("الغاء"))
              ]));
        });
      }
      if (state is AddDevicesFailure) {
        if (state.errormessage == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // This will ensure that the current frame is complete before executing the navigation
            Get.off(() => addInfoDevice(
                  customerNationalId: nationalId.text,
                ));
          });
        }
      }

      if (state is AddDevicesInitial) {
        return AlertDialog(
            title: Text(title),
            content: SizedBox(
                height: 150,
                child: Form(
                    key: myform,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: nationalId,
                        decoration: const InputDecoration(
                          labelText: 'الرقم الوطني لصاحب الجهاز',
                          labelStyle:
                              TextStyle(fontSize: 17, color: Colors.black),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                          focusColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'ادخل الرقم الوطني لصاحب الجهاز';
                          } else if (value.length != 11) {
                            return 'يجب أن يكون 11 رقم';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      Container(
                        height: 20,
                      ),
                    ])))),
            actions: [
              MaterialButton(
                  onPressed: () {
                    Get.back();
                  },
                  color: const Color.fromARGB(255, 200, 188, 202),
                  elevation: 10.10,
                  child: const Text("الغاء")),
              MaterialButton(
                  onPressed: () {
                    if (myform.currentState!.validate()) {
                      BlocProvider.of<AddDevicesCubit>(context)
                          .checkNationalId(nationalId: nationalId.text);
                    }
                  },
                  color: const Color.fromARGB(255, 200, 188, 202),
                  elevation: 10.10,
                  child: const Text("بحث"))
            ]);
      }
      return Container();
    });
  }
}
