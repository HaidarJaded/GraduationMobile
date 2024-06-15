// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/pages/client/cubit/status_cubit/status_cubit.dart';
import 'package:graduation_mobile/pages/client/cubit/status_cubit/status_state.dart';
import 'package:graduation_mobile/pages/client/step.dart';

class UpdateStatus extends StatefulWidget {
  UpdateStatus({super.key, this.device, this.status});
  Device? device;
  String? status;
  @override
  State<UpdateStatus> createState() => _UpdateStatusState();
}

class _UpdateStatusState extends State<UpdateStatus> {
  String? state;
  DateTime? _datecontroller;

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
            // ignore: avoid_print
            print('جااااااااااااهز');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RepairSteps(
                  device: widget.device!,
                  state: this.state!,
                  clientDateWarranty: _datecontroller!,
                ),
              ),
            );
          } else if (state is UpdateStatusError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          print(state);
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
                  onTap: () {
                    if (this.state != null) {
                      // تأكد من تمرير القيمة الصحيحة للمعامل id هنا
                      context.read<UpdateStatusCubit>().updateStatus(
                            widget.device!.id
                                as int, // بافتراض أن `widget.device` غير null ولديها خاصية `id`
                            this.state!,
                            _datecontroller?.toIso8601String(),
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // القيمة الافتراضية للتاريخ الحالي
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _datecontroller) {
      setState(() {
        _datecontroller = picked;
      });
    }
  }
}
