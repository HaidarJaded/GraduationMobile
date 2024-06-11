import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/models/device_model.dart';

class DeviceInfoCard extends StatelessWidget {
  final Device device;
  final dynamic messageInfo;
  const DeviceInfoCard({super.key, required this.device, this.messageInfo});

  @override
  Widget build(BuildContext context) {
    List<Widget> contentList = <Widget>[
      Text('IMEI: ${device.imei}'),
      Text('Code: ${device.code}'),
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
    if (messageInfo != null) {
      contentList.add(const Divider());
      contentList.add(Text(
        'الرسالة:${messageInfo['message']}',
      ));
      List<dynamic> buttons = messageInfo['actions'];
      List<Row> actionButtons = buttons.map((action) {
        return Row(
          children: [
            FloatingActionButton(
                onPressed: () async {
                  String url = action['url'];
                  var requestBody = action['request_body'];
                  var requestMethod = action['method'];
                  if (requestMethod == 'POST') {
                    await Api().post(path: url, body: requestBody);
                  } else if (requestMethod == 'PUT') {
                    await Api().put(path: url, body: requestBody);
                  }
                  Get.back();
                },
                child: Text(action['title'])),
            const SizedBox(
              width: 8,
            )
          ],
        );
      }).toList();
      contentList.add(Row(
        children: [...actionButtons],
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
