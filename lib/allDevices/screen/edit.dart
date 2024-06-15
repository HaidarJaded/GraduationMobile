// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, unnecessary_import, prefer_adjacent_string_concatenation, unnecessary_string_interpolations, unnecessary_type_check

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:graduation_mobile/allDevices/cubit/all_devices_cubit.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';

import 'allDevices.dart';
import 'cubit/edit_cubit.dart';

class edit extends StatelessWidget {
  edit({super.key});
  GlobalKey<FormState> myform = GlobalKey<FormState>();
  TextEditingController problem = TextEditingController();
  TextEditingController cost = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nationalIdController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController ImeiController = TextEditingController();
  TextEditingController infoController = TextEditingController();
  TextEditingController inCenterController = TextEditingController();
  bool inCenter = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCubit, EditState>(
      builder: (context, state) {
        if (state is EditFound) {
          return AlertDialog(
              title: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                      key: myform,
                      child: const SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                            // Dropdown for selecting the category
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'عدل بيانات الجهاز الجديد',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ])))),
              content: SingleChildScrollView(
                child: Column(children: [
                  const Align(
                    alignment: Alignment.topRight,
                    child: Text("نوع الجهاز"),
                  ),
                  TextFormField(
                    controller: modelController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.abc),
                      hintText: state.editDevicesDatat.model,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.topRight,
                    child: Text("imei"),
                  ),
                  TextFormField(
                      controller: ImeiController,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.abc),
                        hintText: state.editDevicesDatat.imei,
                      ),
                      validator: (value) {
                        if (value!.length != 15) {
                          return 'يجب ان يكون 15 رقم';
                        }
                        return null;
                      }),
                  const Align(
                      alignment: Alignment.topRight,
                      child: Text("معلومات اضافية عن الجهاز")),
                  TextFormField(
                    controller: infoController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.abc),
                      hintText: state.editDevicesDatat.info,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.topRight,
                    child: Text("العطل"),
                  ),
                  TextFormField(
                    controller: problem,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.abc),
                      hintText: state.editDevicesDatat.problem,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () async {
                      if (myform.currentState?.validate() ?? false) {
                        BlocProvider.of<EditCubit>(context).editDevice(
                          model: modelController.text,
                          imei: ImeiController.text,
                          info: infoController.text,
                          id: state.editDevicesDatat.id!,
                          problem: problem.text,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(colors: [
                          Color(0xFF3E7FF8),
                          Color(0xFF21468A),
                        ]),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ));
        }
        if (state is Editloading) {
          return Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()));
        }
        if (state is EditSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            SnackBarAlert().alert("updat successfuly",
                color: const Color.fromRGBO(0, 200, 0, 1),
                title: "Successfuly");
            Get.offAll(() => const allDevices());

            BlocProvider.of<AllDevicesCubit>(context).getDeviceData();
          });
        }

        if (state is EditFailur) {
          if (state.errMessage == "No data to update") {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              SnackBarAlert().alert("No data to update",
                  color: const Color.fromARGB(255, 200, 0, 0), title: "Error");
              BlocProvider.of<AllDevicesCubit>(context).getDeviceData();
              // This will ensure that the current frame is complete before executing the navigation
              Get.offAll(() => const allDevices());
            });
          }
        }
        return Container();
      },
    );
  }
}
