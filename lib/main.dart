import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/Controllers/notification_controller.dart';
import 'package:graduation_mobile/allDevices/cubit/swich/SwitchEvent.dart';
import 'package:graduation_mobile/allDevices/screen/allDevices.dart';
import 'package:graduation_mobile/allDevices/screen/cubit/edit_cubit.dart';
import 'package:graduation_mobile/firebase_options.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/login/loginScreen/loginPage.dart';
import 'Controllers/auth_controller.dart';
import 'allDevices/cubit/all_devices_cubit.dart';
import 'allDevices/screen/cubit/add_devices_cubit.dart';
import 'pages/client/phone_cubit/phone_cubit.dart';
import 'sign-UpPage.dart/sing-upCubit.dart';
import 'the_center/center.dart';
import 'the_center/cubit/the_center_cubit.dart';
import 'package:get/get.dart';

PageController pageController = PageController(initialPage: 0);
int currentIndex = 0;
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  var notificationInfo = jsonDecode(message.data['notification']);
  NotificationController().showLocalNotificationWithActions(
      notificationInfo?['title'] ?? "",
      notificationInfo?['body'] ?? "",
      message.data['actions']);
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  firebaseMessaging.requestPermission();

  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    var notificationInfo = jsonDecode(message.data['notification']);
    NotificationController().showLocalNotificationWithActions(
        notificationInfo?['title'] ?? "",
        notificationInfo?['body'] ?? "",
        message.data['actions']);
  });

  firebaseMessaging.requestPermission();

  AwesomeNotifications().initialize(
    'resource://drawable/sss', // Replace with your app icon
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        criticalAlerts: true,
      ),
    ],
  );
  await AwesomeNotifications().requestPermissionToSendNotifications();

  AwesomeNotifications().setListeners(
    onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    onNotificationCreatedMethod:
        NotificationController.onNotificationCreatedMethod,
    onNotificationDisplayedMethod:
        NotificationController.onNotificationDisplayedMethod,
    onDismissActionReceivedMethod:
        NotificationController.onDismissActionReceivedMethod,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<void> checkLoginStatus() async {
    String? token = await InstanceSharedPrefrences().getToken();
    if (token == null ||
        !await BlocProvider.of<loginCubit>(Get.context!).refreshToken()) {
      return;
    }
    BlocProvider.of<AllDevicesCubit>(Get.context!).getDeviceData();
    Get.off(() => const allDevices());
  }

  @override
  Widget build(BuildContext context) {
    checkLoginStatus();
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => loginCubit()),
          BlocProvider(
            create: (context) => AllDevicesCubit(),
          ),
          BlocProvider(
            create: (context) => TheCenterCubit(),
            child: const center(),
          ),
          BlocProvider(
            create: (context) => AddDevicesCubit(),
          ),
          BlocProvider(
            create: (context) => PhoneCubit(),
          ),
          BlocProvider(
            create: (context) => RegistrationCubit(),
          ),
          BlocProvider(
            create: (context) => SwitchBloc(),
          ),
          BlocProvider(
            create: (context) => EditCubit(),
          ),
        ],
        child: GetMaterialApp(
            debugShowCheckedModeBanner: false, home: LoginPage()));
  }
}
