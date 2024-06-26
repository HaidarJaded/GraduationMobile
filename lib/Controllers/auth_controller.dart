// ignore_for_file: camel_case_types, avoid_print
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/check_connection.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/models/user_model.dart';

enum LoginState {
  initial,
  loading,
  success,
  failure,
  inState,
}

class loginCubit extends Cubit<LoginState> {
  loginCubit() : super(LoginState.initial);

  Future<bool> login(String email, String password) async {
    try {
      if (!await CheckConnection().thereIsAnInternet()) {
        return false;
      }
      emit(LoginState.loading);

      final responseBody = await Api().post(
          path: "/api/login", body: {'email': email, 'password': password});
      if (responseBody == null) {
        emit(LoginState.failure);
        return false;
      }
      final token = responseBody['token'] as String?;
      final userInfoMap = responseBody['auth'] as Map<String, dynamic>?;
      if (token == null || userInfoMap == null) {
        emit(LoginState.failure);
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

      await InstanceSharedPrefrences().setToken(token);
      await InstanceSharedPrefrences().setProfile(userInfoMap);

      emit(LoginState.success);
      getAndSaveFcm();
      return true;
    } catch (e) {
      emit(LoginState.failure);
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      if (!await CheckConnection().thereIsAnInternet()) {
        return false;
      }
      final responseBody = await Api().post(path: "api/logout", body: {});
      if (responseBody == null) {
        return false;
      }
      emit(LoginState.initial);
      await InstanceSharedPrefrences().clearAll();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> refreshToken() async {
    try {
      emit(LoginState.loading);
      final responseBody =
          await Api().post(path: "/api/refresh_token", body: {});
      if (responseBody == null) {
        emit(LoginState.initial);
        return false;
      }
      final String token = responseBody['token'];
      InstanceSharedPrefrences().setToken(token);
      getAndSaveFcm();
      await refreshData();
      emit(LoginState.success);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future saveFcm(String fcmToken) async {
    try {
      await Api().post(
          path: "/api/firebase/store_token", body: {"device_token": fcmToken});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> getAndSaveFcm() async {
    try {
      //Initial Firebase
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? fcmToken = await messaging.getToken();
      if (fcmToken == null) {
        return false;
      }
      await saveFcm(fcmToken);
      return true;
    } catch (e) {
      return false;
    }
  }

  void resetState() {
    emit(LoginState.initial);
  }

  void noInternet() async {
    emit(LoginState.loading);
  }

  Future refreshData() async {
    String? ruleName = await InstanceSharedPrefrences().getRuleName();
    int? id = await InstanceSharedPrefrences().getId();
    if (ruleName == null || id == null) {
      return;
    }
    if (ruleName == 'عميل') {
      var response = await Api().get(
          path: 'api/clients/$id',
          queryParams: {'with': 'permissions,rule.permissions'});
      if (response == null) {
        return;
      }
      await InstanceSharedPrefrences().setProfile(response['body']);
      final rulePermissions = List<Map<String, dynamic>>.from(
          response['body']['rule']['permissions']);

      final directPermissions =
          List<Map<String, dynamic>>.from(response['body']['permissions']);
      final List<String> permissions = [];
      permissions
          .addAll(rulePermissions.map((permission) => permission['name']));
      permissions
          .addAll(directPermissions.map((permission) => permission['name']));
      await User.saveUserPermissions(permissions);
    } else if (ruleName == 'فني' || ruleName == 'عامل توصيل') {
      var response = await Api().get(
          path: 'api/users/$id',
          queryParams: {'with': 'permissions,rule.permissions'});
      if (response == null) {
        return;
      }
      await InstanceSharedPrefrences().setProfile(response['body']);
      final rulePermissions = List<Map<String, dynamic>>.from(
          response['body']['rule']['permissions']);

      final directPermissions =
          List<Map<String, dynamic>>.from(response['body']['permissions']);
      final List<String> permissions = [];
      permissions
          .addAll(rulePermissions.map((permission) => permission['name']));
      permissions
          .addAll(directPermissions.map((permission) => permission['name']));
      await User.saveUserPermissions(permissions);
    }
  }
}
