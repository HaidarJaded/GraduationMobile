// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';

import 'detalis_state.dart';

class DeviceDetailsCubit extends Cubit<DeviceDetailsState> {
  final CrudController<Device> crudController;

  DeviceDetailsCubit(this.crudController) : super(DeviceDetalisInitial());

  Future<void> fetchDeviceDetails(int deviceId) async {
    try {
      emit(DeviceDetalisLoading());
      final device = await crudController.getById(deviceId, null);
      if (isClosed) return; // تحقق مما إذا كان Cubit قد تم إغلاقه
      if (device != null) {
        emit(DeviceDetalisSuccesses(details: [device]));
        print('devices $device');
      } else {
        print('Device not found');
        emit(DeviceDetalisFailure(errormess: 'Device not found'));
      }
    } catch (e) {
      if (isClosed) return; // تحقق مما إذا كان Cubit قد تم إغلاقه
      print('error:');
      printError();
      emit(DeviceDetalisFailure(errormess: e.toString()));
    }
  }
}
