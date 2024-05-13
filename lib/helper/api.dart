import 'dart:convert';

import 'package:graduation_mobile/helper/http_exception.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  Future<dynamic> get(
      {required String path, Map<String, dynamic>? queryParams}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var headers = <String, String>{
        'Accept': 'application/json',
        'Authorization': token != null ? 'Bearer $token' : '',
      };
      var uri = Uri.https('haidarjaded787.serv00.net', path, queryParams);

      http.Response response = await http.get(uri, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw HttpException(response.statusCode);
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
      var uri = Uri.https('haidarjaded787.serv00.net', path);
      http.Response response =
          await http.post(uri, body: body, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body)?['body'];
      } else {
        throw HttpException(response.statusCode);
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
      var uri = Uri.https('haidarjaded787.serv00.net', "$path/$id");
      http.Response response =
          await http.put(uri, body: body, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body)?['body'];
      } else {
        throw HttpException(response.statusCode);
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
      final uri = Uri.https('haidarjaded787.serv00.net', "$path/$id");
      final response = await http.delete(uri, headers: headers);
      if (!(response.statusCode >= 200 && response.statusCode < 300)) {
        throw HttpException(response.statusCode);
      }
    } catch (e) {
      SnackBarAlert().alert(e.toString());
    }
  }
}
