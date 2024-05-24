import 'package:get/get.dart';
import 'package:graduation_mobile/helper/http_exception.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:dio/dio.dart';
import 'package:graduation_mobile/login/loginScreen/loginPage.dart';

class Api {
  final String baseUrl = "https://haidarjaded787.serv00.net/";
  Future<dynamic> get(
      {required String path, Map<String, dynamic>? queryParams}) async {
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
      SnackBarAlert().alert(e.response?.data['message']);
      if (e.response?.statusCode == 401) {
        Get.offAll(() => LoginPage());
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
      SnackBarAlert().alert(e.response?.data['message']);
      if (e.response?.statusCode == 401) {
        Get.offAll(() => LoginPage());
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
      SnackBarAlert().alert(e.response?.data['message']);
      if (e.response?.statusCode == 401) {
        Get.offAll(() => LoginPage());
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> delete({required String path, required int id}) async {
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
      SnackBarAlert().alert(e.response?.data['message']);
      // if (e.response?.statusCode == 403) {

      Get.offAll(() => LoginPage());
      // }
      return;
    } catch (e) {
      return;
    }
  }
}
