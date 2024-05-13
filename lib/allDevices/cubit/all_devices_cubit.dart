// ignore: depend_on_referenced_packages
// ignore_for_file: unused_local_variable

import 'package:bloc/bloc.dart';

import '../../Controllers/crud_controller.dart';
import '../../models/device_model.dart';
import '../../models/has_id.dart';

part 'all_devices_state.dart';

class AllDevicesCubit<T extends HasId> extends Cubit<AllDevicesState> {
  void reorderDevices(int oldIndex, int newIndex) {
    if (state is AllDevicesSucces) {
      final currentState = state as AllDevicesSucces;
      final devicesList = List<Device>.from(currentState.device);
      final device = devicesList.removeAt(oldIndex);
      devicesList.insert(newIndex, device);
      final i = newIndex > oldIndex ? newIndex - 1 : newIndex;
      emit(AllDevicesSucces(device: devicesList));
    }
  }

  final CrudController<Device> _crudController = CrudController<Device>();

  AllDevicesCubit() : super(AllDevicesInitial());

  Future<void> getDeviceData() async {
    try {
      final List<Device>? data = await _crudController.getAll({});
      if (data != null) {
        emit(AllDevicesSucces(device: data));
      } else {
        emit(AllDevicesfailure(errorMessage: 'Error: Failed to fetch data'));
      }
    } catch (e) {
      emit(AllDevicesfailure(errorMessage: 'Error: $e'));
    }
  }
}
