import 'package:graduation_mobile/models/client_model.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/models/has_id.dart';
import 'package:graduation_mobile/models/product_model.dart';
import 'package:graduation_mobile/models/user_model.dart';

class Order implements HasId {
  @override
  int? id;
  static String table = "orders";
  String? description;
  int clientId;
  int? userId;
  DateTime date;
  int done;
  int deliverToUser;
  DateTime? createdAt;
  DateTime? updatedAt;
  Client? client;
  User? user;
  List<Device>? devices;
  List<Product>? products;
  dynamic productsOrders;
  dynamic devicesOrders;

  Order({
    this.id,
    required this.clientId,
    required this.date,
    required this.deliverToUser,
    this.description,
    required this.done,
    this.userId,
    this.user,
    this.client,
    this.createdAt,
    this.updatedAt,
    this.devices,
    this.products,
    this.devicesOrders,
    this.productsOrders,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'],
        description: json['description'],
        clientId: json['client_id'],
        userId: json['user_id'],
        date: DateTime.parse(json['date']),
        done: json['done'],
        deliverToUser: json['deliver_to_user'],
        createdAt: DateTime.tryParse(json['created_at'] ?? ''),
        updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        devices: json['devices'] != null
            ? (json['devices'] as List)
                .map((device) => Device.fromJson(device))
                .toList()
            : [],
        products: json['products'] != null
            ? (json['products'] as List)
                .map((product) => Product.fromJson(product))
                .toList()
            : [],
        devicesOrders: json['devices_orders'],
        productsOrders: json['products_orders'],
        client:
            json['client'] != null ? Client.fromJson(json['client']) : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'client_id': clientId,
      'user_id': userId,
      'date': date.toString(),
      'done': done,
      'deliver_to_user': deliverToUser,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }
}
