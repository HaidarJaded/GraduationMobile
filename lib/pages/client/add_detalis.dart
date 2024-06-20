// ignore_for_file: unnecessary_import, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/pages/client/Home_Page.dart';

import 'package:graduation_mobile/pages/client/cubit/detalis_cubit/detalis_cubit.dart';
import 'package:graduation_mobile/pages/client/cubit/detalis_cubit/detalis_state.dart';

class AddDetalis extends StatefulWidget {
  final Device device;

  const AddDetalis({super.key, required this.device});

  @override
  State<AddDetalis> createState() => _AddDetalisState();
}

class _AddDetalisState extends State<AddDetalis> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late DeviceDetailsCubit _deviceDetailsCubit;
  late TextEditingController _costController;
  late TextEditingController _problemController;
  late TextEditingController _infoController;
  DateTime? _expectedDateOfDelivery;

  @override
  void initState() {
    super.initState();
    _deviceDetailsCubit = BlocProvider.of<DeviceDetailsCubit>(context);
    _deviceDetailsCubit.fetchDeviceDetails(widget.device.id!);
    _costController = TextEditingController(
        text: widget.device.costToClient?.toString() ?? '');
    _problemController =
        TextEditingController(text: widget.device.problem ?? '');
    _expectedDateOfDelivery = widget.device.expectedDateOfDelivery;
    _infoController = TextEditingController(text: widget.device.info);
  }

  @override
  void dispose() {
    _costController.dispose();
    _problemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'اضافة التفاصيل',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocConsumer<DeviceDetailsCubit, DeviceDetailsState>(
        listener: (context, state) {
          if (state is DeviceDetalisFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errormess)),
            );
          }
        },
        builder: (context, state) {
          if (state is DeviceDetalisLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DeviceDetalisSuccesses) {
            final device = state.details.first;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      const SizedBox(height: 10),
                      Card(
                        color: const Color.fromARGB(255, 252, 234, 251),
                        child: ListTile(
                          leading: const Icon(Icons.price_change),
                          title: const Text("التكلفة"),
                          subtitle: Text(device.costToClient?.toString() ?? ""),
                          trailing: IconButton(
                            onPressed: () {
                              _showEditDialog("التكلفة",
                                  device.costToClient?.toString() ?? "",
                                  (costController) {
                                setState(() {
                                  device.costToClient =
                                      double.tryParse(costController);
                                  _costController.text =
                                      costController; // تحديث TextEditingController
                                });
                              });
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(height: 16),
                      Card(
                        color: const Color.fromARGB(255, 252, 234, 251),
                        child: ListTile(
                          leading: const Icon(Icons.report_problem),
                          title: const Text("المشكلة"),
                          subtitle: Text(device.problem ?? ""),
                          trailing: IconButton(
                            onPressed: () {
                              _showEditDialog("المشكلة", device.problem ?? "",
                                  (newValue) {
                                setState(() {
                                  device.problem = newValue;
                                  _problemController.text =
                                      newValue; // تحديث TextEditingController
                                });
                              });
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      ),
                      Card(
                        color: const Color.fromARGB(255, 252, 234, 251),
                        child: ListTile(
                          leading: const Icon(Icons.info),
                          title: const Text("المعلومات الاضافية"),
                          subtitle: Text(device.info ?? ""),
                          trailing: IconButton(
                            onPressed: () {
                              _showEditDialog(
                                  "المعلومات الاضافية", device.info ?? "",
                                  (newValue) {
                                setState(() {
                                  device.info = newValue;
                                  _infoController.text =
                                      newValue; // تحديث TextEditingController
                                });
                              });
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(height: 10),
                      Card(
                        color: const Color.fromARGB(255, 252, 234, 251),
                        child: ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: const Text("التاريخ المتوقع للتسليم"),
                          subtitle: Text(
                            _expectedDateOfDelivery != null
                                ? _expectedDateOfDelivery!.toIso8601String()
                                : "لم يتم التحديد",
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              _selectDate(context);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await _deviceDetailsCubit.EditDstalis(
                                id: device.id!,
                                costToClient:
                                    double.parse(_costController.text),
                                problem: _problemController.text,
                                expectedDateOfDelivery: _expectedDateOfDelivery,
                                info: _infoController.text);
                            Get.off(() => const HomePages());
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(colors: [
                              Color.fromARGB(255, 233, 139, 248),
                              Color.fromARGB(255, 96, 27, 152),
                            ]),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                            child: Text(
                              'ارسال',
                              style: TextStyle(
                                color: Color.fromARGB(255, 252, 234, 251),
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
            );
          } else {
            return const Center(child: Text("Unexpected state"));
          }
        },
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expectedDateOfDelivery ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _expectedDateOfDelivery) {
      setState(() {
        _expectedDateOfDelivery = picked;
      });
    }
  }

  void _showEditDialog(
      String title, String currentValue, Function(String) onSave) {
    final TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تعديل $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: ' ادخل $title الجديد',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('اغلاق'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('حفظ'),
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
