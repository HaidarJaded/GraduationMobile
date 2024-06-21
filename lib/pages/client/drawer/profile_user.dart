// ignore_for_file: avoid_print, library_private_types_in_public_api

// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_mobile/drawerScreen/profile/profile.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late InstanceSharedPrefrences _instanceSharedPrefrences;
  String? phone;

  @override
  void initState() {
    super.initState();
    _instanceSharedPrefrences = InstanceSharedPrefrences(); // تهيئة المتغير هنا
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
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
                      _changeData(
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
                    _changeData('رقم الهاتف', phoneSnapshot.data!,
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
        ],
      ),
    );
  }
}

Future<bool> _changeDataOnDatabase(Map<String, String> requestBody) async {
  int? userId = await InstanceSharedPrefrences().getId();
  if (userId == null) {
    return false;
  }
  var response = await Api().put(path: 'api/users/$userId', body: requestBody);
  if (response == null) {
    return false;
  }
  return true;
}

Future<void> _changeData(String title, String? currentValue,
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
