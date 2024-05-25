// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/models/order_model.dart';
import 'package:meta/meta.dart';

import '../../Controllers/returned_object.dart';
import '../../helper/snack_bar_alert.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());
  final CrudController<Order> _controller = CrudController<Order>();
  Future<void> getOrder([Map<String, dynamic>? queryParams]) async {
    try {
      emit(OrderLoading());
      ReturnedObject data = await _controller.getAll(queryParams);

      if (data.items != null) {
        emit(OrderSucess(data: data));
      } else {
        SnackBarAlert().alert('Error: Failed to fetch data');
        emit(OrderFailur(errorMessage: 'Error: Failed to fetch data'));
      }
    } catch (e) {
      emit(OrderFailur(errorMessage: 'Error: $e'));
    }
  }
}
