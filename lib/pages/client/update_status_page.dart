// ignore_for_file: file_names, must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/pages/client/Home_Page.dart';
import 'package:graduation_mobile/pages/client/cubit/status_cubit/status_cubit.dart';
import 'package:graduation_mobile/pages/client/cubit/status_cubit/status_state.dart';
import 'package:graduation_mobile/pages/client/step.dart';

class UpdateStatusPage extends StatefulWidget {
  const UpdateStatusPage({super.key, required this.device, this.status});
  final Device device;
  final String? status;

  @override
  State<UpdateStatusPage> createState() => _UpdateStatusState();
}

class _UpdateStatusState extends State<UpdateStatusPage> {
  String? state;
  DateTime? _datecontroller;
  @override
  void dispose() {
    super.dispose();
    BlocProvider.of<UpdateStatusCubit>(Get.context!).resetState();
  }

  void sendWithoutSteps(
      int id, String state, DateTime clientDateWarranty) async {
    try {
      Map<String, dynamic> body = {
        'status': 'جاهز',
        'client_date_warranty': clientDateWarranty.toIso8601String(),
      };
      var response = await Api().put(
        path: 'https://haidarjaded787.serv00.net/api/devices/$id',
        body: body,
      );
      if (response != null) {
        SnackBarAlert().alert("تم تحديث حالة الجهاز وإعلام العميل",
            color: const Color.fromARGB(255, 4, 83, 173),
            title: "تحديث حالة جهاز");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Center(
          child: Text(
            "تحديد حالة الجهاز",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: BlocConsumer<UpdateStatusCubit, UpdateStatusState>(
        listener: (context, state) {
          if (state is UpdateStatusReady) {
            showDialog(
              context: Get.context!,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('هل تريد اضافة خطوات التصليح؟'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('لا'),
                      onPressed: () {
                        sendWithoutSteps(widget.device.id as int, this.state!,
                            _datecontroller as DateTime);
                        Navigator.pop(context); // اغلاق الـ AlertDialog
                        Get.off(() => const HomePages());
                      },
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RepairSteps(
                              device: widget.device,
                              state: this.state!,
                              clientDateWarranty: _datecontroller!,
                            ),
                          ),
                        );
                      },
                      child: const Text('نعم'),
                    ),
                  ],
                );
              },
            );
          } else if (state is UpdateStatusError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'الحالات',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RadioListTile<String>(
                    activeColor: const Color(0xFF21468A),
                    title: const Text("جاهز"),
                    value: "جاهز",
                    groupValue:
                        state is UpdateStatusReady ? "جاهز" : this.state,
                    onChanged: (val) {
                      setState(() {
                        this.state = val;
                      });
                    }),
                const SizedBox(
                  height: 10,
                ),
                RadioListTile<String>(
                    activeColor: const Color(0xFF21468A),
                    title: const Text("غير جاهز"),
                    value: "غير جاهز",
                    groupValue: this.state,
                    onChanged: (val) {
                      setState(() {
                        this.state = val;
                      });
                    }),
                const SizedBox(
                  height: 10,
                ),
                RadioListTile<String>(
                    activeColor: const Color(0xFF21468A),
                    title: const Text("لا يصلح"),
                    value: "لا يصلح",
                    groupValue: this.state,
                    onChanged: (val) {
                      setState(() {
                        this.state = val;
                      });
                    }),
                const SizedBox(
                  height: 10,
                ),
                if (this.state == "جاهز") ...[
                  const Text(
                    'تاريخ انتهاء الكفالة',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    color: const Color.fromARGB(255, 252, 234, 251),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text("التاريخ انتهاء الكفالة"),
                      subtitle: Text(
                        _datecontroller != null
                            ? _datecontroller!.toIso8601String()
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
                ],
                const SizedBox(height: 75.0),
                InkWell(
                  onTap: () async {
                    if (this.state != null) {
                      context.read<UpdateStatusCubit>().updateStatus(
                            widget.device.id
                                as int, // بافتراض أن `widget.device` غير null ولديها خاصية `id`
                            this.state!,
                            _datecontroller?.toIso8601String(),
                          );
                      if (state is! UpdateStatusReady &&
                          state is! UpdateStatusError &&
                          state is! UpdateStatusInitial) {
                        Get.off(() => const HomePages());
                      }
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
                        'حفظ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDateTimePicker(context: context);

    if (picked != null && picked != _datecontroller) {
      setState(() {
        _datecontroller = picked;
      });
    }
  }

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= DateTime.now();
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }
}
