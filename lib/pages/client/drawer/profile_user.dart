import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late String _name;
  late String _status;
  late String _email;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? 'Guest';
      _status = prefs.getString('status') ?? 'Hey there! I am using Flutter.';
      _email = prefs.getString('email') ?? 'guest@example.com';
    });
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
                Text(
                  _name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          const Divider(height: 40, thickness: 2),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('البريد الالكتروني'),
            subtitle: Text(_name),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // إضافة منطق لتحديث الاسم
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('كلمة السر'),
            subtitle: Text(_status),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // إضافة منطق لتحديث الحالة
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('رقم الهاتف'),
            subtitle: Text(_email),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // إضافة منطق لتحديث البريد الإلكتروني
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _changeData(String title, String currentValue, Function(String) onSave) {
  final TextEditingController controller =
      TextEditingController(text: currentValue);

  // showDialog(
  //   context: context,
  //   builder: (BuildContext context) {
  //     return AlertDialog(
  //       title: Text('تعديل $title'),
  //       content: TextField(
  //         controller: controller,
  //         decoration: InputDecoration(
  //           hintText: ' ادخل $title الجديد',
  //         ),
  //       ),
  //       actions: <Widget>[
  //         TextButton(
  //           child: const Text('اغلاق'),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //         TextButton(
  //           child: const Text('حفظ'),
  //           onPressed: () {
  //             onSave(controller.text);
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //       ],
  //     );
  //   },
  // );
}
