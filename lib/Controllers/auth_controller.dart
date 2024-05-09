import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:graduation_mobile/firebase_options.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  Future<bool> login(String email, String password) async {
    try {
      // emit(LoginState.loading);

      final responseBody = await Api().post(
          path: "/api/login", body: {'email': email, 'password': password});
      if (responseBody == null) {
        return false;
      }
      final token = responseBody['token'] as String?;
      final userInfoMap = responseBody['auth'] as Map<String, dynamic>?;
      if (token == null || userInfoMap == null) {
        return false;
      }
      final rulePermissions = List<Map<String, dynamic>>.from(
          responseBody['auth']['rule']['permissions']);

      final directPermissions =
          List<Map<String, dynamic>>.from(responseBody['auth']['permissions']);
      final List<String> permissions = [];
      permissions
          .addAll(rulePermissions.map((permission) => permission['name']));
      permissions
          .addAll(directPermissions.map((permission) => permission['name']));

      await User.saveUserPermissions(permissions);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userInfo = jsonEncode(userInfoMap);

      // Save token and user info as strings in shared preferences
      await prefs.setString('token', token);
      await prefs.setString('profile', userInfo);

      // emit(LoginState.success);
      return true;
    } catch (e) {
      // emit(LoginState.failure);
      print(e.toString());
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final responseBody = await Api().post(path: "api/logout", body: {});
      if (responseBody == null) {
        return false;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> refreshToken() async {
    try {
      final responseBody =
          await Api().post(path: "/api/refresh_token", body: {});
      if (responseBody == null) {
        return false;
      }
      final String token = responseBody['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      final String? fcmToken = prefs.getString('FcmToken');
      saveFcm(fcmToken!);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future saveFcm(String fcmToken) async {
    try {
      final responseBody = await Api().post(
          path: "/api/firebase/store_token", body: {"device_token": fcmToken});
      if (responseBody) {
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> getAndSaveFcm() async {
    try {
      //Initial Firebase
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? fcmToken = await messaging.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('FcmToken', fcmToken!);
      await saveFcm(fcmToken);
      return true;
    } catch (e) {
      return false;
    }
  }
}
