// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
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

  Future<void> reorderDevices(int deviceId, int newIndex, int oldIndex) async {
    if (state is AllPhoneInCenterSuccess) {
      final currentState = state as AllPhoneInCenterSuccess;
      final devicesList = List<Device>.from(currentState.data.items!);
      final newReturnedObject = ReturnedObject<Device>();
      newReturnedObject.items = devicesList.cast<Device>();

      emit(AllPhoneInCenterLoading());
      await Api().put(
        path: 'https://haidarjaded787.serv00.net/api/devices/$deviceId',
        body: {
          'client_priority': newIndex,
        },
      );
      int? id = await InstanceSharedPrefrences().getId();
      var data = await CrudController<Device>().getAll({
        'page': 1,
        'per_page': 20,
        'orderBy': 'client_priority',
        'client_id': id,
        'with': 'customer',
        'deliver_to_client': 0,
        'repaired_in_center': 1,
        'status': 'لم يتم بدء العمل فيه'
      });
      emit(AllPhoneInCenterSuccess(data: data));
    }
  }
}
