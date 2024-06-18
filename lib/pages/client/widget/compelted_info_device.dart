// ignore_for_file: file_names, camel_case_types

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/drawerScreen/oldPhone/oldPhone.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/models/completed_device_model.dart';

class completedDeviceInfoUserCard extends StatelessWidget {
  final CompletedDevice completedDevice;
  final dynamic messageInfo;
  final bool? fromNotification;
  const completedDeviceInfoUserCard(
      {super.key,
      required this.completedDevice,
      this.messageInfo,
      this.fromNotification});

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
        children: completedDevice.fixSteps!
            .split('\n')
            .map((step) => Text('         - $step'))
            .toList(),
      ),
      Text('حالة الجهاز: ${completedDevice.status}'),
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
                    Get.offAll(() => const oldPhone());
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
          Get.off(() => const oldPhone());
        },
        child: const Text('العودة للصفحة الرئيسية'),
      ));
    }
    return AlertDialog(
      title: Text(completedDevice.model),
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: ListBody(children: contentList),
      ),
    );
  }
}
