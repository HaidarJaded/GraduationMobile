// ignore_for_file: must_be_immutable, file_names, camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/allDevices/screen/TextFormField.dart';
import 'package:graduation_mobile/allDevices/screen/allDevices.dart';

import '../cubit/all_devices_cubit.dart';
import 'cubit/add_devices_cubit.dart';

class addInfoDevice extends StatelessWidget {
  addInfoDevice({super.key});
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
  TextEditingController inCenterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddDevicesCubit, AddDevicesState>(
      builder: (context, state) {
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
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[أ-يa-zA-Z ]')),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            textFormField(
                              labelText: "Imei",
                              icon: const Icon(Icons.numbers),
                              controller: ImeiController,
                              validator: (value) {
                                if (value.length < 15) {
                                  return 'يجب ألا يكون الرقم أقل من 15 أرقام';
                                }
                              },
                            ),
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
                            InkWell(
                              onTap: () async {
                                if (myform.currentState?.validate() ?? false) {}
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
          return const Text("text");
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
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp('[أ-يa-zA-Z ]')),
                      ],
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
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp('[أ-يa-zA-Z ]')),
                      ],
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
                    textFormField(
                      labelText: "email",
                      icon: const Icon(Icons.email),
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'ادخل عنوان بريد إلكتروني صحيح';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    textFormField(
                      labelText: "رقم الهاتف",
                      icon: const Icon(Icons.phone),
                      controller: phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'ادخل رقم صاحب الجهاز';
                        } else if (value.length < 10) {
                          return 'يجب ألا يكون الرقم أقل من 10 أرقام';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    textFormField(
                      labelText: "الرقم الوطني",
                      icon: const Icon(Icons.person_add_alt_1_outlined),
                      controller: nationalIdController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'ادخل الرقم الوطني لصاحب الجهاز';
                        } else if (value.length < 11) {
                          return 'يجب ألا يكون الرقم أقل من 11 أرقام';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
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
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp('[أ-يa-zA-Z ]')),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    textFormField(
                      labelText: "Imei",
                      icon: const Icon(Icons.numbers),
                      controller: ImeiController,
                      validator: (value) {
                        if (value.length < 15) {
                          return 'يجب ألا يكون الرقم أقل من 15 أرقام';
                        }
                      },
                    ),
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
                    textFormField(
                        labelText: "الى السينتير",
                        icon: const Icon(Icons.home_filled),
                        controller: inCenterController),

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
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            BlocProvider.of<AllDevicesCubit>(context)
                                .getDeviceData();
                            // This will ensure that the current frame is complete before executing the navigation
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const allDevices()),
                              (route) => false,
                            );
                          });
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
    );
  }
}
