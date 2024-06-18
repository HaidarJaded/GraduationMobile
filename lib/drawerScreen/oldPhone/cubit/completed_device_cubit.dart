// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/models/completed_device_model.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

import '../../../Controllers/crud_controller.dart';
import '../../../Controllers/returned_object.dart';

part 'completed_device_state.dart';

class CompletedDeviceCubit extends Cubit<CompletedDeviceState> {
  CompletedDeviceCubit() : super(CompletedDeviceInitial());
  final CrudController<CompletedDevice> _crudController =
      CrudController<CompletedDevice>();
  Future<void> getCompletedDeviceData(
      [Map<String, dynamic>? queryParams]) async {
    try {
      emit(CompletedDeviceLoading());
      ReturnedObject data = await _crudController.getAll(queryParams);

      print(data.items);
      if (data.items != null) {
        emit(CompletedDeviceSucces(data: data));
      } else {
        emit(CompletedDeviceFailure(
            errorMessage: 'Error: Failed to fetch data'));
      }
    } catch (e) {
      emit(CompletedDeviceFailure(errorMessage: 'Error: $e'));
    }
  }
}
