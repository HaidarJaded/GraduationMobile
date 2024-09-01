// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/models/completed_device_model.dart';
import 'package:graduation_mobile/models/customer_model.dart';
import 'package:graduation_mobile/pages/client/customer_info_card.dart';
import 'package:intl/intl.dart';

class completedDeviceInfoUserCard extends StatelessWidget {
  final CompletedDevice completedDevice;
  const completedDeviceInfoUserCard({
    super.key,
    required this.completedDevice,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> contentList = <Widget>[
      Text('IMEI: ${completedDevice.imei}'),
      Row(
        children: [
          SelectableText('Code: ${completedDevice.code}'),
          IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: completedDevice.code));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم النسخ بنجاح'),
                    duration: Duration(milliseconds: 800),
                    backgroundColor: Color.fromRGBO(0, 0, 250, 1),
                  ),
                );
              },
              icon: const Icon(Icons.copy))
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              'اسم الزبون: ${completedDevice.customer?.name ?? ''} ${completedDevice.customer?.lastName ?? ''}'),
          TextButton(
              onPressed: () {
                if (completedDevice.customer == null) {
                  return;
                }
                _showCustomerDetailsDialog(completedDevice.customer!);
              },
              child: const Text('عرض بيانات الزبون'))
        ],
      ),
      Text('معلومات اضافية: ${completedDevice.info ?? 'لا يوجد'}'),
      Text('الشكوى: ${completedDevice.customerComplaint}'),
      Text('العطل: ${completedDevice.problem}'),
      Text('التكلفة على العميل: ${completedDevice.costToClient}'),
      if (completedDevice.repairedInCenter == 1) ...[
        const Text('خطوات الاصلاح:'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: completedDevice.fixSteps == null
              ? [const Text('     لم تحدد بعد')]
              : completedDevice.fixSteps!
                  .split('\n')
                  .map((step) => Text('         - $step'))
                  .toList(),
        )
      ],
      Text('حالة الجهاز: ${completedDevice.status}'),
      Text(
          'تاريخ الاستلام: ${DateFormat('yyyy/MM/dd hh:mm a').format(completedDevice.dateReceipt!)}'),
      if (completedDevice.dateDeliveryCustomer != null)
        Text(
            'تاريخ التسليم: ${DateFormat('yyyy/MM/dd hh:mm a').format(completedDevice.dateDeliveryClient!)}'),
      if (completedDevice.clientDateWarranty != null)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                'تاريخ انتهاء كفالة العميل: ${DateFormat('yyyy/MM/dd').format(completedDevice.customerDateWarranty!)}'),
            if (completedDevice.customerDateWarranty != null &&
                completedDevice.customerDateWarranty!.isBefore(DateTime.now()))
              const Text(
                'منتهية',
                style: TextStyle(color: Colors.red),
              )
          ],
        ),
    ];
    contentList.add(const Divider());

    return AlertDialog(
      title: Text(completedDevice.model),
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: ListBody(children: contentList),
      ),
    );
  }

  void _showCustomerDetailsDialog(Customer customer) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return SizedBox(
          width: 50,
          height: 50,
          child: CustomerInfoCard(customer: customer),
        );
      },
    );
  }
}
