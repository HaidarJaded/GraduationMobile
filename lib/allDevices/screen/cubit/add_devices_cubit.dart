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
  Future<dynamic> checkNationalId({required String nationalId}) async {
    final CrudController<Customer> _crudController = CrudController<Customer>();

    emit(AddDevicesLoading());

    try {
      final List<Customer>? result =
          (await _crudController.getAll({'national_id': nationalId})).items;

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

  Future<dynamic> addNewDevicewithNewCustomer(
      {required String firstnameCustomer,
      required String lastnameCustomer,
      required String email,
      required String phone,
      required String nationalId,
      required String model,
      required String imei,
      required String info,
      required repairedInCenter}) async {
    emit(AddDevicesLoading());
    var client_id = await InstanceSharedPrefrences().getId();
    var respons = await Api().post(path: '/api/devices/with_customer', body: {
      'name': firstnameCustomer,
      'last_name': lastnameCustomer,
      'email': email,
      'phone': phone,
      'national_id': nationalId,
      'model': model,
      'imei': imei,
      'info': info,
      'client_id': client_id.toString(),
      'repaired_in_center': repairedInCenter.toString()
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
      required repairedInCenter,
      required int cusomer_id}) async {
    print("loading");
    emit(AddDevicesLoading());
    var client_id = await InstanceSharedPrefrences().getId();
    print(client_id);
    var respons = await Api().post(path: '/api/devices', body: {
      'model': model,
      'imei': imei,
      'info': info,
      'client_id': client_id.toString(),
      'repaired_in_center': repairedInCenter.toString(),
      'customer_id': cusomer_id.toString()
    });
    print('respons' + respons.toString());
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
  
//   Future<void> customeringo() async {
//     try {
//       final List<Customer>? data = await _crudController.getAll({});
//       if (data != null) {
//         emit(AddDevicesSuccsss(customerinfo: data));
//       } else {
//         emit(AddDevicesFailure(errorMessage: 'Error: Failed to fetch data'));
//       }
//     } catch (e) {
//       emit(AddDevicesFailure(
//         errorMessage: 'Error: $e',
//       ));
//     }
//   }
// }

