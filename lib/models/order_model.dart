import 'package:graduation_mobile/models/client_model.dart';
import 'package:graduation_mobile/models/has_id.dart';
import 'package:graduation_mobile/models/user_model.dart';

class Order implements HasId {
  @override
  int? id;
  static String table = "orders";
  int deviceId;
  int orderId;
  int? serviceId;
  String info;
  String orderType;
  int deliverToClient;
  int deliverToUser;
  String? deliverTime;
  String createdAt;
  String updatedAt;
  Client? client;
  User? user;

  Order({
    required this.id,
    required this.deviceId,
    required this.orderId,
    required this.info,
    required this.orderType,
    required this.deliverToClient,
    required this.deliverToUser,
    this.serviceId,
    this.deliverTime,
    required this.createdAt,
    required this.updatedAt,
    this.client,
    this.user,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      deviceId: json['device_id'],
      orderId: json['order_id'],
      serviceId: json['service_id'],
      info: json['info'],
      orderType: json['order_type'],
      deliverToClient: json['deliver_to_client'],
      deliverToUser: json['deliver_to_user'],
      deliverTime: json['deliver_time'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      client: json['client'] != null ? Client.fromJson(json['client']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'order_id': orderId,
      'service_id': serviceId,
      'info': info,
      'order_type': orderType,
      'deliver_to_client': deliverToClient,
      'deliver_to_user': deliverToUser,
      'deliver_time': deliverTime,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
