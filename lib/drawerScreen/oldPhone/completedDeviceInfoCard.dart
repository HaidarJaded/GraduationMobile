// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_mobile/models/completed_device_model.dart';

class completedDeviceInfoCard extends StatelessWidget {
  final CompletedDevice completedDevice;
  const completedDeviceInfoCard({
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
      Text('اسم الزبون: ${completedDevice.customer?.name ?? ''}'),
      Text('معلومات اضافية: ${completedDevice.info}'),
      Text('العطل: ${completedDevice.problem}'),
      Text('التكلفة عليك: ${completedDevice.costToClient}'),
      Text('التكلفة على الزبون: ${completedDevice.costToCustomer}'),
      const Text('خطوات الاصلاح:'),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: completedDevice.fixSteps == null
            ? [const Text('     لم تحدد بعد')]
            : completedDevice.fixSteps!
                .split('\n')
                .map((step) => Text('         - $step'))
                .toList(),
      ),
      Text('حالة الجهاز: ${completedDevice.status}'),
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
}
