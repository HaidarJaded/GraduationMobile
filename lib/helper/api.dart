// ignore_for_file: avoid_print

import 'package:graduation_mobile/helper/check_connection.dart';
import 'package:graduation_mobile/helper/http_exception_handler.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:dio/dio.dart';

class Api {
  final String baseUrl = "https://haidarjaded787.serv00.net/";
  Future<dynamic> get(
      {required String path, Map<String, dynamic>? queryParams}) async {
    if (!await CheckConnection().thereIsAnInternet()) {
      return;
    }
    try {
      String? token = await InstanceSharedPrefrences().getToken();
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
        HttpExceptionsHandler().handleException(response.statusCode!);
      }
    } on DioException catch (e) {
      HttpExceptionsHandler().handleException(
          e.response!.statusCode!, e.response?.data['message']);
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> post({
    required String path,
    dynamic body,
  }) async {
    if (!await CheckConnection().thereIsAnInternet()) {
      return;
    }
    try {
      String? token = await InstanceSharedPrefrences().getToken();
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
        HttpExceptionsHandler().handleException(response.statusCode!);
      }
    } on DioException catch (e) {
      if (e.requestOptions.path != 'api/logout' &&
          e.requestOptions.path != 'api/refresh_token' &&
          e.requestOptions.path != '/api/login') {
        HttpExceptionsHandler().handleException(
            e.response!.statusCode!, e.response?.data['message']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> put({
    required String path,
    required Map<String, dynamic> body,
  }) async {
    if (!await CheckConnection().thereIsAnInternet()) {
      return;
    }
    try {
      String? token = await InstanceSharedPrefrences().getToken();
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
        HttpExceptionsHandler().handleException(response.statusCode!);
      }
    } on DioException catch (e) {
      HttpExceptionsHandler().handleException(
          e.response!.statusCode!, e.response?.data['message']);
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> delete({required String path}) async {
    if (!await CheckConnection().thereIsAnInternet()) {
      return;
    }
    try {
      String? token = await InstanceSharedPrefrences().getToken();
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
        HttpExceptionsHandler().handleException(response.statusCode!);
        return "error";
      }
      return null;
    } on DioException catch (e) {
      HttpExceptionsHandler().handleException(
          e.response!.statusCode!, e.response?.data['message']);
      return "error";
    } catch (e) {
      return;
    }
  }
}
