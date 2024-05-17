import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class InstanceSharedPrefrences {
  late SharedPreferences prefs;
  initial() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<String?> getToken() async {
    await initial();
    return prefs.getString('token');
  }

  Future<int?> getId() async {
    await initial();
    var profile = prefs.getString('profile');
    if (profile == null) {
      return null;
    }
    return jsonDecode(profile)['id'];
  }

  Future setToken(String token) async {
    await initial();
    await prefs.setString('token', token);
  }

  Future setProfile(var profile) async {
    await initial();
    final userInfo = jsonEncode(profile);
    await prefs.setString('profile', userInfo);
  }

  Future clearAll() async {
    await initial();
    prefs.clear();
  }
  
}
