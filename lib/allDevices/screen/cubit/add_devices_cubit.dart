// ignore_for_file: no_leading_underscores_for_local_identifiers, depend_on_referenced_packages, avoid_print, unused_local_variable, prefer_interpolation_to_compose_strings, non_constant_identifier_names

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      var body = jsonEncode({'national_id': nationalId});
      print(body);

      // var result =
      //     await Api().get(path: 'api/customers?national_id=$nationalId');
      final List<Customer>? result =
          await _crudController.getAll({'national_id': nationalId});

      if (result != null && result.isNotEmpty) {
        emit(AddDevicesFound(result: result));
      } else {
        emit(AddDevicesFailure(errorMessage: 'No data found'));
      }
    } catch (e) {
      emit(AddDevicesFailure(errorMessage: e));
    }
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var profile = jsonDecode(prefs.getString('profile')!);
    var client_id = profile['id'];
    print(client_id);
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
    print("lastnameCustomer" +
        lastnameCustomer +
        "repairedInCenter" +
        repairedInCenter +
        "nationalId" +
        nationalId);
    emit(AddDevicesSuccess());
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

