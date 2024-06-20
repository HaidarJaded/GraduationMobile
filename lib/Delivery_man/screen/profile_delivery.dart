// ignore_for_file: avoid_print, unnecessary_import, library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/Delivery_man/cubit/profile_delivery_cubit/profile_delivery_cubit.dart';
import 'package:graduation_mobile/Delivery_man/cubit/profile_delivery_cubit/profile_delivery_state.dart';
import 'package:graduation_mobile/models/user_model.dart';

class DeliveryProfilePage extends StatefulWidget {
  const DeliveryProfilePage({super.key});

  @override
  _DeliveryProfilePageState createState() => _DeliveryProfilePageState();
}

class _DeliveryProfilePageState extends State<DeliveryProfilePage> {
  late DeliveryDetailsCubit _deliveryDetailsCubit;
  late final CrudController<User> _crudController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _phoneController;
  User? user;
  @override
  void initState() {
    super.initState();
    _deliveryDetailsCubit = DeliveryDetailsCubit(_crudController);

    // Initialize TextEditingController variables
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneController = TextEditingController();

    _emailController.text = user!.email;
    _passwordController.text = user!.password ?? '';
    _phoneController.text = user!.phone;
  }

  @override
  void dispose() {
    _deliveryDetailsCubit.close();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _deliveryDetailsCubit,
      child: Scaffold(
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
        body: BlocConsumer<DeliveryDetailsCubit, DeliveryDetailsState>(
          listener: (context, state) {
            if (state is DeliveryDetalisFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errormess)),
              );
            }
          },
          builder: (context, state) {
            if (state is DeliveryDetalisLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DeliveryDetalisSuccesses) {
              final user = state.details.first;
              return ListView(
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
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  const Divider(height: 40, thickness: 2),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('البريد الالكتروني'),
                    subtitle: Text(user.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _changeData('البريد الالكتروني', user.email,
                            (newValue) {
                          setState(() {
                            user.email = newValue;
                            _emailController.text = newValue;
                          });
                        }, context);
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text('كلمة السر'),
                    subtitle: Text(user.password ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _changeData('كلمة السر', user.password ?? '',
                            (newValue) {
                          setState(() {
                            user.password = newValue;
                            _passwordController.text = newValue;
                          });
                        }, context);
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('رقم الهاتف'),
                    subtitle: Text(user.phone),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _changeData('رقم الهاتف', user.phone, (newValue) {
                          setState(() {
                            user.phone = newValue;
                            _phoneController.text = newValue;
                          });
                        }, context);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: () async {
                      await _deliveryDetailsCubit.EditData(
                        id: user.id!,
                        email: _emailController.text,
                        password: _passwordController.text,
                        phone: _phoneController.text,
                      );
                    },
                    child: const Text('حفظ '),
                  ),
                ],
              );
            } else {
              return const Center(child: Text("error"));
            }
          },
        ),
      ),
    );
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
