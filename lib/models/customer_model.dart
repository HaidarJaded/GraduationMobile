import 'package:graduation_mobile/models/client_model.dart';
import 'package:graduation_mobile/models/has_id.dart';

class Customer implements HasId {
  @override
  int? id;
  static String table = "customers";
  String name;
  String lastName;
  String nationalId;
  int clientId;
  String phone;
  String? email;
  int devicesCount;
  String createdAt;
  String updatedAt;
  Client? client;

  Customer({
    required this.id,
    required this.name,
    required this.lastName,
    required this.nationalId,
    required this.clientId,
    required this.phone,
    this.email,
    required this.devicesCount,
    required this.createdAt,
    required this.updatedAt,
    this.client,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      lastName: json['last_name'],
      nationalId: json['national_id'],
      clientId: json['client_id'],
      phone: json['phone'],
      email: json['email'],
      devicesCount: json['devices_count'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      client: json['client'] != null ? Client.fromJson(json['client']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'last_name': lastName,
      'national_id': nationalId,
      'client_id': clientId,
      'phone': phone,
      'email': email,
      'devices_count': devicesCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
