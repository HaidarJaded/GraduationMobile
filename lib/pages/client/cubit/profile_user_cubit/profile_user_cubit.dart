// ignore_for_file: avoid_print, unused_field
import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/pages/client/cubit/profile_user_cubit/profile_user_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  // final CrudController<User> _crudController;

  UserDetailsCubit(/*this._crudController*/) : super(UserDetalisInitial());

  // Future<void> fetchProfileDetails(int userId) async {
  //   try {
  //     emit(UserDetalisLoading());
  //     final user = await _crudController.getById(userId, null);
  //     if (isClosed) return; // تحقق مما إذا كان Cubit قد تم إغلاقه
  //     if (user != null) {
  //       print(user);
  //       emit(UserDetalisSuccesses(details: [user]));
  //     } else {
  //       emit(UserDetalisFailure(errormess: 'User not found'));
  //     }
  //   } catch (e) {
  //     if (isClosed) return; // تحقق مما إذا كان Cubit قد تم إغلاقه
  //     printError();
  //     print(e);
  //     emit(UserDetalisFailure(errormess: e.toString()));
  //   }
  // }

  // ignore: non_constant_identifier_names
  Future<void> EditData({
    int? id,
    required String email,
    // required String password,
    required String phone,
  }) async {
    try {
      Map<String, dynamic> body = {
        'email': email,
        // 'password': password,
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
