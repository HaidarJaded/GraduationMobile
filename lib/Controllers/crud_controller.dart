// ignore_for_file: avoid_shadowing_type_parameters, equal_keys_in_map

import 'dart:async';

import 'package:graduation_mobile/Controllers/returned_object.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/check_connection.dart';
import 'package:graduation_mobile/models/client_model.dart';
import 'package:graduation_mobile/models/has_id.dart';
import 'package:graduation_mobile/models/completed_device_model.dart';
import 'package:graduation_mobile/models/customer_model.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/models/order_model.dart';
import 'package:graduation_mobile/models/permission_model.dart';
import 'package:graduation_mobile/models/user_model.dart';
import 'package:graduation_mobile/models/service_model.dart';

import '../models/notification.dart';

class CrudController<T extends HasId> {
  CrudController();

  Future<ReturnedObject<T>> getAll(Map<String, dynamic>? queryParams) async {
    try {
      if (!await CheckConnection().thereIsAnInternet()) {
        return ReturnedObject();
      }
      ReturnedObject<T> returnedData = ReturnedObject<T>();
      String? table = getTable<T>();
      final dynamic response =
          await Api().get(path: 'api/$table', queryParams: queryParams);
      final body = response['body'];
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

  Future<T?> getById(int id, Map<String, dynamic>? queryParams) async {
    if (!await CheckConnection().thereIsAnInternet()) {
      return null;
    }
    String? table = getTable<T>();
    final dynamic response =
        await Api().get(path: 'api/$table/$id', queryParams: queryParams);
    if (response == null) {
      return null;
    }
    final body = response['body'];
    final T item = _fromJson<T>(body);
    return item;
  }

  Future<T?> create(T item) async {
    try {
      if (!await CheckConnection().thereIsAnInternet()) {
        return null;
      }
      String? table = getTable<T>();
      final body = _toJson<T>(item);
      final dynamic response =
          await Api().post(path: "/api/$table", body: body);
      if (response == null) {
        return null;
      }
      T addedItem = response.containsKey('user')
          ? _fromJson<T>(response['user'])
          : response.containsKey('client')
              ? _fromJson<T>(response['client'])
              : _fromJson<T>(response);

      return addedItem;
    } catch (e) {
      return null;
    }
  }

  Future<T?> update(int id, Map<String, dynamic> body) async {
    if (!await CheckConnection().thereIsAnInternet()) {
      return null;
    }
    String? table = getTable<T>();
    final dynamic response =
        await Api().put(path: 'api/$table/$id', body: body);
    if (response != null) {
      final T updatedItem = _fromJson<T>(response);
      return updatedItem;
    }
    return null;
  }

  Future<User?> getUserDetails(int userId) async {
    try {
      final response = await Api().get(path: 'api/users/$userId');
      if (response != null && response['data'] != null) {
        return User.fromJson(response['data']);
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
    return null;
  }

  Future<void> delete(int id) async {
    if (!await CheckConnection().thereIsAnInternet()) {
      return;
    }
    String? table = getTable<T>();
    await Api().delete(path: 'api/$table', id: id);
  }

  T _fromJson<T>(Map<String, dynamic> json) {
    final modelFactories = <Type, Function>{
      Device: (json) => Device.fromJson(json),
      User: (json) => User.fromJson(json),
      CompletedDevice: (json) => CompletedDevice.fromJson(json),
      Permission: (json) => Permission.fromJson(json),
      Service1: (json) => Service1.fromJson(json),
      Order: (json) => Order.fromJson(json),
      Customer: (json) => Customer.fromJson(json),
      Client: (json) => Client.fromJson(json),
      Notification1: (json) => Notification1.fromJson(json),
      CompletedDevice: (json) => CompletedDevice.fromJson(json)
    };

    final factoryFunction = modelFactories[T];
    if (factoryFunction != null) {
      return factoryFunction(json) as T;
    }
    throw Exception('Unknown model type');
  }

  String getTable<T>() {
    final modelFactories = <Type, String>{
      Device: Device.table,
      User: User.table,
      CompletedDevice: CompletedDevice.table,
      Permission: Permission.table,
      Service1: Service1.table,
      Order: Order.table,
      Customer: Customer.table,
      Client: Client.table,
      Notification1: Notification1.table,
      CompletedDevice: CompletedDevice.table
    };

    final factoryTable = modelFactories[T];
    if (factoryTable != null) {
      return factoryTable;
    }
    throw Exception('Unknown model type');
  }

  Map<String, dynamic> _toJson<T>(T item) {
    if (item is User) {
      return (item as User).toJson();
    } else if (item is Device) {
      return (item as Device).toJson();
    } else if (item is CompletedDevice) {
      return (item as CompletedDevice).toJson();
    } else if (item is Permission) {
      return (item as Permission).toJson();
    } else if (item is Service1) {
      return (item as Service1).toJson();
    } else if (item is Order) {
      return (item as Order).toJson();
    } else if (item is Customer) {
      return (item as Customer).toJson();
    } else if (item is Client) {
      return (item as Client).toJson();
    }
    throw Exception('Unknown model type');
  }

  gebyid(Map map) {}
}
