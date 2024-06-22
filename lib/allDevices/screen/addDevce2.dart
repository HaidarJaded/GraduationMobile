// ignore_for_file: must_be_immutable, file_names, camel_case_types, non_constant_identifier_names, empty_statements, deprecated_member_use, unnecessary_import, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:graduation_mobile/allDevices/screen/TextFormField.dart';
import 'package:graduation_mobile/allDevices/screen/allDevices.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/qr_scanner.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/user_model.dart';

import '../cubit/swich/SwitchEvent.dart';
import 'cubit/add_devices_cubit.dart';

class addInfoDevice extends StatelessWidget {
  addInfoDevice({
    super.key,
    required customerPhone,
  }) {
    phoneController = TextEditingController(text: customerPhone);
  }
  GlobalKey<FormState> myform = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nationalIdController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController ImeiController = TextEditingController();
  TextEditingController infoController = TextEditingController();
  TextEditingController inCenterController = TextEditingController(text: '0');

  Future<bool> areThereDelivery() async {
    var response = await Api().get(path: 'api/are_there_deliveries');
    if (response == null) {
      return false;
    }
    final body = response['body'];
    if (body.length == 0) {
      return false;
    }
    return true;
  }

  Future<bool> addingOrder(int deviceId) async {
    var clientId = await InstanceSharedPrefrences().getId();
    var response = await Api().post(path: 'api/orders', body: {
      'devices_ids': {deviceId.toString(): "تسليم للمركز"},
      'client_id': clientId,
      'description': 'ارسال طلب للمركز'
    });
    if (response != null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
      Get.offAll(() => const allDevices());
      BlocProvider.of<AddDevicesCubit>(context).resetState();

      return false;
    }, child: BlocBuilder<AddDevicesCubit, AddDevicesState>(
      builder: (context, state) {
        if (state is AddDevicesLoading) {
          return Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()));
        }
        if (state is AddDevicesFound) {
          return Scaffold(
              body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                      key: myform,
                      child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                            // Dropdown for selecting the category
                            const SizedBox(
                              height: 12,
                            ),
                            const Text(
                              'اضف بيانات الجهاز الجديد',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            textFormField(
                              labelText: "نوع الجهاز",
                              icon: const Icon(Icons.phone_android_rounded),
                              controller: modelController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "ادخل نوع الجهاز من فضلك";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Expanded(
                                  child: textFormField(
                                labelText: "Imei",
                                icon: const Icon(Icons.numbers),
                                controller: ImeiController,
                                validator: (value) {
                                  if (value.length != 15 && value.length != 0) {
                                    return 'يجب أن يكون 15 رقم';
                                  }
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              )),
                              IconButton(
                                icon: const Icon(Icons.qr_code_scanner),
                                onPressed: scanQR,
                              )
                            ]),
                            const SizedBox(
                              height: 10,
                            ),
                            textFormField(
                                labelText: "معلومات الجهاز",
                                icon: const Icon(Icons.playlist_add),
                                controller: infoController),
                            const SizedBox(
                              height: 30,
                            ),
                            BlocBuilder<SwitchBloc, SwitchState>(
                              builder: (context, state) {
                                return Row(
                                  children: [
                                    Switch(
                                      value: state.inCenter,
                                      onChanged: (val) {
                                        BlocProvider.of<SwitchBloc>(context)
                                            .add(ToggleSwitch(val));

                                        inCenterController.text =
                                            val ? '1' : '0';
                                      },
                                    ),
                                    Container(
                                      width: 60,
                                    ),
                                    const Text(
                                      "اضافة الى المركز",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                );
                              },
                            ),
                            InkWell(
                              onTap: () async {
                                if (myform.currentState?.validate() ?? false) {
                                  BlocProvider.of<AddDevicesCubit>(context)
                                      .addNewDevice(
                                          model: modelController.text,
                                          imei: ImeiController.text,
                                          info: infoController.text,
                                          repairedInCenter:
                                              inCenterController.text,
                                          cusomer_id: state.result[0].id!);

                                  ;
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
                                    'Save',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ])))));
        }
        if (state is AddDevicesSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            SnackBarAlert().alert("تم الاضافة بنجاح",
                color: const Color.fromRGBO(0, 200, 0, 1),
                title: "اضافة جهاز جديد");
            Get.off(() => const allDevices());
            BlocProvider.of<AddDevicesCubit>(context).resetState();
            if (state.isRepairedInCenter) {
              User.hasPermission("اضافة طلب لجهاز").then((hasPermission) {
                if (hasPermission) {
                  areThereDelivery().then((areThereDelivery) {
                    SnackBarAlert().alert("هل تود بارسال طلب؟",
                        title: "ارسال طلب لعامل توصيل",
                        color: const Color.fromARGB(255, 3, 75, 134),
                        yesButton: TextButton(
                          onPressed: () async {
                            Get.closeCurrentSnackbar();
                            if (state.deviceId != null) {
                              await addingOrder(state.deviceId!);
                            }
                          },
                          child: const Text(
                            "نعم",
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1)),
                            selectionColor: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                        duration: const Duration(seconds: 10));
                  });
                }
              });
            }
          });
        }
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: myform,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dropdown for selecting the category
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      'اضف بيانات الزبون',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    textFormField(
                      labelText: "الاسم",
                      icon: const Icon(Icons.abc_rounded),
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'ادخل اسم صاحب الجهاز';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    textFormField(
                      labelText: "الكنية",
                      icon: const Icon(Icons.abc_rounded),
                      controller: lastNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "ادخل الكنية من فضلك";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textDirection: TextDirection.ltr,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'البريد الالكتروني',
                        prefixIcon: const Icon(Icons.email),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    TextFormField(
                      enabled: false,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "رقم الهاتف",
                        prefixIcon: Icon(Icons.phone),
                      ),
                      controller: phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'ادخل رقم صاحب الجهاز';
                        } else if (value.length != 10) {
                          return 'يجب ان يكون 10 ارقام';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: nationalIdController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_add_alt_1_outlined),
                        labelText: "الرقم الوطني",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'اضف بيانات الجهاز الجديد',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    textFormField(
                      labelText: "نوع الجهاز",
                      icon: const Icon(Icons.phone_android_rounded),
                      controller: modelController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "ادخل نوع الجهاز من فضلك";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Row(children: [
                      Expanded(
                          child: textFormField(
                        labelText: "Imei",
                        icon: const Icon(Icons.numbers),
                        controller: ImeiController,
                        validator: (value) {
                          if (value.length != 0 && value.length != 15) {
                            return 'يجب أن يكون 15 رقم';
                          }
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      )),
                      IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: scanQR,
                      )
                    ]),

                    const SizedBox(
                      height: 10,
                    ),
                    textFormField(
                        labelText: "معلومات الجهاز",
                        icon: const Icon(Icons.playlist_add),
                        controller: infoController),
                    const SizedBox(
                      height: 30,
                    ),
                    BlocBuilder<SwitchBloc, SwitchState>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            Switch(
                              value: state.inCenter,
                              onChanged: (val) {
                                BlocProvider.of<SwitchBloc>(context)
                                    .add(ToggleSwitch(val));

                                inCenterController.text = val ? '1' : '0';
                              },
                            ),
                            Container(
                              width: 60,
                            ),
                            const Text(
                              "اضافة الى المركز",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        );
                      },
                    ),

                    InkWell(
                      onTap: () async {
                        if (myform.currentState?.validate() ?? false) {
                          BlocProvider.of<AddDevicesCubit>(context)
                              .addNewDevicewithNewCustomer(
                                  firstnameCustomer: nameController.text,
                                  lastnameCustomer: lastNameController.text,
                                  email: emailController.text,
                                  phone: phoneController.text,
                                  nationalId: nationalIdController.text,
                                  model: modelController.text,
                                  imei: ImeiController.text,
                                  info: infoController.text,
                                  repairedInCenter: inCenterController.text);

                          ;
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
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ));
  }

  void scanQR() async {
    String scanedImei = await QrScanner().scanQR();
    ImeiController.text = scanedImei;
  }
}
