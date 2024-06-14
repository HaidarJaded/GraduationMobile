import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/allDevices/screen/allDevices.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/models/device_model.dart';

class DeviceInfoCard extends StatelessWidget {
  final Device device;
  final dynamic messageInfo;
  final bool? fromNotification;
  const DeviceInfoCard(
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
      Text('اسم الزبون: ${device.customer?.name ?? ''}'),
      Text('معلومات اضافية: ${device.info}'),
      Text('العطل: ${device.problem ?? 'لم يحدد بعد'}'),
      Text('التكلفة عليك: ${device.costToClient ?? 'لم تحدد بعد'}'),
      Text('التكلفة على الزبون: ${device.costToCustomer ?? 'لم تحدد بعد'}'),
      const Text('خطوات الاصلاح:'),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: device.fixSteps == null
            ? [const Text('     لم تحدد بعد')]
            : device.fixSteps!
                .split('\n')
                .map((step) => Text('         - $step'))
                .toList(),
      ),
      Text('حالة الجهاز: ${device.status}'),
    ];
    contentList.add(const Divider());
    if (messageInfo != null) {
      contentList.add(Text(
        'الرسالة:${messageInfo['message']}',
      ));
      List<dynamic> buttons = messageInfo['actions'];
      List<Row> actionButtons = buttons.map((action) {
        return Row(
          children: [
            FloatingActionButton(
                heroTag: Random().nextInt(100).toString(),
                onPressed: () async {
                  String url = action['url'];
                  var requestBody = action['request_body'];
                  var requestMethod = action['method'];
                  if (requestMethod == 'POST') {
                    Api().post(path: url, body: requestBody);
                  } else if (requestMethod == 'PUT') {
                    Api().put(path: url, body: requestBody);
                  }
                  if (fromNotification == true) {
                    Get.offAll(() => const allDevices());
                  } else {
                    Get.back();
                  }
                },
                child: Text(action['title'])),
            const SizedBox(
              width: 8,
            )
          ],
        );
      }).toList();
      contentList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [...actionButtons],
      ));
    }
    if (fromNotification == true) {
      contentList.add(const SizedBox(
        height: 8,
      ));
      contentList.add(FloatingActionButton(
        onPressed: () {
          Get.off(() => const allDevices());
        },
        child: const Text('العودة للصفحة الرئيسية'),
      ));
    }
    return AlertDialog(
      title: Text(device.model),
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: ListBody(children: contentList),
      ),
    );
  }
}
