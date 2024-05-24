import 'package:connectivity/connectivity.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';

class CheckConnection {
  static ConnectivityResult? currentState;
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    currentState = connectivityResult;
    return connectivityResult != ConnectivityResult.none;
  }

  Future<bool> thereIsAnInternet() async {
    bool isConnected = await checkInternetConnection();

    if (!isConnected) {
      SnackBarAlert()
          .alert("الرجاء الاتصال بالانترنت ثم اعادة المحاولة", title: "عذراً لا يوجد اتصال بالانترنت");
      return false;
    }
    return true;
  }
}
