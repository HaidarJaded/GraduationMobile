import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/device_model.dart';

class DeliverDeviceForm extends StatefulWidget {
  final Device device;
  const DeliverDeviceForm({super.key, required this.device});

  @override
  State<DeliverDeviceForm> createState() => _DeliverDeviceFormState();
}

class _DeliverDeviceFormState extends State<DeliverDeviceForm> {
  String? deviceStatus;
  TextEditingController costToCustomerController = TextEditingController();
  TextEditingController problemController = TextEditingController();
  DateTime? customerDateWarranty;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> devicesStatus = [
    'جاهز',
    'غير جاهز',
    "لا يصلح",
  ];
  @override
  void initState() {
    super.initState();
    customerDateWarranty = widget.device.customerDateWarranty;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> contentList = [
      if (widget.device.repairedInCenter == 0) ...[
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            labelText: 'العطل',
            prefixIcon: const Icon(Icons.report_problem),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          controller: problemController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال العطل';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 20,
        ),
        DropdownButton<String>(
            hint: const Text('حالة الجهاز'),
            value: deviceStatus,
            onChanged: (String? newStatus) {
              setState(() {
                deviceStatus = newStatus;
              });
            },
            items: devicesStatus.map((String deviceState) {
              return DropdownMenuItem<String>(
                value: deviceState,
                child: Text(deviceState),
              );
            }).toList()),
        const SizedBox(
          height: 20,
        ),
      ],
      if (deviceStatus == 'جاهز' || widget.device.status == 'جاهز')
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            labelText: 'التكلفة على الزبون',
            prefixIcon: const Icon(Icons.attach_money),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          controller: costToCustomerController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال التكلفة على الزبون';
            }
            return null;
          },
        ),
      const SizedBox(
        height: 20,
      ),
      Card(
        color: const Color.fromARGB(255, 252, 234, 251),
        child: ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text("تاريخ انتهاء الكفالة"),
          subtitle: Text(
            customerDateWarranty != null
                ? customerDateWarranty!.toIso8601String()
                : "لم يتم التحديد",
          ),
          trailing: IconButton(
            onPressed: () async {
              DateTime? newCustomerDateWarranty =
                  await showDateTimePicker(context: context);
              setState(() {
                customerDateWarranty = newCustomerDateWarranty;
              });
            },
            icon: const Icon(Icons.edit),
          ),
        ),
      ),
    ];
    return AlertDialog(
      title: const Text('تسليم حهاز'),
      content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: contentList,
            ),
          )),
      actions: [
        TextButton(
          onPressed: () async {
            if (!(formKey.currentState?.validate() ?? false)) {
              return;
            }
            if (deviceStatus == null && widget.device.repairedInCenter == 0) {
              SnackBarAlert().alert('الرجاء تحديد حالة الجهاز');
              return;
            }
            if (customerDateWarranty == null&&widget.device.status=='جاهز') {
              SnackBarAlert().alert('الرجاء تحديد الكفالة');
              return;
            }
            Device device = widget.device;
            Map<String, dynamic> body = {
              'deliver_to_customer': 1,
              'customer_date_warranty': customerDateWarranty?.toIso8601String(),
              'cost_to_customer': costToCustomerController.text,
            };
            if (widget.device.repairedInCenter == 0) {
              body.addAll({
                'problem': problemController.text,
                'status': deviceStatus,
              });
            }
            var response =
                await Api().put(path: 'api/devices/${device.id}', body: body);
            if (response == null) {
              Navigator.pop(Get.context!, false);
              return;
            }
            Navigator.pop(Get.context!, true);
          },
          child: const Text('تسليم'),
        ),
        TextButton(
          onPressed: () async {
            Get.back(result: false);
          },
          child: const Text('الغاء'),
        ),
      ],
    );
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
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
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
