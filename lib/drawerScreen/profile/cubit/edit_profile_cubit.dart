// ignore_for_file: unnecessary_null_comparison

import 'package:bloc/bloc.dart';

import '../../../helper/api.dart';
import '../../../helper/shared_perferences.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());
  Future<dynamic> editClients({
    required String phone,
    required String centerName,
    required String address,
  }) async {
    int? id = await InstanceSharedPrefrences().getId();
    emit(EditProfileLoading());
    try {
      Map<String, dynamic> body = {};
      // إضافة القيم إلى الجسم فقط إذا كانت موجودة وغير فارغة
      if (phone != null && phone.isNotEmpty) {
        body['phone'] = phone;
      }
      if (centerName != null && centerName.isNotEmpty) {
        body['center_name'] = centerName;
      }
      if (address != null && address.isNotEmpty) {
        body['address'] = address;
      }

      if (body.isNotEmpty) {
        var response = await Api().put(
          path: 'https://haidarjaded787.serv00.net/api/clients/$id',
          body: body,
        );

        print("id" + ' ${id}');
        print(response);

        if (response != null) {
          emit(EditProfileSucess());
        } else {
          emit(EditProfileFailure(errorMessage: "somethingWrong"));
        }
      } else {
        print("No data to update");
        emit(EditProfileFailure(errorMessage: "No data to update"));
      }
    } catch (e) {
      print(e);
      emit(EditProfileFailure(errorMessage: e.toString()));
    }
  }
}
