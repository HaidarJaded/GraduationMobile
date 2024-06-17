// ignore_for_file: depend_on_referenced_packages, avoid_print, empty_catches

import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/models/order_model.dart';
import 'package:meta/meta.dart';
import '../../Controllers/crud_controller.dart';
import '../../Controllers/returned_object.dart';
part 'delivery_man_state.dart';

class DeliveryManCubit extends Cubit<DeliveryManState> {
  final CrudController<Order> _crudController = CrudController<Order>();
  DeliveryManCubit() : super(DeliveryManInitial());
  Future<void> getorderData([Map<String, dynamic>? queryParams]) async {
    try {
      emit(DeliveryManLoading());
      ReturnedObject data = await _crudController.getAll(queryParams);
      if (data.items != null) {
        emit(DeliveryManSucces(data: data));
        print(data);
      } else {
        emit(DeliveryManFailuer(errorMessage: 'Error: Failed to fetch data'));
      }
    } catch (e) {
      emit(DeliveryManFailuer(errorMessage: 'Error: $e'));
    }
  }

  Future<dynamic> allOrdersClient(int id,
      [Map<String, dynamic>? queryParams]) async {
    try {
      emit(DeliveryManLoading());
      final Order? result = await _crudController.getById(id, {});
      if (result != null) {}
    } catch (e) {}
  }
}
