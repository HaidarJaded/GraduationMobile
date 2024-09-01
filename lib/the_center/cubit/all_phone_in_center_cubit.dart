// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:meta/meta.dart';

import '../../Controllers/returned_object.dart';
import '../../models/device_model.dart';

part 'all_phone_in_center_state.dart';

class AllPhoneInCenterCubit extends Cubit<AllPhoneInCenterState> {
  AllPhoneInCenterCubit() : super(AllPhoneInCenterInitial());
  final CrudController<Device> _crudController = CrudController<Device>();
  Future<void> getDeviceData([Map<String, dynamic>? queryParams]) async {
    try {
      emit(AllPhoneInCenterLoading());
      ReturnedObject data = await _crudController.getAll(queryParams);

      if (data.items != null) {
        emit(AllPhoneInCenterSuccess(data: data));
      } else {
        emit(AllPhoneInCenterFailuer(
            errorMessage: 'Error: Failed to fetch data'));
      }
    } catch (e) {
      emit(AllPhoneInCenterFailuer(errorMessage: 'Error: $e'));
    }
  }

  Future<void> reorderDevices(
      int deviceId, int newIndex, int oldIndex, devic) async {
    if (state is AllPhoneInCenterSuccess) {
      final currentState = state as AllPhoneInCenterSuccess;
      final devicesList = List<Device>.from(currentState.data.items!);
      final newReturnedObject = ReturnedObject<Device>();
      newReturnedObject.items = devicesList.cast<Device>();

  Future<bool> reorderDevices(int deviceId, int newPriority) async {
      emit(AllPhoneInCenterLoading());
      var response = await Api().put(
        path: 'https://haidarjaded787.serv00.net/api/devices/$deviceId',
        body: {
          'client_priority': newPriority,
        },
      );
      if (response == null) {
        emit(AllPhoneInCenterFailuer(errorMessage: 'cannot update'));
        return false;
      }
      emit(AllPhoneInCenterUpdated());
      return true;
  }
}
