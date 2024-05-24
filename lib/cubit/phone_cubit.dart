// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';

import '../Controllers/crud_controller.dart';
import '../models/device_model.dart';

part 'phone_state.dart';

final CrudController<Device> _crudController = CrudController<Device>();

class PhoneCubit extends Cubit<PhoneState> {
  PhoneCubit() : super(PhoneInitial());

  Future<void> getDevicesByUserId(int userId) async {
    emit(PhoneLoading());
    try {
      final List<Device>? allDevices =
          (await _crudController.getAll({'userId': userId})).items;

      if (allDevices != null) {
        final List<Device> userDevices =
            allDevices.where((device) => device.userId == userId).toList();
        emit(PhoneSuccess(device: userDevices));
      } else {
        emit(PhoneFailure(errorMessage: 'Failed to fetch data'));
      }
    } catch (e) {
      print('Error in getDevicesByUserId: $e');
      emit(PhoneFailure(errorMessage: 'Failed to fetch data'));
    }
  }
}
