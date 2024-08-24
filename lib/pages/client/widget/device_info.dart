import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/models/client_model.dart';

import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/pages/client/client_info_card.dart';

class DeviceInfo extends StatelessWidget {
  final Device device;
  final dynamic messageInfo;
  final bool? fromNotification;
  const DeviceInfo(
      {super.key,
      required this.device,
      this.messageInfo,
      this.fromNotification});

  @override
  Widget build(BuildContext context) {
    List<Widget> contentList = <Widget>[
      Text('IMEI: ${device.imei}'),
      Row(
        children: [
          SelectableText('Code: ${device.code}'),
          IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: device.code));
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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'اسم العميل:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              ' ${device.client?.name ?? ''} ${device.client?.lastName ?? ''}'),
          TextButton(
              onPressed: () {
                if (device.client == null) {
                  return;
                }
                _showClinetDetailsDialog(device.client!);
              },
              child: const Text('عرض بيانات العميل'))
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      Row(
        children: [
          const Text(
            'معلومات اضافية:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('  ${device.info}'),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        'شكوى الزبون: ${device.customerComplaint}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      Row(
        children: [
          const Text(
            'العطل:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(device.problem ?? 'لم يحدد بعد'),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      Row(
        children: [
          const Text(
            'التكلفة على العميل:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('${device.costToClient ?? 'لم تحدد بعد'}'),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      const Text(
        'خطوات الاصلاح:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 3,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: device.fixSteps == null
            ? [const Text('     لم تحدد بعد')]
            : device.fixSteps!
                .split('\n')
                .map((step) => Text('         - $step'))
                .toList(),
      ),
      const SizedBox(
        height: 5,
      ),
      Text('حالة الجهاز: ${device.status}'),
    ];
    return AlertDialog(
      title: Text(device.model),
      content: SingleChildScrollView(
        child: ListBody(children: contentList),
      ),
    );
  }

  void _showClinetDetailsDialog(Client client) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return SizedBox(
          width: 50,
          height: 50,
          child: ClientInfoCard(client: client),
        );
      },
    );
  }
}
