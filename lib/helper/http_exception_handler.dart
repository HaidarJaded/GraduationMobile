import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/Controllers/auth_controller.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/login/loginScreen/loginPage.dart';

class HttpExceptionsHandler {
  HttpExceptionsHandler();

  void handleException(int statusCode, [String? message]) async {
    switch (statusCode) {
      case 400:
        SnackBarAlert()
            .alert(message ?? 'عذراً حدث خطأ ما يرجى إعادة المحاولة لاحقاً');
      case 422:
        SnackBarAlert()
            .alert(message ?? 'عذراً حدث خطأ ما يرجى إعادة المحاولة لاحقاً');
      case 401:
        BlocProvider.of<loginCubit>(Get.context!).resetState();
        SnackBarAlert()
            .alert('يرجى إعادة تسجيل الدخول', title: 'انتهت صلاحية الجلسة');
        Get.offAll(() => const LoginPage());
      case 403:
        SnackBarAlert().alert('عذراً لا يوجد صلاحية تنفيد العملية');
      default:
        SnackBarAlert().alert('عذراً حدث خطأ ما يرجى إعادة المحاولة لاحقاً');
    }
  }
}
