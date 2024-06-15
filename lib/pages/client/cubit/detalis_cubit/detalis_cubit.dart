// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';

import 'detalis_state.dart';

class DeviceDetailsCubit extends Cubit<DeviceDetailsState> {
  final CrudController<Device> _crudController;

  DeviceDetailsCubit(this._crudController) : super(DeviceDetalisInitial());

  Future<void> fetchDeviceDetails(int deviceId) async {
    try {
      emit(DeviceDetalisLoading());
      final device = await _crudController.getById(deviceId, null);
      if (isClosed) return; // تحقق مما إذا كان Cubit قد تم إغلاقه
      if (device != null) {
        emit(DeviceDetalisSuccesses(details: [device]));
      } else {
        emit(DeviceDetalisFailure(errormess: 'Device not found'));
      }
    } catch (e) {
      if (isClosed) return; // تحقق مما إذا كان Cubit قد تم إغلاقه
      printError();
      emit(DeviceDetalisFailure(errormess: e.toString()));
    }
  }

  // ignore: non_constant_identifier_names
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
      } else {
        emit(DeviceDetalisFailure(errormess: 'Error updating'));
      }
    } catch (e) {
      emit(DeviceDetalisFailure(errormess: e.toString()));
    }
  }

  void notifyClient(Device device, double costToClient, String problem,
      DateTime expectedDeliveryDate) async {
    // هنا يتم إشعار العميل بالتفاصيل
    try {
      EditDstalis(
          id: device.id!,
          costToClient: costToClient,
          problem: problem,
          expectedDateOfDelivery: expectedDeliveryDate);
      await _crudController.update(device.id!, {
        'status': 'بانتظار استجابة العميل',
        'cost_to_client': costToClient,
        'problem': problem,
        'Expected_date_of_delivery': expectedDeliveryDate.toString()
      });
      print('notfication yes');
      // إرسال الإشعار
      SnackBarAlert().alert("تم ارسال اشعار للعميل انتظر الاستجابة رجاءاً",
          color: const Color.fromARGB(255, 4, 83, 173), title: "اشعار العميل");
    } catch (e) {
      emit(DeviceDetalisFailure(errormess: 'Error notifyclient'));
    }
  }
}
