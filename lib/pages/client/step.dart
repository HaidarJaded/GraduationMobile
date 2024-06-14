import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/device_model.dart';
import '../../Controllers/crud_controller.dart';
import '../../Controllers/notification_controller.dart';
import 'cubit/step_cubit/step_cubit.dart';

class RepairSteps extends StatefulWidget {
  RepairSteps(
      {super.key,
      required this.device,
      required this.state,
      required this.clientDateWarranty});

  final Device device;
  String state;
  DateTime clientDateWarranty;
  @override
  State<RepairSteps> createState() => _RepairSteps();
}

class _RepairSteps extends State<RepairSteps> {
  final TextEditingController _stepController = TextEditingController();
  int _currentStep = 0;

  void _addStep(BuildContext context) {
    context
        .read<RepairStepsCubit>()
        .addStep(_stepController.text, _currentStep);
    _stepController.clear();
    setState(() {
      _currentStep++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'خطوات التصليح',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text field for entering step description
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  controller: _stepController,
                  decoration: InputDecoration(
                    labelText: 'ادخل وصف الخطوة',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    icon: Icon(Icons.add),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _addStep(context),
                  child: const Text('اضف الخطوة'),
                ),
                const SizedBox(height: 12),
                BlocBuilder<RepairStepsCubit, List<Map<String, String>>>(
                  builder: (context, steps) {
                    return Column(
                      children: steps.map((step) {
                        return Card(
                          color: Colors.white,
                          child: ListTile(
                            leading: const Icon(FontAwesomeIcons.wrench),
                            title: Text(
                              step['title']!,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(step['description']!),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: InkWell(
          onTap: () {
            context.read<RepairStepsCubit>().saveStepsToDevice(widget.device);
            notifyClient(widget.device, _stepController.text, widget.state,
                widget.clientDateWarranty);
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
                'Send to customer',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void notifyClient(Device device, String fixStep, String status,
      DateTime clientDateWarranty) async {
    // هنا يتم إشعار العميل ب حالة الجهاز
    device.status = status;
    device.clientDateWarranty = clientDateWarranty;
    device.fixSteps = fixStep;

    // إرسال الإشعار

    // NotificationController().showLocalNotificationWithActions(
    //     "إشعار العميل",
    //     "تم ارسال اشعار للعميل انتظر الاستجابة رجاءاً",
    //     json.encode([
    //       {
    //         "title": "نعم",
    //         "url": "/api/device/confirm",
    //         "method": "POST",
    //         "request_body": {"id": device.id}
    //       },
    //       {
    //         "title": "لا",
    //         "url": "/api/device/reject",
    //         "method": "POST",
    //         "request_body": {"id": device.id}
    //       }
    //     ]));
    SnackBarAlert().alert("تم ارسال اشعار للعميل انتظر الاستجابة رجاءاً",
        color: const Color.fromARGB(255, 4, 83, 173), title: "اشعار العميل");
  }
}
