// ignore_for_file: file_names

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/Delivery_man/screen/Delivery_man.dart';
import 'package:graduation_mobile/helper/app_version_controller.dart';
import 'package:graduation_mobile/helper/check_connection.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/login/loginScreen/reset_password_page.dart';
import 'package:graduation_mobile/pages/client/Home_Page.dart';
import 'package:graduation_mobile/pages/client/disabled_account_page.dart';
import '../../Controllers/auth_controller.dart';
import '../../allDevices/screen/allDevices.dart';
import '../../sign-UpPage.dart/screen/signUp-pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

// ignore: must_be_immutable
class LoginPageState extends State<LoginPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool failur = false;

  Future<void> checkLoginStatus() async {
    String? token = await InstanceSharedPrefrences().getToken();
    AwesomeNotifications().getInitialNotificationAction().then((value) async {
      if (value == null) {
        if (token == null ||
            Get.currentRoute != '/' ||
            !await BlocProvider.of<loginCubit>(Get.context!).refreshToken()) {
          return;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    CheckConnection().thereIsAnInternet().then((internet) => {
          if (!internet)
            {BlocProvider.of<loginCubit>(Get.context!).noInternet()}
          else
            {checkLoginStatus()}
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<loginCubit, LoginState>(
      builder: (context, state) {
        if (state == LoginState.loading) {
          return Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()));
        }
        if (state == LoginState.success) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!await AppVersionController().checkLatestVersion()) {
              BlocProvider.of<loginCubit>(Get.context!).logout();
              return;
            }
            InstanceSharedPrefrences().getRuleName().then((ruleName) {
              if (ruleName == 'فني') {
                Get.off(() => const HomePages());
              } else if (ruleName == 'عامل توصيل') {
                Get.off(() => const Delivery_man());
              } else if (ruleName == 'عميل') {
                InstanceSharedPrefrences()
                    .isAccountActive()
                    .then((isAccountActive) {
                  if (isAccountActive) {
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
                BlocProvider.of<loginCubit>(Get.context!)
                    .logout()
                    .then((value) {
                  SnackBarAlert().alert(
                    "لا يوجد صلاحية الدخول للتطبيق",
                    color: const Color.fromRGBO(200, 200, 0, 1),
                    title: "المعذرة",
                  );
                  Get.offAll(() => const LoginPage());
                });
              }
            });
          });
        }
        if (state == LoginState.failure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            SnackBarAlert().alert('فشل تسجيل الدخول');
          });
          emailController.text = '';
          passwordController.text = '';
          context.read<loginCubit>().resetState();
        }
        if (state == LoginState.initial) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/images/myp.PNG'),
                      ),
                      const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 31, 31, 31),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      TextFormField(
                        textDirection: TextDirection.ltr,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'البريد الالكتروني',
                          prefixIcon: const Icon(Icons.email),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء ادخال البريد الالكتروني';
                          } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'ادخل عنوان بريد إلكتروني صحيح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textDirection: TextDirection.ltr,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور',
                          labelStyle: const TextStyle(fontFamily: "Roboto"),
                          prefixIcon: const Icon(Icons.lock_outline),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء ادخال كلمة المرور';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 50.0),
                      InkWell(
                        onTap: () {
                          if (formKey.currentState?.validate() ?? false) {
                            BlocProvider.of<loginCubit>(context).login(
                                emailController.text, passwordController.text);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(colors: [
                              Color.fromARGB(255, 233, 139, 248),
                              Color.fromARGB(255, 96, 27, 152),
                            ]),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                            child: Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'ألا تملك حساب؟',
                            style: TextStyle(),
                          ),
                          TextButton(
                            onPressed: () {
                              const Center(
                                child: CircularProgressIndicator(),
                              );
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Get.to(const SignUpPages());
                              });
                            },
                            child: const Text(
                              'انشاء حساب',
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Get.to(() => const ResetPasswordPage());
                              });
                            },
                            child: const Text(
                              ' هل نسيت كلمة المرور؟',
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Welcome To MyPhone",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
