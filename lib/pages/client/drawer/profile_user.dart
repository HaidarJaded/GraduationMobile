// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/models/user_model.dart';
import 'package:graduation_mobile/pages/client/cubit/profile_user_cubit/profile_user_cubit.dart';
import 'package:graduation_mobile/pages/client/cubit/profile_user_cubit/profile_user_state.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});
  // final int? userId;

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // User? user;
  // late UserDetailsCubit _userDetailsCubit;
  // late final CrudController<User> _crudController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _phoneController;
  // late InstanceSharedPrefrences _instanceSharedPrefrences;
  @override
  void initState() {
    super.initState();
    // _crudController = CrudController<User>();
    // _userDetailsCubit = UserDetailsCubit();

    // Initialize TextEditingController variables
    // _emailController = TextEditingController();
    // _passwordController = TextEditingController();
    // _phoneController = TextEditingController();

    // if (user != null) {
    //   _userDetailsCubit.fetchProfileDetails(user!.id!);
    //   _emailController.text = user!.email;
    //   _passwordController.text = user!.password ?? '';
    //   _phoneController.text = user!.phone;
    // } else {
    //   print('No user provided');
    // }
  }

  @override
  void dispose() {
    // _userDetailsCubit.close();
    // _emailController.dispose();
    // _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'الملف الشخصي',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(500),
                    child: const Icon(Icons.person_2_sharp),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<String?>(
                      future: InstanceSharedPrefrences().getName(),
                      builder: (context, nameSnapshot) {
                        return FutureBuilder<String?>(
                            future: InstanceSharedPrefrences().getLastName(),
                            builder: (context, lastSnapshot) {
                              if (nameSnapshot.hasData &&
                                  lastSnapshot.hasData) {
                                return Row(
                                  children: [
                                    Text(
                                      nameSnapshot.data!,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      lastSnapshot.data!,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            });
                      }),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            const Divider(height: 40, thickness: 2),
            FutureBuilder(
                future: InstanceSharedPrefrences().getEmail(),
                builder: (context, emailSnapshot) {
                  if (emailSnapshot.hasData) {
                    return ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('البريد الالكتروني'),
                      subtitle: Text(emailSnapshot.data!),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _changeData('البريد الالكتروني', emailSnapshot.data!,
                              (newValue) {
                            setState(() {
                              emailSnapshot =
                                  newValue as AsyncSnapshot<String?>;
                              _emailController.text = newValue;
                            });
                          }, context);
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            const Divider(),
            // ListTile(
            //   leading: const Icon(Icons.lock_outline),
            //   title: const Text('كلمة السر'),
            //   trailing: IconButton(
            //     icon: const Icon(Icons.edit),
            //     onPressed: () {
            //       _changeData('كلمة السر', user.password ?? '',
            //           (newValue) {
            //         setState(() {
            //           user.password = newValue;
            //           _passwordController.text = newValue;
            //         });
            //       }, context);
            //     },
            //   ),
            // ),
            // const Divider(),
            FutureBuilder(
                future: InstanceSharedPrefrences().getPhone(),
                builder: (context, phoneSnapshot) {
                  if (phoneSnapshot.hasData) {
                    if (phoneSnapshot.data == null) {
                      return ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text('رقم الهاتف'),
                        subtitle: Text('لم يتم تحديده'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _changeData('رقم الهاتف', phoneSnapshot.data!,
                                (newValue) {
                              setState(() {
                                phoneSnapshot =
                                    newValue as AsyncSnapshot<String?>;
                                _phoneController.text = newValue;
                              });
                            }, context);
                          },
                        ),
                      );
                    } else {
                      return ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text('رقم الهاتف'),
                        subtitle: Text(phoneSnapshot.data!),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _changeData('رقم الهاتف', phoneSnapshot.data!,
                                (newValue) {
                              setState(() {
                                phoneSnapshot =
                                    newValue as AsyncSnapshot<String?>;
                                _phoneController.text = newValue;
                              });
                            }, context);
                          },
                        ),
                      );
                    }
                  } else {
                     return ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text('رقم الهاتف'),
                        subtitle: Text('لم يتم تحديده'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _changeData('رقم الهاتف', phoneSnapshot.data!,
                                (newValue) {
                              setState(() {
                                phoneSnapshot =
                                    newValue as AsyncSnapshot<String?>;
                                _phoneController.text = newValue;
                              });
                            }, context);
                          },
                        ),
                      );
                  }
                }),
            const SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () async {
                // await _userDetailsCubit.EditData(
                //   id: user.id!,
                //   email: _emailController.text,
                //   // password: _passwordController.text,
                //   phone: _phoneController.text,
                // );
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
                        'حفظ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                
            ),
          ],
        ));
  }
}

void _changeData(String title, String currentValue, Function(String) onSave,
    BuildContext context) {
  final TextEditingController controller =
      TextEditingController(text: currentValue);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('تعديل $title'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: ' ادخل $title الجديد',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('اغلاق'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('حفظ'),
            onPressed: () {
              onSave(controller.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
