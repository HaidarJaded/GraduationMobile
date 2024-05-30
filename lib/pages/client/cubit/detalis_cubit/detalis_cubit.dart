// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/helper/api.dart';
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

  Future<void> EditDstalis({
    required int id,
    required double costToClient,
    required String problem,
    DateTime? expectedDateOfDelivery,
  }) async {
    emit(DeviceDetalisLoading());
    try {
      Map<String, dynamic> body = {
        'costToClient': costToClient,
        'problem': problem,
        'expectedDateOfDelivery': expectedDateOfDelivery?.toIso8601String(),
      };

      var response = await Api().put(
        path: 'https://haidarjaded787.serv00.net/api/devices/$id',
        body: body,
      );
      if (response != null) {
        emit(DeviceDetalisEditing());
        print('updating');
      } else {
        print('no data');
        emit(DeviceDetalisFailure(errormess: 'Error updating'));
      }
    } catch (e) {
      print('ddddddddddddddddddd $e');
      emit(DeviceDetalisFailure(errormess: e.toString()));
    }
  }
}
