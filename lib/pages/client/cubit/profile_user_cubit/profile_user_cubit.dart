// ignore_for_file: avoid_print
import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/models/user_model.dart';
import 'package:graduation_mobile/pages/client/cubit/profile_user_cubit/profile_user_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  final CrudController<User> _crudController;

  UserDetailsCubit(this._crudController) : super(UserDetalisInitial());

  Future<void> fetchProfileDetails(int userId) async {
    try {
      emit(UserDetalisLoading());
      final user = await _crudController.getById(userId, null);
      if (isClosed) return; // تحقق مما إذا كان Cubit قد تم إغلاقه
      if (user != null) {
        emit(UserDetalisSuccesses(details: [user]));
      } else {
        emit(UserDetalisFailure(errormess: 'User not found'));
      }
    } catch (e) {
      if (isClosed) return; // تحقق مما إذا كان Cubit قد تم إغلاقه
      printError();
      emit(UserDetalisFailure(errormess: e.toString()));
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> EditDstalis({
    required int id,
    required double costToClient,
    required String problem,
    DateTime? expectedDateOfDelivery,
    String? info,
  }) async {
    // emit(UserDetalisLoading());
    try {
      Map<String, dynamic> body = {
        'cost_to_client': costToClient,
        'expected_date_of_delivery': expectedDateOfDelivery?.toIso8601String(),
        'problem': problem,
        'info': info
      };
      //save User info
      var infoRedponse = await Api().put(
        path: 'https://haidarjaded787.serv00.net/api/users/$id',
        body: body,
      );
      if (infoRedponse == null) return;
    } catch (e) {
      // emit(UserDetalisFailure(errormess: e.toString()));
    }
  }

  // void notifyClient(Device device, double costToClient, String problem,
  //     DateTime expectedDeliveryDate) async {
  //   // هنا يتم إشعار العميل بالتفاصيل
  //   try {
  //     EditDstalis(
  //         id: device.id!,
  //         costToClient: costToClient,
  //         problem: problem,
  //         expectedDateOfDelivery: expectedDeliveryDate);
  //     await _crudController.update(device.id!, {
  //       'status': 'بانتظار استجابة العميل',
  //       'cost_to_client': costToClient,
  //       'problem': problem,
  //       'Expected_date_of_delivery': expectedDeliveryDate.toString()
  //     });
  //     print('notfication yes');
  //     // إرسال الإشعار
  //     SnackBarAlert().alert("تم ارسال اشعار للعميل انتظر الاستجابة رجاءاً",
  //         color: const Color.fromARGB(255, 4, 83, 173), title: "اشعار العميل");
  //   } catch (e) {
  //     emit(DeviceDetalisFailure(errormess: 'Error notifyclient'));
  //   }
  // }
}
