import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/Controllers/notification_controller.dart';
import 'package:graduation_mobile/Delivery_man/cubit/delivery_man_cubit.dart';
import 'package:graduation_mobile/allDevices/cubit/swich/SwitchEvent.dart';
import 'package:graduation_mobile/allDevices/screen/allDevices.dart';
import 'package:graduation_mobile/allDevices/screen/cubit/edit_cubit.dart';
import 'package:graduation_mobile/drawerScreen/notification/cubit/notification_cubit.dart';
import 'package:graduation_mobile/drawerScreen/oldPhone/cubit/completed_device_cubit.dart';
import 'package:graduation_mobile/firebase_options.dart';
import 'package:graduation_mobile/helper/check_connection.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/models/device_model.dart';

import 'package:graduation_mobile/pages/client/Home_Page.dart';
import 'package:graduation_mobile/pages/client/cubit/detalis_cubit/detalis_cubit.dart';
import 'package:graduation_mobile/pages/client/cubit/status_cubit/status_cubit.dart';
import 'package:graduation_mobile/pages/client/cubit/step_cubit/step_cubit.dart';
import 'package:graduation_mobile/pages/client/disabled_account_page.dart';
import 'package:graduation_mobile/the_center/cubit/all_phone_in_center_cubit.dart';
import 'Controllers/auth_controller.dart';
import 'allDevices/cubit/all_devices_cubit.dart';
import 'allDevices/screen/cubit/add_devices_cubit.dart';

import 'login/loginScreen/loginPage.dart';
import 'pages/client/cubit/phone_cubit/phone_cubit.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/order/cubit/order_cubit.dart';

import 'sign-UpPage.dart/sing-upCubit.dart';

import 'the_center/cubit/the_center_cubit.dart';
import 'package:get/get.dart';
import 'package:connectivity/connectivity.dart';

PageController pageController = PageController(initialPage: 0);
int currentIndex = 0;
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  NotificationController().showLocalNotificationWithActions(message.data);
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  firebaseMessaging.requestPermission();

  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    NotificationController().showLocalNotificationWithActions(message.data);
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
  Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult result) async {
    if (CheckConnection.currentState != null &&
        CheckConnection.currentState == ConnectivityResult.none &&
        await CheckConnection().checkInternetConnection()) {
      SnackBarAlert().alert("عاد الاتصال بالانترنت",
          title: "تم استعادة الاتصال",
          color: const Color.fromRGBO(0, 200, 0, 1));
      await checkLoginStatus();
    }
  });
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

Future<void> checkLoginStatus() async {
  String? token = await InstanceSharedPrefrences().getToken();
  if (token == null ||
      !await BlocProvider.of<loginCubit>(Get.context!).refreshToken()) {
    return;
  }
  InstanceSharedPrefrences().getRuleName().then((ruleName) {
    if (ruleName == 'فني') {
      Get.off(() => const HomePages());
      SnackBarAlert().alert(
        "تم تسجيل الدخول بنجاح",
        color: const Color.fromRGBO(0, 200, 0, 1),
        title: "مرحباً بعودتك",
      );
    } else if (ruleName == 'عامل توصيل') {
      Get.off(() => const allDevices());
    } else if (ruleName == 'عميل') {
      InstanceSharedPrefrences().isAccountActive().then((isAccountActive) {
        if (isAccountActive) {
          SnackBarAlert().alert(
            "تم تسجيل الدخول بنجاح",
            color: const Color.fromRGBO(0, 200, 0, 1),
            title: "مرحباً بعودتك",
          );
          Get.off(() => const allDevices());
        } else {
          SnackBarAlert().alert(
            "حسابك غير نشط. الرجاء التواصل مع مدير المركز.",
            color: Colors.red,
            title: "حساب غير نشط",
          );
          Get.off(() => const DisabledAccountPage());
        }
      });
    } else {
      BlocProvider.of<loginCubit>(Get.context!).logout().then((value) {
        SnackBarAlert().alert(
          "لا يوجد صلاحية الدخول للتطبيق",
          color: const Color.fromRGBO(200, 200, 0, 1),
          title: "المعذرة",
        );
        Get.offAll(() => const LoginPage());
      });
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => loginCubit()),
          BlocProvider(
            create: (context) => AllDevicesCubit(),
          ),
          BlocProvider(
            create: (context) => AllDevicesCubit<Device>(),
          ),
          BlocProvider(
            create: (context) => TheCenterCubit(),
            child: const Center(),
          ),
          BlocProvider(
            create: (context) => AddDevicesCubit(),
          ),
          BlocProvider(
            create: (context) => PhoneCubit(),
          ),
          BlocProvider(
            create: (context) => DeviceDetailsCubit(CrudController()),
          ),
          BlocProvider(
            create: (context) => SwitchBloc(),
          ),
          BlocProvider(
            create: (context) => RegistrationCubit(),
          ),
          BlocProvider(
            create: (context) => EditCubit(),
          ),
          BlocProvider(
            create: (context) => OrderCubit(),
          ),
          BlocProvider(
            create: (context) => AllPhoneInCenterCubit(),
          ),
          BlocProvider(
            create: (context) => DeliveryManCubit(),
          ),
          BlocProvider(
            create: (context) => NotificationCubit(),
          ),
          BlocProvider(
            create: (context) => CompletedDeviceCubit(),
          ),
          BlocProvider(
            create: (context) => UpdateStatusCubit(CrudController()),
          ),
          BlocProvider(create: (context) => RepairStepsCubit()),
        ],
        child: const GetMaterialApp(
          textDirection: TextDirection.rtl,
          debugShowCheckedModeBanner: false,
          home: LoginPage(),
        ));
  }
}
