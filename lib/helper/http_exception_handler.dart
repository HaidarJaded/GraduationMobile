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
        if (await loginCubit().logout()) {
          SnackBarAlert().alert(
              'عذراً حدث خطأ ما يرجى إعادة تسجيل الدخول مجدداً ثم إعادة المحاولة لاحقاً');
          Get.offAll(() => const LoginPage());
        }
      case 403:
        SnackBarAlert().alert('عذراً لا يوجد صلاحية تنفيد العملية');
        Get.back();
      default:
        SnackBarAlert().alert('عذراً حدث خطأ ما يرجى إعادة المحاولة لاحقاً');
    }
  }
}
