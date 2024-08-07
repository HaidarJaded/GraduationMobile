// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, unnecessary_import, prefer_adjacent_string_concatenation, unnecessary_string_interpolations, unnecessary_type_check

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/device_model.dart';

import 'cubit/edit_cubit.dart';

class EditDevice extends StatefulWidget {
  const EditDevice({super.key, required this.device});
  final Device device;
  @override
  State<EditDevice> createState() => _EditDeviceState();
}

class _EditDeviceState extends State<EditDevice> {
  GlobalKey<FormState> myform = GlobalKey<FormState>();
  late TextEditingController costTOCustomer;
  late TextEditingController modelController;
  late TextEditingController ImeiController;
  late TextEditingController infoController;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    costTOCustomer =
        TextEditingController(text: widget.device.costToCustomer.toString());
    modelController = TextEditingController(text: widget.device.model);
    ImeiController = TextEditingController(text: widget.device.imei);
    infoController = TextEditingController(text: widget.device.info);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : AlertDialog(
            title: const Padding(
                padding: EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                      // Dropdown for selecting the category
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        'عدل بيانات الجهاز ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ]))),
            content: Form(
              key: myform,
              child: SingleChildScrollView(
                child: Column(children: [
                  const Align(
                    alignment: Alignment.topRight,
                    child: Text("نوع الجهاز"),
                  ),
                  TextFormField(
                    controller: modelController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.abc),
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
                      decoration: const InputDecoration(
                        icon: Icon(Icons.abc),
                      ),
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            value.length != 15) {
                          return 'يجب ان يكون 15 رقم';
                        }
                        return null;
                      }),
                  const Align(
                      alignment: Alignment.topRight,
                      child: Text("معلومات اضافية عن الجهاز")),
                  TextFormField(
                    controller: infoController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.abc),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () async {
                      if (myform.currentState?.validate() ?? false) {
                        if (widget.device.id == null) {
                          return;
                        }
                        setState(() {
                          isLoading = true;
                        });
                        bool isUpdated =
                            await BlocProvider.of<EditCubit>(context)
                                .editDevice(
                          model: modelController.text,
                          imei: ImeiController.text,
                          info: infoController.text,
                          id: widget.device.id!,
                        );
                        if (isUpdated) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            SnackBarAlert().alert("تمت العملية",
                                color: const Color.fromRGBO(0, 200, 0, 1),
                                title: "تم تحديث البيانات بنجاح");
                            setState(() {
                              widget.device.model = modelController.text;
                              widget.device.imei = ImeiController.text;
                              widget.device.info = infoController.text;
                            });
                            Navigator.pop(context);
                          });
                        }
                        SnackBarAlert().alert(
                            'عذراً حدث خطأ ما يرجى إعادة المحاولة لاحقاً');
                        Get.back();
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
              ),
            ));
  }
}
