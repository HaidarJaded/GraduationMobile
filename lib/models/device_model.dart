import 'package:graduation_mobile/models/client_model.dart';
import 'package:graduation_mobile/models/customer_model.dart';
import 'package:graduation_mobile/models/has_id.dart';
import 'package:graduation_mobile/models/order_model.dart';
import 'package:graduation_mobile/models/user_model.dart';

class Device implements HasId {
  @override
  int? id;
  static String table = "devices";
  String model;
  String imei;
  String code;
  int clientId;
  int? userId;
  int? customerId;
  int? clientPriority;
  String? info;
  String? problem;
  double? costToClient;
  double? costToCustomer;
  String? fixSteps;
  String status;
  int? clientApproval;
  DateTime? dateReceipt;
  DateTime? dateReceiptFromCustomer;
  DateTime? expectedDateOfDelivery;
  DateTime? clientDateWarranty;
  DateTime? customerDateWarranty;
  int? deliverToClient;
  int? deliverToCustomer;
  int? repairedInCenter;
  DateTime? createdAt;
  DateTime? updatedAt;
  Customer? customer;
  User? user;
  Client? client;
  List<Order>? orders;

  Device(
      {this.id,
      required this.model,
      this.imei = '',
      required this.code,
      required this.clientId,
      this.userId,
      this.customerId,
      this.clientPriority,
      this.info,
      this.problem,
      this.costToClient,
      this.costToCustomer,
      this.fixSteps,
      required this.status,
      this.clientApproval,
      this.dateReceipt,
      this.dateReceiptFromCustomer,
      this.expectedDateOfDelivery,
      this.clientDateWarranty,
      this.deliverToClient,
      this.deliverToCustomer,
      this.repairedInCenter,
      this.createdAt,
      this.updatedAt,
      this.customer,
      this.user,
      this.customerDateWarranty,
      this.client,
      this.orders});

  factory Device.fromJson(Map<String, dynamic> json) {
    var device = Device(
      id: json['id'],
      model: json['model'],
      imei: json['imei'] ?? '',
      code: json['code'],
      clientId: json['client_id'],
      userId: json['user_id'],
      customerId: json['customer_id'],
      clientPriority: json['client_priority'],
      info: json['info'],
      problem: json['problem'],
      costToClient: (json['cost_to_client'] as num?)?.toDouble(),
      costToCustomer: (json['cost_to_customer'] as num?)?.toDouble(),
      fixSteps: json['fix_steps'] as String?,
      status: json['status'],
      clientApproval: json['client_approval'],
      dateReceipt: DateTime.tryParse(json['date_receipt'] ?? ''),
      expectedDateOfDelivery:
          DateTime.tryParse(json['Expected_date_of_delivery'] ?? ''),
      clientDateWarranty: DateTime.tryParse(json['client_date_warranty'] ?? ''),
      customerDateWarranty:
          DateTime.tryParse(json['customer_date_warranty'] ?? ''),
      deliverToClient: json['deliver_to_client'],
      deliverToCustomer: json['deliver_to_customer'],
      repairedInCenter: json['repaired_in_center'],
      createdAt: DateTime.tryParse(json['created_at']),
      updatedAt: DateTime.tryParse(json['updated_at']),
      customer:
          json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      client: json['client'] != null ? Client.fromJson(json['client']) : null,
      orders: json['orders'] != null
          ? (json['orders'] as List).map((e) => Order.fromJson(e)).toList()
          : null,
    );
    return device;
  }

  get deviceUserName => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'imei': imei,
      'code': code,
      'client_id': clientId,
      'user_id': userId,
      'customer_id': customerId,
      'client_priority': clientPriority,
      'info': info,
      'problem': problem,
      'cost_to_client': costToClient,
      'cost_to_customer': costToCustomer,
      'fix_steps': fixSteps,
      'status': status.toString().split('.')[1],
      'client_approval': clientApproval,
      'date_receipt': dateReceipt?.toIso8601String(),
      'Expected_date_of_delivery': expectedDateOfDelivery?.toIso8601String(),
      'deliver_to_client': deliverToClient,
      'deliver_to_customer': deliverToCustomer,
      'repaired_in_center': repairedInCenter,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
