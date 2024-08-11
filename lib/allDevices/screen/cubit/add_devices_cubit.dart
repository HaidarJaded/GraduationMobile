// ignore_for_file: no_leading_underscores_for_local_identifiers, depend_on_referenced_packages, avoid_print, unused_local_variable, prefer_interpolation_to_compose_strings, non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';

import 'package:meta/meta.dart';
import '../../../Controllers/crud_controller.dart';
import '../../../helper/api.dart';
import '../../../models/customer_model.dart';

part 'add_devices_state.dart';

class AddDevicesCubit extends Cubit<AddDevicesState> {
  AddDevicesCubit() : super(AddDevicesInitial());
  Future<dynamic> checkIfCustomerExists({required String customerPhone}) async {
    final CrudController<Customer> _crudController = CrudController<Customer>();

    emit(AddDevicesLoading());

    try {
      int? clientId = await InstanceSharedPrefrences().getId();
      final List<Customer>? result = (await _crudController.getAll({
        'phone': customerPhone,
        'client_id': clientId,
      }))
          .items;

      if (result != null && result.isNotEmpty) {
        emit(AddDevicesFound(result: result));
      } else {
        emit(AddDevicesFailure(errorMessage: 'No data found'));
      }
    } catch (e) {
      emit(AddDevicesFailure(errorMessage: e));
    }
    Get.back();
  }

  Future<dynamic> addNewDevicewithNewCustomer({
    required String firstnameCustomer,
    required String lastnameCustomer,
    required String phone,
    required String nationalId,
    required String model,
    required String imei,
    required String info,
    required repairedInCenter,
    required String customerComplaint,
  }) async {
    emit(AddDevicesLoading());
    var client_id = await InstanceSharedPrefrences().getId();
    var respons = await Api().post(path: '/api/devices/with_customer', body: {
      'name': firstnameCustomer,
      'last_name': lastnameCustomer,
      'phone': phone,
      'national_id': nationalId,
      'model': model,
      'imei': imei,
      'info': info,
      'client_id': client_id.toString(),
      'repaired_in_center': repairedInCenter.toString(),
      'customer_complaint': customerComplaint
    });
    if (respons != null) {
      emit(AddDevicesSuccess(
          deviceId: respons['device']?['id'],
          isRepairedInCenter: repairedInCenter == '1'));
    } else {
      emit(AddDevicesFailure(errorMessage: "Failed adding"));
    }
    Get.back();
  }

  Future<dynamic> addNewDevice(
      {required String model,
      required String imei,
      required String info,
      required String customerComplaint,
      required repairedInCenter,
      required int cusomer_id}) async {
    emit(AddDevicesLoading());
    var client_id = await InstanceSharedPrefrences().getId();

    var respons = await Api().post(path: '/api/devices', body: {
      'model': model,
      'imei': imei,
      'info': info,
      'client_id': client_id.toString(),
      'repaired_in_center': repairedInCenter.toString(),
      'customer_id': cusomer_id.toString(),
      'customer_complaint': customerComplaint
    });

    if (respons != null) {
      emit(AddDevicesSuccess(
          deviceId: respons['id'],
          isRepairedInCenter: repairedInCenter == '1'));
    } else {
      emit(AddDevicesFailure(errorMessage: "Failed adding"));
    }
    Get.back();
  }

  void resetState() {
    emit(AddDevicesInitial());
  }
}
  