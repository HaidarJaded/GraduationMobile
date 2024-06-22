// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/Controllers/returned_object.dart';
import 'package:graduation_mobile/models/completed_device_model.dart';

part 'completed_state.dart';

class CompletedCubit extends Cubit<CompletedState> {
  CompletedCubit() : super(CompletedInitial());
  final CrudController<CompletedDevice> _crudController =
      CrudController<CompletedDevice>();
  Future<void> getCompletedDeviceData(
      [Map<String, dynamic>? queryParams]) async {
    try {
      emit(CompletedLoading());
      ReturnedObject data = await _crudController.getAll(queryParams);

      
      if (data.items != null) {
        emit(CompletedSucces(data: data));
      } else {
        emit(CompletedFailure(errorMessage: 'Error: Failed to fetch data'));
      }
    } catch (e) {
      emit(CompletedFailure(errorMessage: 'Error: $e'));
    }
  }
}
