import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/allDevices/screen/allDevices.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/models/customer_model.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/pages/client/Home_Page.dart';
import 'package:graduation_mobile/pages/client/customer_info_card.dart';

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
      Text('معلومات اضافية: ${device.info ?? 'لا يوجد'}'),
      Text('العطل: ${device.problem ?? 'لم يحدد بعد'}'),
      Text('شكوى الزبون: ${device.customerComplaint}'),
      FutureBuilder(
          future: InstanceSharedPrefrences().getRuleName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == 'عميل') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'اسم الزبون: ${device.customer?.name ?? ''} ${device.customer?.lastName ?? ''}'),
                    TextButton(
                        onPressed: () {
                          if (device.customer == null) {
                            return;
                          }
                          _showCustomerDetailsDialog(device.customer!);
                        },
                        child: const Text('عرض بيانات الزبون')),
                    if (device.repairedInCenter == 1)
                      Text(
                          'التكلفة عليك: ${device.costToClient ?? 'لم تحدد بعد'}'),
                    Text(
                        'التكلفة على الزبون: ${device.costToCustomer ?? 'لم تحدد بعد'}')
                  ],
                );
              }
              return const SizedBox();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      if (device.status == 'جاهز') ...[
        const Text('خطوات الاصلاح:'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: device.fixSteps == null
              ? [const Text('     لم تحدد')]
              : device.fixSteps!
                  .split('\n')
                  .map((step) => Text('         - $step'))
                  .toList(),
        )
      ],
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
        onPressed: () async {
          String? ruleName = await InstanceSharedPrefrences().getRuleName();
          if (ruleName == 'عميل') {
            Get.off(() => const allDevices());
          } else if (ruleName == 'فني') {
            Get.off(() => const HomePages());
          }
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

void _showCustomerDetailsDialog(Customer customer) {
  showDialog(
    context: Get.context!,
    builder: (context) {
      return SizedBox(
        width: 100,
        height: 50,
        child: CustomerInfoCard(customer: customer),
      );
    },
  );
}
