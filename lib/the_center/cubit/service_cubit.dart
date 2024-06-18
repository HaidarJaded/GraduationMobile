// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/Controllers/returned_object.dart';
import 'package:graduation_mobile/models/service_model.dart';
import 'package:meta/meta.dart';

import '../../Controllers/crud_controller.dart';

part 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  final CrudController<Service1> _crudController = CrudController<Service1>();
  ServiceCubit() : super(ServiceInitial());
  Future<void> getServicData([Map<String, dynamic>? queryParams]) async {
    try {
      emit(ServiceLoading());
      ReturnedObject data = await _crudController.getAll(queryParams);
      print(data.items);
      if (data.items != null) {
        emit(ServiceSucces(data: data));
      } else {
        emit(ServiceFailuer(errorMessage: 'Error: Failed to fetch data'));
      }
    } catch (e) {
      emit(ServiceFailuer(errorMessage: 'Error: $e'));
    }
  }
}
