import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/models/user_model.dart';
import 'package:graduation_mobile/pages/client/cubit/profile_user_cubit/profile_user_cubit.dart';
import 'package:graduation_mobile/pages/client/cubit/profile_user_cubit/profile_user_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key, required this.user}) : super(key: key);
  final User? user;

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late UserDetailsCubit _userDetailsCubit;
  late final CrudController<User> _crudController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _crudController = CrudController<User>();
    _userDetailsCubit = UserDetailsCubit(_crudController);

    if (widget.user != null) {
      print('${widget.user}');
      _userDetailsCubit.fetchProfileDetails(widget.user!.id!);
      _emailController = TextEditingController(text: widget.user!.email);
      _passwordController = TextEditingController(text: widget.user!.phone);
      _phoneController = TextEditingController(text: widget.user!.password);
    } else {
      print('not user');
      _emailController = TextEditingController();
      _passwordController = TextEditingController();
      _phoneController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _userDetailsCubit.close();
    _emailController.dispose();
    _passwordController.dispose();
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
      body: BlocProvider(
        create: (context) => _userDetailsCubit,
        child: BlocConsumer<UserDetailsCubit, UserDetailsState>(
          listener: (context, state) {
            if (state is UserDetalisFailure) {
              print('error');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errormess)),
              );
            } else if (state is UserDetalisLoading) {
              print('loading');
              const Center(child: CircularProgressIndicator());
            }
          },
          builder: (context, state) {
            if (state is UserDetalisSuccesses) {
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
                      await _userDetailsCubit.EditData(
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
