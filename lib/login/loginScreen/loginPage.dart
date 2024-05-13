// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Controllers/auth_controller.dart';
import '../../allDevices/cubit/all_devices_cubit.dart';
import '../../allDevices/screen/allDevices.dart';
import '../../sign-UpPage.dart/screen/signUp-pages.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool failur = false;

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<loginCubit, LoginState>(
      builder: (context, state) {
        if (state == LoginState.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state == LoginState.success) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            BlocProvider.of<AllDevicesCubit>(context).getDeviceData();
            // This will ensure that the current frame is complete before executing the navigation
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const allDevices()),
              (route) => false,
            );
          });
        }

        if (state == LoginState.failure) {
          return const Text('فشل تسجيل الدخول');
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
                        child: Image.asset('images/myp.PNG'),
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          // labelStyle: const TextStyle(fontFamily: "Roboto"),
                          prefixIcon: const Icon(Icons.email),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'ادخل عنوان بريد إلكتروني صحيح';
                          }
                          // Add more email validation if needed
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
                        decoration: InputDecoration(
                          labelText: 'Password',
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
                            return 'Please enter your password';
                          }
                          // Add more password validation if needed
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
                              'Login',
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
                            'Don\'t have an account?',
                            style: TextStyle(),
                          ),
                          GestureDetector(
                            onTap: () {
                              const Center(
                                child: CircularProgressIndicator(),
                              );
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                // This will ensure that the current frame is complete before executing the navigation
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpPages()),
                                  (route) => false,
                                );
                              });
                            },
                            child: const Text(
                              ' signUp',
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
        return Container(
            color: const Color.fromARGB(
                255, 255, 255, 255)); // حالة أخرى (مثلاً AuthInitial)
      },
    );
  }
}
