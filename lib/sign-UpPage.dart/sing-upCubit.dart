// ignore_for_file: avoid_print, file_names, non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/helper/api.dart';

enum RegistrationState { initial, loading, success, failure }

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(RegistrationState.initial);

  Future<void> register({
    required String name,
    required String lastName,
    required String address,
    required String email,
    required String password,
    required String nationalId,
    required String centerName,
    required String password_confirmation,
    required String phone,
  }) async {
    try {
      emit(RegistrationState.loading);

      final response = await Api().post(
        path: 'https://haidarjaded787.serv00.net/api/clients',
        body: {
          'center_name': centerName,
          'name': name,
          'last_name': lastName,
          'address': address,
          'email': email,
          'password': password,
          'national_id': nationalId,
          'password_confirmation': password_confirmation,
          'phone': phone
        },
      );
      // print(response.body);
      if (response != null) {
        final token = response['token'];
        final userInfoMap = response['client'];
        if (token != null && userInfoMap != null) {
          emit(RegistrationState.success);
        }
      } else {
        emit(RegistrationState.failure);
      }
    } catch (e) {
      print(e.toString());
      emit(RegistrationState.failure);
    }
  }

  void resetState() {
    emit(RegistrationState.initial);
  }
}
