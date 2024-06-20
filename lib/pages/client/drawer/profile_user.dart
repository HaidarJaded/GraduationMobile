import 'package:flutter/material.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
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
                  future: InstanceSharedPrefrences().getName(),
                  builder: (context, nameSnapshot) {
                    return FutureBuilder<String?>(
                      future: InstanceSharedPrefrences().getLastName(),
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
                      setState(() {
                        _changeData(
                          'البريد الالكتروني',
                          emailSnapshot.data!,
                          (newEmail) {
                            _emailController.text = newEmail;
                            print(_emailController.text);
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
            future: InstanceSharedPrefrences().getPhone(),
            builder: (context, phoneSnapshot) {
              if (phoneSnapshot.hasData) {
                return ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('رقم الهاتف'),
                  subtitle: Text(phoneSnapshot.data ?? 'لم يتم تحديده'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _changeData(
                          'رقم الهاتف',
                          phoneSnapshot.data!,
                          (newEmail) {
                            _phoneController.text = newEmail;
                            print(_phoneController.text);
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
                  subtitle: Text(phoneSnapshot.data ?? 'لم يتم تحديده'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _changeData(
                          'رقم الهاتف',
                          phoneSnapshot.data! ?? '',
                          (newPhone) {
                            InstanceSharedPrefrences().setPhone(newPhone);
                            _phoneController.text = newPhone;
                            print(_phoneController.text);
                          },
                          context,
                        );
                      });
                    },
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 50),
          InkWell(
            onTap: () async {
              InstanceSharedPrefrences().setEmail(_emailController.text);
              InstanceSharedPrefrences().setPhone(_phoneController.text);
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
          ),
        ],
      ),
    );
  }
}

void _changeData(
  String title,
  String? currentValue,
  Function(String) onSave,
  BuildContext context,
) {
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
              print(controller);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
