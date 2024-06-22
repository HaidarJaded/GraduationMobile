// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/models/product_model.dart';
import 'package:meta/meta.dart';

import '../../Controllers/crud_controller.dart';
import '../../Controllers/returned_object.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final CrudController<Product> _crudController = CrudController<Product>();
  ProductCubit() : super(ProductInitial());
  Future<void> getProductData([Map<String, dynamic>? queryParams]) async {
    try {
      emit(ProductLoading());
      ReturnedObject data = await _crudController.getAll(queryParams);
      
      if (data.items != null) {
        emit(ProductSucces(data: data));
      } else {
        emit(ProductFailure(errorMessage: 'Error: Failed to fetch data'));
      }
    } catch (e) {
      emit(ProductFailure(errorMessage: 'Error: $e'));
    }
  }
}
