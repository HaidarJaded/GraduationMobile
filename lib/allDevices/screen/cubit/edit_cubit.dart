// ignore_for_file: unused_field, depend_on_referenced_packages, no_leading_underscores_for_local_identifiers, avoid_print, unnecessary_null_comparison, unnecessary_brace_in_string_interps, prefer_adjacent_string_concatenation

import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';

import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:meta/meta.dart';

part 'edit_state.dart';

class EditCubit extends Cubit<EditState> {
  EditCubit() : super(EditInitial());

  Future<dynamic> exitIdDevice({required int id}) async {
    final CrudController<Device> _crudController = CrudController<Device>();
    emit(Editloading());
    try {
      final Device? result = await _crudController.getById(id, {});

      if (result != null) {
        emit(EditFound(editDevicesDatat: result));
      } else {
        emit(EditFailur(errMessage: "something Wrong"));
      }
    } catch (e) {
      emit(EditFailur(errMessage: e.toString()));
    }
  }

  Future<bool> editDevice({
    required int id,
    required String model,
    required String imei,
    required String info,
  }) async {
    emit(Editloading());
    try {
      Map<String, dynamic> body = {};
      if (model != null && model.isNotEmpty) {
        body['model'] = model;
      }
      if (info != null && info.isNotEmpty) {
        body['info'] = info;
      }
      if (imei != null && imei.isNotEmpty) {
        body['imei'] = imei;
      }
      if (body.isEmpty) {
        return true;
      }
      var response = await Api().put(
        path: 'https://haidarjaded787.serv00.net/api/devices/$id',
        body: body,
      );

      if (response == null) {
        return false;
        // emit(EditSuccess());
      }
      return true;
      // //  else {
      //   emit(EditFailur(errMessage: "somethingWrong"));
      // }
      //  else {
      //   emit(EditFailur(errMessage: "No data to update"));
      // }
    } catch (e) {
      return false;
      // emit(EditFailur(errMessage: e.toString()));
    }
  }

  Future<dynamic> editCustomer({
    required int id,
    required String name,
    required String lastName,
    required String email,
    required String phone,
    required String natonalId,
  }) async {
    emit(Editloading());
    try {
      Map<String, dynamic> body = {};
      if (name != null && name.isNotEmpty) {
        body['name'] = name;
      }
      if (lastName != null && lastName.isNotEmpty) {
        body['lastName'] = lastName;
      }
      if (email != null && email.isNotEmpty) {
        body['email'] = email;
      }
      if (phone != null && phone.isNotEmpty) {
        body['phone'] = phone;
      }

      if (body.isNotEmpty) {
        var response = await Api().put(
          path: 'https://haidarjaded787.serv00.net/api/cutome/$id',
          body: body,
        );

        if (response != null) {
          emit(EditSuccess());
        } else {
          emit(EditFailur(errMessage: "somethingWrong"));
        }
      } else {
        emit(EditFailur(errMessage: "No data to update"));
      }
    } catch (e) {
      emit(EditFailur(errMessage: e.toString()));
    }
  }
}
