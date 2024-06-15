// ignore: depend_on_referenced_packages
// ignore_for_file: unused_local_variable, unnecessary_brace_in_string_interps, avoid_print, unnecessary_import

import 'package:bloc/bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:graduation_mobile/Controllers/returned_object.dart';
import '../../Controllers/crud_controller.dart';
import '../../helper/api.dart';
import '../../models/device_model.dart';
import '../../models/has_id.dart';

part 'all_devices_state.dart';

class AllDevicesCubit<T extends HasId> extends Cubit<AllDevicesState> {
  final CrudController<Device> _crudController = CrudController<Device>();

  AllDevicesCubit() : super(AllDevicesInitial());

  Future<void> getDeviceData([Map<String, dynamic>? queryParams]) async {
    try {
      emit(AllDevicesLoading());
      ReturnedObject data = await _crudController.getAll(queryParams);

      if (data.items != null) {
        emit(AllDevicesSucces(data: data));
      } else {
        emit(AllDevicesfailure(errorMessage: 'Error: Failed to fetch data'));
      }
    } catch (e) {
      emit(AllDevicesfailure(errorMessage: 'Error: $e'));
    }
  }

  Future<void> reorderDevices(int deviceId, int newIndex, int oldIndex) async {
    if (state is AllDevicesSucces) {
      final currentState = state as AllDevicesSucces;
      final devicesList = List<Device>.from(currentState.data.items!);
      // final device = devicesList.removeAt(oldIndex);
      print('device.id  $deviceId');
      // devicesList.insert(newIndex, device);

      final newReturnedObject = ReturnedObject<Device>();
      newReturnedObject.items = devicesList.cast<Device>();

      // emit(AllDevicesSucces(data: newReturnedObject));

      try {
        emit(AllDevicesLoading());
        print(newIndex);
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }

        final response = await Api().put(
          path: 'https://haidarjaded787.serv00.net/api/devices/$deviceId',
          body: {
            'client_priority': newIndex,
          },
        );

        print(response);
        if (response == null) {
          throw Exception('Failed to update device order');
        } else {
          print('Device order updated successfully');
        }
      } catch (e) {
        print('Error: $e');
      }
    }

    // Future<void> _updateDeviceOrder(Device lastDevice, Device newDevice) async {
    //   try {
    //     emit(AllDevicesLoading());
    //     final response1 = await Api().put(
    //       path: 'https://haidarjaded787.serv00.net/api/devices/${lastDevice.id}',
    //       body: {'id': newDevice.id},
    //     );
    //     final respone2 = await Api().put(
    //         path: 'api/devices/${newDevice.id}', body: {'id': lastDevice.id});

    //     if (response1 == null) {
    //       throw Exception('Failed to update device order');
    //     } else {
    //       print('Device order updated successfully');
    //     }
    //   } catch (e) {
    //     print('Error: $e');
    //   }
    // }
  }
}
