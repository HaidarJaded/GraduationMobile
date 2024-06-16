import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:graduation_mobile/models/device_model.dart';

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
      Text('اسم العميل: ${device.client?.name ?? ''}'),
      const SizedBox(
        height: 5,
      ),
      Text('معلومات اضافية: ${device.info}'),
      const SizedBox(
        height: 5,
      ),
      Text('العطل: ${device.problem ?? 'لم يحدد بعد'}'),
      const SizedBox(
        height: 5,
      ),
      Text('التكلفة على العميل: ${device.costToClient ?? 'لم تحدد بعد'}'),
      const SizedBox(
        height: 5,
      ),
      const Text('خطوات الاصلاح:'),
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
        padding: const EdgeInsets.all(8),
        child: ListBody(children: contentList),
      ),
    );
  }
}
