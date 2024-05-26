// ignore_for_file: avoid_shadowing_type_parameters

import '../Controllers/returned_object.dart';
import '../helper/api.dart';
import '../models/customer_model.dart';
import '../models/device_model.dart';
import '../models/has_id.dart';

class CrudControllertest<T extends HasId> {
  CrudControllertest();

  Future<ReturnedObject<T>> getAllwithCustomr(
      Map<String, dynamic>? queryParams) async {
    try {
      ReturnedObject<T> returnedData = ReturnedObject<T>();

      final dynamic response =
          await Api().get(path: 'api/devices', queryParams: queryParams);
      final body = response['body']['customer'];
      if (body is List) {
        final items = body.map((itemData) => _fromJson<T>(itemData)).toList();
        returnedData.items = items.cast<T>();
        returnedData.pagination = response['pagination'];
        return returnedData;
      } else {
        return returnedData;
      }
    } catch (e) {
      return ReturnedObject<T>();
    }
  }

  T _fromJson<T>(Map<String, dynamic> json) {
    final modelFactories = <Type, Function>{
      Device: (json) => Device.fromJson(json),
      Customer: (json) => Customer.fromJson(json),
    };
    final factoryFunction = modelFactories[T];
    if (factoryFunction != null) {
      return factoryFunction(json) as T;
    }
    throw Exception('Unknown model type');
  }
}
