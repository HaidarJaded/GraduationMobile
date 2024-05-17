import 'dart:convert';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';

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
      List<dynamic> payload = json.decode(payloadString!);
      var actionTitle = receivedAction.buttonKeyPressed == 'yes' ? 'نعم' : 'لا';
      var selectedPayload =
          payload.where((e) => e['title'] == actionTitle).toList().first;
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
    String title, String body, String actions) async {
  List<dynamic> buttons = jsonDecode(actions);
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
      id: 10,
      channelKey: 'basic_channel',
      title: title,
      body: body,
      notificationLayout: NotificationLayout.BigText,
      color: const Color.fromRGBO(255, 255, 255, 1),
      payload: {'payload': actions},
      wakeUpScreen: true,
      autoDismissible: false,
    ),
    actionButtons: actionButtons,
  );
}
}
