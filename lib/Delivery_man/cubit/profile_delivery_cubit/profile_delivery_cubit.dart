// ignore_for_file: avoid_print, unused_field
import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/Delivery_man/cubit/profile_delivery_cubit/profile_delivery_state.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/models/user_model.dart';

class DeliveryDetailsCubit extends Cubit<DeliveryDetailsState> {
  final CrudController<User> _crudController;

  DeliveryDetailsCubit(this._crudController) : super(DeliveryDetalisInitial());

  Future<void> fetchProfileDetails(int userId) async {
    try {
      emit(DeliveryDetalisLoading());
      final user = await Api().get(path: 'api/users/$userId');
      // final user = await _crudController.getById(userId, null);
      if (isClosed) return; // تحقق مما إذا كان Cubit قد تم إغلاقه
      if (user != null) {
        print(user);
        emit(DeliveryDetalisSuccesses(details: [user]));
      } else {
        emit(DeliveryDetalisFailure(errormess: 'User not found'));
      }
    } catch (e) {
      if (isClosed) return; // تحقق مما إذا كان Cubit قد تم إغلاقه
      printError();
      print(e);
      emit(DeliveryDetalisFailure(errormess: e.toString()));
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> EditData({
    required int id,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      Map<String, dynamic> body = {
        'email': email,
        'password': password,
        'phone': phone
      };
      var infoRedponse = await Api().put(
        path: 'https://haidarjaded787.serv00.net/api/users/$id',
        body: body,
      );
      if (infoRedponse == null) return;
    } catch (e) {
      print(e);
    }
  }
}
