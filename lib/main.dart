import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'Controllers/auth_controller.dart';
import 'allDevices/cubit/all_devices_cubit.dart';
import 'allDevices/screen/cubit/add_devices_cubit.dart';
import 'login/loginScreen/loginPage.dart';
import 'pages/client/phone_cubit/phone_cubit.dart';
import 'the_center/center.dart';
import 'the_center/cubit/the_center_cubit.dart';

PageController pageController = PageController(initialPage: 0);
int currentIndex = 0;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<bool> checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
        ],
        child:
            MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage()));
  }
}
