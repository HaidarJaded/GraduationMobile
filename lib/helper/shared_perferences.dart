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

  Future<Map<String, dynamic>> getProfile() async {
    await initial();
    final userProfile = jsonDecode(prefs.getString('profile') ?? '');
    return userProfile;
  }

  Future clearAll() async {
    await initial();
    prefs.clear();
  }

  Future<String?> getRuleName() async {
    await initial();
    var profile = prefs.getString('profile');
    if (profile == null) {
      return null;
    }
    return jsonDecode(profile)['rule']?['name'];
  }

  Future<String?> getName() async {
    await initial();
    var profile = prefs.getString('profile');
    if (profile == null) {
      return null;
    }
    return jsonDecode(profile)['name'];
  }

  Future<String?> getEmail() async {
    await initial();
    var profile = prefs.getString('profile');
    if (profile == null) {
      return null;
    }
    return jsonDecode(profile)['email'];
  }

  Future<bool> isAccountActive() async {
    await initial();
    var profile = prefs.getString('profile');
    if (profile == null) {
      return false;
    }
    return jsonDecode(profile)['account_active'] == 1;
  }

  Future<bool> isAtWork() async {
    await initial();
    var userProfile = await getProfile();
    if (userProfile.isEmpty) {
      return false;
    }
    int atWork = userProfile['at_work'];
    return atWork == 1;
  }

  void editAtWork(int newStatus) async {
    await initial();
    var userProfile = await getProfile();
    if (userProfile.isEmpty) {
      return;
    }
    userProfile['at_work'] = newStatus;
    setProfile(userProfile);
  }
}
