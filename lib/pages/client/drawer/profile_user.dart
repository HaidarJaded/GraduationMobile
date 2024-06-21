import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/pages/client/cubit/profile_user_cubit/profile_user_cubit.dart';
import 'package:graduation_mobile/pages/client/cubit/profile_user_cubit/profile_user_state.dart';
import 'package:graduation_mobile/the_center/center.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late InstanceSharedPrefrences _instanceSharedPrefrences;
  late UserDetailsCubit _userDetailsCubit;
  String? phone;

  @override
  void initState() {
    super.initState();
    _userDetailsCubit = UserDetailsCubit();
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
                        if (nameSnapshot.hasData && lastSnapshot.hasData) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
              if (emailSnapshot.hasData) {
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
                            _emailController.text = newEmail;
                            await _instanceSharedPrefrences
                                .setEmail(_emailController.text);
                          },
                          context,
                        );
                      });
                    },
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          const Divider(),
          FutureBuilder(
            future: _instanceSharedPrefrences.getPhone(),
            builder: (context, phoneSnapshot) {
              if (phoneSnapshot.hasData) {
                return ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('رقم الهاتف'),
                  subtitle: Text(_phoneController.text),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _changeData(
                          'رقم الهاتف',
                          phoneSnapshot.data!,
                          (newPhone) async {
                            _phoneController.text = newPhone;
                            await _instanceSharedPrefrences
                                .setPhone(_phoneController.text);
                          },
                          context,
                        );
                      });
                    },
                  ),
                );
              } else {
                return ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('رقم الهاتف'),
                  subtitle: Text(_phoneController.text),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('تعديل رقم الهاتف'),
                              content: TextField(
                                controller: _phoneController,
                                decoration: const InputDecoration(
                                  hintText: ' ادخل رقم الهاتف الجديد',
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
                                    _phoneController.text = phone!;
                                    _instanceSharedPrefrences.setPhone(phone!);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      });
                    },
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 50),
          BlocBuilder<UserDetailsCubit, UserDetailsState>(
              builder: (context, state) {
            if (state is UserDetalisLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserDetalisFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errormess)),
              );
            }
            return InkWell(
              onTap: () async {
                print(_emailController.text);
                print(_phoneController);
                await _userDetailsCubit.EditData(
                    email: _emailController.text, phone: phone!);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 233, 139, 248),
                      Color.fromARGB(255, 96, 27, 152),
                    ],
                  ),
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
            );
          }),
        ],
      ),
    );
  }
}

Future<void> _changeData(
  String title,
  String? currentValue,
  Function(String) onSave,
  BuildContext context,
) async {
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
            onPressed: () async {
              await onSave(controller.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
