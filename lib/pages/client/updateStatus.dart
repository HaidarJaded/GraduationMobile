import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/Controllers/notification_controller.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/pages/client/cubit/status_cubit/status_cubit.dart';
import 'package:graduation_mobile/pages/client/step.dart';

class UpdateStatus extends StatefulWidget {
  const UpdateStatus({super.key});

  @override
  State<UpdateStatus> createState() => _UpdateStatusState();
}

class _UpdateStatusState extends State<UpdateStatus> {
  String? state;
  TextEditingController _datecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UpdateStatusCubit(NotificationController(), CrudController<Device>()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "تحديد حالة الجهاز",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: BlocConsumer<UpdateStatusCubit, UpdateStatusState>(
          listener: (context, state) {
            if (state is UpdateStatusReady) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RepairSteps(),
                ),
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
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.datetime,
                    controller: _datecontroller,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 75.0),
                  InkWell(
                    onTap: () {
                      if (this.state != null) {
                        context
                            .read<UpdateStatusCubit>()
                            .updateStatus(this.state!, _datecontroller.text);
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
      ),
    );
  }
}
