// ignore_for_file: unnecessary_import, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/device_model.dart';
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
  DateTime? _expectedDateOfDelivery;
  bool _isNotRepairable = false;

  @override
  void initState() {
    super.initState();
    _deviceDetailsCubit = BlocProvider.of<DeviceDetailsCubit>(context);
    _costController = TextEditingController(
        text: widget.device.costToClient?.toString() ?? '');
    _problemController =
        TextEditingController(text: widget.device.problem ?? '');
    _expectedDateOfDelivery = widget.device.expectedDateOfDelivery;
  }

  @override
  void dispose() {
    _costController.dispose();
    _problemController.dispose();
    _deviceDetailsCubit.dispose();
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
          }
          if (state is DeviceDetalisInitial) {
            final device = widget.device;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 22),
                      SwitchListTile(
                        title: const Text("الجهاز لا يصلح"),
                        value: _isNotRepairable,
                        onChanged: (bool value) {
                          setState(() {
                            _isNotRepairable = value;
                            if (_isNotRepairable) {
                              _costController.clear();
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 22),
                      TextFormField(
                        controller: _costController,
                        validator: (value) {
                          if (!_isNotRepairable) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال التكلفة';
                            }
                            return null;
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          labelText: 'التكلفة',
                          prefixIcon: const Icon(Icons.price_change_outlined),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        enabled:
                            !_isNotRepairable, // تعطيل الحقل إذا كان الجهاز "لا يصلح"
                      ),
                      const SizedBox(height: 26),
                      TextFormField(
                        controller: _problemController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال المشكلة';
                          }
                          if (value.length > 50) {
                            return 'يجب أن تكون أقل من 50 محرف';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: 'المشكلة',
                          prefixIcon: const Icon(Icons.report_problem_outlined),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        color: const Color.fromARGB(255, 252, 234, 251),
                        child: ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: const Text("التاريخ المتوقع للتسليم"),
                          subtitle: Text(
                            _isNotRepairable || _expectedDateOfDelivery == null
                                ? "لا يمكن تحديد التاريخ"
                                : _expectedDateOfDelivery!.toIso8601String(),
                          ),
                          trailing: IconButton(
                            onPressed: _isNotRepairable
                                ? null
                                : () {
                                    _selectDate(context);
                                  },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          DateTime? expectedDate;
                          if (!_isNotRepairable) {
                            try {
                              expectedDate = _expectedDateOfDelivery!;
                            } catch (e) {
                              SnackBarAlert()
                                  .alert('يرجى تحديد التاريخ المتوقع للتسليم');
                              return;
                            }
                          }

                          double? parsedCost;
                          if (!_isNotRepairable) {
                            try {
                              parsedCost = double.parse(_costController.text);
                            } catch (e) {
                              SnackBarAlert()
                                  .alert('يرجى إدخال التكلفة بشكل صحيح');
                              return;
                            }
                          }

                          bool editSuccess =
                              await _deviceDetailsCubit.EditDetalis(
                            id: device.id!,
                            costToClient: _isNotRepairable ? null : parsedCost,
                            problem: _problemController.text,
                            expectedDateOfDelivery:
                                _isNotRepairable ? null : expectedDate,
                            isNotRepairable: _isNotRepairable,
                          );
                          if (!editSuccess) {
                            SnackBarAlert().alert(
                                'حدثت مشكلة أثناء تحديث البيانات، يرجى إعادة المحاولة');
                            Navigator.pop(Get.context!);
                            return;
                          }
                          SnackBarAlert().alert(
                              "تم إرسال إشعار للعميل، انتظر الاستجابة رجاءً",
                              color: const Color.fromARGB(255, 4, 83, 173),
                              title: "إشعار العميل");
                          Navigator.pop(Get.context!);
                          Navigator.pop(Get.context!);
                          setState(() {
                            if (_isNotRepairable) {
                              device.status = 'لا يصلح';
                            } else {
                              device.costToClient = parsedCost;
                              device.problem = _problemController.text;
                              device.status = 'بانتظار استجابة العميل';
                            }
                          });
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
                              'حفظ وإعلام العميل',
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
    final DateTime? picked = await showDateTimePicker(context: context);

    if (picked != null && picked != _expectedDateOfDelivery) {
      setState(() {
        _expectedDateOfDelivery = picked;
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
