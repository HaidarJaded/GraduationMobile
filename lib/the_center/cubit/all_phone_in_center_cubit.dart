// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
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
}
