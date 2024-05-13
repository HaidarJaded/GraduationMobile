import 'dart:convert';

import 'package:graduation_mobile/helper/http_exception.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  final String baseUrl = "https://haidarjaded787.serv00.net/";
  Future<dynamic> get(
      {required String path, Map<String, dynamic>? queryParams}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var headers = <String, String>{
        'Accept': 'application/json',
        'Authorization': token != null ? 'Bearer $token' : '',
      };
      var dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        headers: headers,
      ));
      var response = await dio.get(path, queryParameters: queryParams);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data;
      } else {
        throw HttpException(response.statusCode!);
      }
    } catch (e) {
      SnackBarAlert().alert(e.toString());
      return null;
    }
  }

  Future<dynamic> post({
    required String path,
    required dynamic body,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': token != null ? 'Bearer $token' : '',
      };
      var dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        headers: headers,
      ));
      var response = await dio.post(path, data: body);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data?['body'];
      } else {
        throw HttpException(response.statusCode!);
      }
    } catch (e) {
      SnackBarAlert().alert(e.toString());
      return null;
    }
  }

  Future<dynamic> put(
      {required String path,
      required Map<String, dynamic> body,
      required int id}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        headers: headers,
      ));
      var response = await dio.put(path, data: body);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data?['body'];
      } else {
        throw HttpException(response.statusCode!);
      }
    } catch (e) {
      SnackBarAlert().alert(e.toString());
      return null;
    }
  }

  Future<void> delete({required String path, required int id}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        headers: headers,
      ));
      var response = await dio.delete(path);
      if (!(response.statusCode! >= 200 && response.statusCode! < 300)) {
        throw HttpException(response.statusCode!);
      }
    } catch (e) {
      SnackBarAlert().alert(e.toString());
    }
  }
}
