import 'package:graduation_mobile/models/client_model.dart';
import 'package:graduation_mobile/models/customer_model.dart';
import 'package:graduation_mobile/models/has_id.dart';
import 'package:graduation_mobile/models/user_model.dart';

class CompletedDevice implements HasId {
  @override
  final int? id;
  static String table = "completed_devices";
  final String model;
  final String? imei;
  final String code;
  final int? clientId;
  final String clientName;
  final int? userId;
  final String userName;
  final int? customerId;
  final String? info;
  final String problem;
  final double? costToClient;
  final double? costToCustomer;
  final String status;
  final String? fixSteps;
  final int deliverToClient;
  final int deliverToCustomer;
  final DateTime? dateReceipt;
  final DateTime? dateDelivery;
  final DateTime? dateWarranty;
  final int repairedInCenter;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Client? client;
  final User? user;
  final Customer? customer;

  CompletedDevice({
    this.id,
    required this.model,
    this.imei,
    required this.code,
    this.clientId,
    required this.clientName,
    this.userId,
    required this.userName,
    this.customerId,
    this.info,
    required this.problem,
    this.costToClient,
    this.costToCustomer,
    required this.status,
    this.fixSteps,
    this.deliverToClient = 1,
    this.deliverToCustomer = 0,
    this.dateReceipt,
    this.dateDelivery,
    this.dateWarranty,
    required this.repairedInCenter,
    required this.createdAt,
    required this.updatedAt,
    this.client,
    this.user,
    this.customer,
  });

  factory CompletedDevice.fromJson(Map<String, dynamic> json) {
    return CompletedDevice(
      id: json['id'],
      model: json['model'],
      imei: json['imei'],
      code: json['code'],
      clientId: json['client_id'],
      clientName: json['client_name'],
      userId: json['user_id'],
      userName: json['user_name'],
      customerId: json['customer_id'],
      info: json['info'],
      problem: json['problem'],
      costToClient: (json['cost_to_client'] as num?)!.toDouble(),
      costToCustomer: (json['cost_to_customer'] as num?)!.toDouble(),
      status: json['status'],
      fixSteps: json['fix_steps'],
      deliverToClient: json['deliver_to_client'],
      deliverToCustomer: json['deliver_to_customer'],
      dateReceipt: DateTime.tryParse(json['date_receipt'] ?? ''),
      dateDelivery: DateTime.tryParse(json['date_delivery'] ?? ''),
      dateWarranty: DateTime.tryParse(json['date_warranty'] ?? ''),
      repairedInCenter: json['repaired_in_center'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      customer:
          json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      client: json['client'] != null ? Client.fromJson(json['client']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'imei': imei,
      'code': code,
      'client_id': clientId,
      'client_name': clientName,
      'user_id': userId,
      'user_name': userName,
      'customer_id': customerId,
      'info': info,
      'problem': problem,
      'cost_to_client': costToClient,
      'cost_to_customer': costToCustomer,
      'status': status,
      'fix_steps': fixSteps,
      'deliver_to_client': deliverToClient,
      'deliver_to_customer': deliverToCustomer,
      'date_receipt': dateReceipt?.toIso8601String(),
      'date_delivery': dateDelivery?.toIso8601String(),
      'date_warranty': dateWarranty?.toIso8601String(),
      'repaired_in_center': repairedInCenter,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
