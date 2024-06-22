// ignore_for_file: avoid_print, library_private_types_in_public_api

// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/drawerScreen/profile/profile.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  _ClientProfilePageState createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _centerNameController;
  late InstanceSharedPrefrences _instanceSharedPrefrences;
  String? phone;

  @override
  void initState() {
    super.initState();
    _instanceSharedPrefrences = InstanceSharedPrefrences(); // تهيئة المتغير هنا
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _centerNameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
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
                  borderRadius: BorderRadius.circular(300),
                  child: const Icon(
                    Icons.person_sharp,
                    size: 200,
                  ),
                ),
                const SizedBox(height: 15),
                FutureBuilder<String?>(
                  future: _instanceSharedPrefrences.getName(),
                  builder: (context, nameSnapshot) {
                    return FutureBuilder<String?>(
                      future: _instanceSharedPrefrences.getLastName(),
                      builder: (context, lastSnapshot) {
                        if (nameSnapshot.connectionState ==
                                ConnectionState.done &&
                            lastSnapshot.connectionState ==
                                ConnectionState.done) {
                          if (nameSnapshot.hasData && lastSnapshot.hasData) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${nameSnapshot.data!} ${lastSnapshot.data!}",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          }
                          return const SizedBox();
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const Divider(height: 40, thickness: 2),
          FutureBuilder(
            future: _instanceSharedPrefrences.getEmail(),
            builder: (context, emailSnapshot) {
              if (emailSnapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              _emailController.text = emailSnapshot.data ?? '';
              return ListTile(
                leading: const Icon(Icons.email),
                title: const Text('البريد الالكتروني'),
                subtitle: Text(_emailController.text),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _changeDataDialog(
                        'البريد الالكتروني',
                        emailSnapshot.data!,
                        (newEmail) async {
                          if (newEmail != _emailController.text) {
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(newEmail)) {
                              SnackBarAlert()
                                  .alert('الرجاء ادخال بريد الكتروني صالح');
                              return;
                            }
                            if (await _changeDataOnDatabase(
                                {'email': newEmail})) {
                              setState(() {
                                _emailController.text = newEmail;
                              });
                              await _instanceSharedPrefrences
                                  .setEmail(_emailController.text);
                            }
                          }
                        },
                        context,
                      );
                    });
                  },
                ),
              );
            },
          ),
          const Divider(),
          FutureBuilder(
            future: _instanceSharedPrefrences.getPhone(),
            builder: (context, phoneSnapshot) {
              if (phoneSnapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              phoneController.text = phoneSnapshot.data ?? '';
              return ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('رقم الهاتف'),
                subtitle: Text(phoneController.text),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _changeDataDialog('رقم الهاتف', phoneSnapshot.data,
                        (newPhone) async {
                      if (newPhone.length != 10) {
                        SnackBarAlert()
                            .alert('رقم الهاتف يجب ان يكون 10 ارقام');
                        return;
                      }
                      if (await _changeDataOnDatabase({'phone': newPhone})) {
                        setState(() {
                          _phoneController.text = newPhone;
                        });
                        await _instanceSharedPrefrences
                            .setPhone(_phoneController.text);
                      }
                    }, context, true);
                  },
                ),
              );
            },
          ),
          const Divider(height: 40, thickness: 2),
          FutureBuilder(
            future: _instanceSharedPrefrences.getAddress(),
            builder: (context, addressSnapshot) {
              if (addressSnapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              _addressController.text = addressSnapshot.data ?? '';
              return ListTile(
                leading: const Icon(Icons.email),
                title: const Text('العنوان'),
                subtitle: Text(_addressController.text),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _changeDataDialog(
                        'العنوان',
                        addressSnapshot.data!,
                        (newAddress) async {
                          if (newAddress == _addressController.text) {
                            return;
                          }
                          if (newAddress.isEmpty) {
                            SnackBarAlert().alert('الرجاء ادخال العنوان');
                            return;
                          }
                          if (await _changeDataOnDatabase(
                              {'address': newAddress})) {
                            setState(() {
                              _addressController.text = newAddress;
                            });
                            await _instanceSharedPrefrences
                                .setAddress(_addressController.text);
                          }
                        },
                        context,
                      );
                    });
                  },
                ),
              );
            },
          ),
          const Divider(height: 40, thickness: 2),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('كلمة المرور'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _changePasswordDialog();
              },
            ),
          ),
          const Divider(height: 40, thickness: 2),
          FutureBuilder(
            future: _instanceSharedPrefrences.getCenterName(),
            builder: (context, centerNameSnapshot) {
              if (centerNameSnapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              _centerNameController.text = centerNameSnapshot.data ?? '';
              return ListTile(
                leading: const Icon(Icons.email),
                title: const Text('اسم المركز'),
                subtitle: Text(_centerNameController.text),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _changeDataDialog(
                        'اسم المركز',
                        centerNameSnapshot.data!,
                        (newCenterName) async {
                          if (newCenterName == _centerNameController.text) {
                            return;
                          }
                          if (newCenterName.isEmpty) {
                            SnackBarAlert().alert('الرجاء ادخال اسم المركز');
                            return;
                          }
                          if (await _changeDataOnDatabase(
                              {'center_name': newCenterName})) {
                            setState(() {
                              _centerNameController.text = newCenterName;
                            });
                            await _instanceSharedPrefrences
                                .setCenterName(_centerNameController.text);
                          }
                        },
                        context,
                      );
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<bool> _changeDataOnDatabase(Map<String, String> requestBody) async {
  int? clientId = await InstanceSharedPrefrences().getId();
  if (clientId == null) {
    return false;
  }
  var response =
      await Api().put(path: 'api/clients/$clientId', body: requestBody);
  if (response == null) {
    return false;
  }
  return true;
}

Future<void> _changeDataDialog(String title, String? currentValue,
    Function(String) onSave, BuildContext context,
    [bool isNumeric = false]) async {
  final TextEditingController controller =
      TextEditingController(text: currentValue);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('تعديل $title'),
        content: TextField(
          textDirection: TextDirection.ltr,
          keyboardType: isNumeric ? TextInputType.number : null,
          inputFormatters:
              isNumeric ? [FilteringTextInputFormatter.digitsOnly] : [],
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
            onPressed: () async {
              Navigator.of(context).pop();
              await onSave(controller.text);
            },
          ),
        ],
      );
    },
  );
}

Future<void> _changePasswordDialog() async {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newPasswordConfirmationController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('تعديل كلمة المرور'),
        content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      hintText: 'أدخل كلمة المرور الحالية',
                    ),
                    validator: (currentPassword) {
                      if (currentPassword == null || currentPassword.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور';
                      }
                      if (currentPassword.length < 8) {
                        return 'يجب ان يكون 8 محارف على الأقل';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: true,
                    controller: newPasswordController,
                    decoration: const InputDecoration(
                      hintText: 'أدخل كلمة المرور الجديدة',
                    ),
                    validator: (currentPassword) {
                      if (currentPassword == null || currentPassword.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور';
                      }
                      if (currentPassword.length < 8) {
                        return 'يجب ان يكون 8 محارف على الأقل';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: true,
                    controller: newPasswordConfirmationController,
                    decoration: const InputDecoration(
                      hintText: 'أدخل تأكيد كلمة المرور الجديدة',
                    ),
                    validator: (currentPassword) {
                      if (currentPassword == null || currentPassword.isEmpty) {
                        return 'الرجاء إدخال تأكيد كلمة المرور';
                      }
                      if (currentPassword.length < 8) {
                        return 'يجب ان يكون 8 محارف على الأقل';
                      }
                      return null;
                    },
                  )
                ],
              ),
            )),
        actions: <Widget>[
          TextButton(
            child: const Text('اغلاق'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('حفظ'),
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                if (newPasswordController.text !=
                    newPasswordConfirmationController.text) {
                  SnackBarAlert().alert("فشل في انشاء الحساب",
                      title: "يرجى تأكيد كلمة المرور");
                  return;
                }
                if (await _changePassword(
                    passwordController.text,
                    newPasswordController.text,
                    newPasswordConfirmationController.text)) {
                  Navigator.of(Get.context!).pop();
                  SnackBarAlert().alert('تم إعادة تعيين كلمة المرور بنجاح',
                      title: 'تم', color: const Color.fromRGBO(0, 220, 0, 1));
                }
              }
            },
          ),
        ],
      );
    },
  );
}

Future<bool> _changePassword(String currentPassword, String newPassword,
    String newPasswordConfirmation) async {
  try {
    var response = await Api().post(path: 'api/change_password', body: {
      'current_password': currentPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPasswordConfirmation
    });
    if (response == null) {
      return false;
    }
    return true;
  } catch (e) {
    return false;
  }
}
