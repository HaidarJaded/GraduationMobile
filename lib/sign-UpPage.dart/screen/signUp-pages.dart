// ignore_for_file: non_constant_identifier_names, file_names, use_super_parameters

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/login/loginScreen/loginPage.dart';

import '../../allDevices/screen/TextFormField.dart';

import '../../helper/snack_bar_alert.dart';
import '../sing-upCubit.dart';
// import 'package:my_phone/pages/login-pages.dart';
// import 'package:my_phone/pages/signUp-pages.dart';

class SignUpPages extends StatefulWidget {
  const SignUpPages({Key? key}) : super(key: key);

  @override
  State<SignUpPages> createState() => _SignUpPagesState();
}

class _SignUpPagesState extends State<SignUpPages> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController national_Id = TextEditingController();
  TextEditingController centerName = TextEditingController();
  TextEditingController password_confirmation = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
        builder: (context, state) {
      if (state == RegistrationState.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state == RegistrationState.success) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // This will ensure that the current frame is complete before executing the navigation

          BlocProvider.of<RegistrationCubit>(context).resetState();
          Get.offAll(() => const LoginPage());
          SnackBarAlert().alert("تم انشاء حساب بنجاح",
              color: const Color.fromRGBO(0, 200, 0, 1), title: "مرحباً بك");
        });
      } else if (state == RegistrationState.failure) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // This will ensure that the current frame is complete before executing the navigation
          BlocProvider.of<RegistrationCubit>(context).resetState();
          SnackBarAlert()
              .alert("فشل في انشاء الحساب", title: "الرجاء المحاولة مرة اخرى");
          // Get.offAll(() => const SignUpPages());
        });
      } else if (state == RegistrationState.initial) {
        return Scaffold(
          backgroundColor: Colors.white,
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
                    Text(
                      "Welcome To MyPhone",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      "إنشاء حساب",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    textFormField(
                      labelText: "الاسم",
                      icon: const Icon(Icons.abc_outlined),
                      controller: name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      labelText: 'الكنية',
                      icon: const Icon(Icons.abc),
                      controller: lastname,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الكنية';
                        }
                        // Add more password validation if needed
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      textDirection: TextDirection.ltr,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                      ),
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال البريد الإلكتروني';
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: true,
                      controller: passwordController,
                      textDirection: TextDirection.ltr,
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
                          return 'الرجاء إدخال كلمة المرور';
                        }
                        if (value.length < 8) {
                          return 'يجب ان يكون 8 محارف على الأقل';
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
                      controller: password_confirmation,
                      decoration: InputDecoration(
                        labelText: 'تأكيد كلمة المرور',
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
                          return 'الرجاء إدخال تأكيد كلمة المرور';
                        }
                        if (value.length < 8) {
                          return 'يجب ان يكون 8 ارقام';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'رقم الهاتف',
                          prefixIcon: const Icon(Icons.phone_android_rounded),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                      controller: phoneNumber,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال  رقم الهاتف';
                        }
                        if (value.length != 10) {
                          return 'يجب ان يكون 10 رقم';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'الرقم الوطني',
                          prefixIcon: const Icon(Icons.list_rounded),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                      controller: national_Id,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الرقم الوطني';
                        }
                        if (value.length != 11) {
                          return 'يجب ان يكون 11 رقم';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      labelText: 'العنوان',
                      icon: const Icon(Icons.line_axis),
                      controller: address,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال العنوان';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      labelText: 'اسم المركز',
                      icon: const Icon(Icons.home_filled),
                      controller: centerName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال اسم المركز';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(height: 50.0),
                    InkWell(
                      onTap: () {
                        if (formKey.currentState?.validate() ?? false) {
                          if (passwordController.text !=
                              password_confirmation.text) {
                            SnackBarAlert().alert("فشل في انشاء الحساب",
                                title: "يرجى تأكيد كلمة المرور");
                            return;
                          }
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            BlocProvider.of<RegistrationCubit>(context)
                                .register(
                              name: name.text,
                              lastName: lastname.text,
                              address: address.text,
                              email: emailController.text,
                              password: passwordController.text,
                              nationalId: national_Id.text,
                              centerName: centerName.text,
                              password_confirmation: password_confirmation.text,
                              phone: phoneNumber.text,
                            );
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(colors: [
                            Color(0xFF3E7FF8),
                            Color(0xFF21468A),
                          ]),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: const Center(
                          child: Text(
                            'تسجيل',
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
                          'ألديك حساب بالفعل؟ ',
                          style: TextStyle(),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.offAll(() => const LoginPage());
                          },
                          child: const Text(
                            'تسجيل الدخول',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      return Container();
    });
  }
}
