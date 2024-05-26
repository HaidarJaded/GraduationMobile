// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:graduation_mobile/helper/check_connection.dart';
import 'package:graduation_mobile/helper/http_exception.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:dio/dio.dart';
import 'package:graduation_mobile/login/loginScreen/loginPage.dart';

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
        throw HttpException(response.statusCode!);
      }
    } on DioException catch (e) {
      SnackBarAlert().alert(e.response?.data['message'] ??
          'عذراً حدث خطأ ما يرجى إعادة المحاولة لاحقاً');
      if (e.response?.statusCode == 401) {
        Get.offAll(() => const LoginPage());
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> post({
    required String path,
    required dynamic body,
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
        throw HttpException(response.statusCode!);
      }
    } on DioException catch (e) {
      SnackBarAlert().alert(e.response?.data['message'] ??
          'عذراً حدث خطأ ما يرجى إعادة المحاولة لاحقاً');
      SnackBarAlert().alert(e.response?.data['message'] ??
          'عذراً حدث خطأ ما يرجى إعادة المحاولة لاحقاً');
      if (e.response?.statusCode == 401) {
        Get.offAll(() => const LoginPage());
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
        throw HttpException(response.statusCode!);
      }
    } on DioException catch (e) {
      SnackBarAlert().alert(e.response?.data['message'] ??
          'عذراً حدث خطأ ما يرجى إعادة المحاولة لاحقاً');
      if (e.response?.statusCode == 401) {
        Get.offAll(() => const LoginPage());
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> delete({required String path, required int id}) async {
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
        throw HttpException(response.statusCode!);
      }
    } on DioException catch (e) {
      SnackBarAlert().alert(e.response?.data['message'] ??
          'عذراً حدث خطأ ما يرجى إعادة المحاولة لاحقاً');
      // if (e.response?.statusCode == 403) {

      // }
      return;
    } catch (e) {
      return;
    }
  }
}
