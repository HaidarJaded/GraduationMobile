// ignore_for_file: unnecessary_import, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/pages/client/cubit/detalis_cubit/detalis_cubit.dart';
import 'package:graduation_mobile/pages/client/cubit/detalis_cubit/detalis_state.dart';

class AddDetalis extends StatefulWidget {
  const AddDetalis({super.key});

  @override
  State<AddDetalis> createState() => _AddDetalisState();
}

class _AddDetalisState extends State<AddDetalis> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? deviceId = 1;
  late DeviceDetailsCubit _deviceDetailsCubit;
  @override
  void initState() {
    super.initState();
    // Replace 1 with the actual device ID you want to fetch details for
    _deviceDetailsCubit = BlocProvider.of<DeviceDetailsCubit>(context);
    _deviceDetailsCubit.fetchDeviceDetails(deviceId!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<DeviceDetailsCubit, DeviceDetailsState>(
          builder: (context, state) {
        if (state is DeviceDetalisLoading) {
          print('loading add');
          return Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()));
        }
        if (state is DeviceDetalisSuccesses) {
          print('successes');
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
                    // Dropdown for selecting the category
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      'اضافة التفاصيل',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: const Icon(Icons.emoji_symbols_sharp),
                        title: const Text("رقم الجهاز"),
                        subtitle: Text(device.id.toString()),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: const Icon(Icons.settings_outlined),
                        title: const Text("النوع"),
                        subtitle: Text(device.model),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: const Icon(Icons.date_range),
                        title: const Text("تاريخ الاستلام"),
                        subtitle: Text(device.dateReceipt.toIso8601String()),
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'المشاكل',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      color: Colors.white,
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
                                });
                              });
                            },
                            icon: const Icon(Icons.edit)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: const Icon(Icons.info_rounded),
                        title: const Text("المعلومات"),
                        subtitle: Text(device.info ?? ""),
                        trailing: IconButton(
                            onPressed: () {
                              _showEditDialog("معلومات", device.info ?? "",
                                  (newValue) {
                                setState(() {
                                  device.info = newValue;
                                });
                              });
                            },
                            icon: const Icon(Icons.edit)),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () async {},
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
                            'حفظ',
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
          );
        } else {
          return const Center(child: Text("Unexpected state"));
        }
      }),
    );
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
