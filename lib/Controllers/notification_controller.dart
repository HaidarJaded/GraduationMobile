import 'dart:convert';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/Delivery_man/screen/Delivery_man.dart';
import 'package:graduation_mobile/allDevices/screen/device_info_card.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/order/orders_page.dart';

class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here\
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    try {
      var payloadString = receivedAction.payload!['payload'];
      Map<String, dynamic> payload = json.decode(payloadString!);
      List actions = json.decode(payload['actions']);
      if (receivedAction.buttonKeyPressed.isEmpty) {
        if (payload.containsKey('order_id')) {
          int orderId = int.parse(payload['order_id']);
          String? ruleName = await InstanceSharedPrefrences().getRuleName();
          if (ruleName == 'عميل') {
            Get.offAll(() => ordersPage(
                  orderId: orderId,
                ));
          } else if (ruleName == 'عامل توصيل') {
            Get.offAll(() => Delivery_man(
                  orderId: orderId,
                ));
          }
        } else if (payload.containsKey('device_id')) {
          Device? device = await CrudController<Device>()
              .getById(int.parse(payload['device_id']), {});
          if (device == null) {
            return;
          }
          var messageInfo = {
            'actions': actions,
            'message': receivedAction.body
          };
          Get.offAll(() => DeviceInfoCard(
                device: device,
                messageInfo: messageInfo,
                fromNotification: true,
              ));
        }
        return;
      }
      var actionTitle = receivedAction.buttonKeyPressed == 'yes' ? 'نعم' : 'لا';
      var selectedPayload =
          actions.where((e) => e['title'] == actionTitle).toList().first;
      String url = selectedPayload['url'];
      var requestBody = selectedPayload['request_body'];
      var requestMethod = selectedPayload['method'];

      if (requestMethod == 'POST') {
        await Api().post(path: url, body: requestBody);
      } else if (requestMethod == 'PUT') {
        await Api().put(path: url, body: requestBody);
      }
    } catch (e) {
      SnackBarAlert().alert(e.toString());
    }
  }

  void showLocalNotificationWithActions(
      Map<String, dynamic> messageData) async {
    List<dynamic> buttons = jsonDecode(messageData['actions']);
    var notificationInfo = jsonDecode(messageData['notification']);
    String title = notificationInfo['title'] ?? '';
    String body = notificationInfo['body'] ?? '';
    List<NotificationActionButton> actionButtons = buttons.map((action) {
      return NotificationActionButton(
          key: action['title'] == 'نعم' ? 'yes' : 'no',
          label: action['title'],
          color: const Color.fromRGBO(255, 255, 255, 1),
          actionType: ActionType.SilentAction,
          autoDismissible: true);
    }).toList();
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(100),
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
        color: const Color.fromRGBO(255, 255, 255, 1),
        payload: {'payload': json.encode(messageData)},
        wakeUpScreen: true,
        autoDismissible: true,
      ),
      actionButtons: actionButtons,
    );
  }
}
