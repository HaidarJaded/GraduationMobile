// ignore_for_file: depend_on_referenced_packages, avoid_print

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
      print(1);
      emit(DeliveryManLoading());
      print(2);
      ReturnedObject data = await _crudController.getAll(queryParams);
      print(data.items);
      if (data.items != null) {
        emit(DeliveryManSucces(data: data));
      } else {
        emit(DeliveryManFailuer(errorMessage: 'Error: Failed to fetch data'));
      }
    } catch (e) {
      emit(DeliveryManFailuer(errorMessage: 'Error: $e'));
    }
  }
}
