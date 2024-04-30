import 'package:graduation_mobile/models/has_id.dart';

class Device implements HasId {

  @override
  int? id;
    static String table="devices";
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
  DateTime dateReceipt;
  DateTime? expectedDateOfDelivery;
  int? deliverToClient;
  int? deliverToCustomer;
  int? repairedInCenter;
  DateTime createdAt;
  DateTime updatedAt;


  Device({
    this.id,
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
    required this.dateReceipt,
    this.expectedDateOfDelivery,
    this.deliverToClient,
    this.deliverToCustomer,
    this.repairedInCenter,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
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
      costToClient: json['cost_to_client'],
      costToCustomer: json['cost_to_customer'],
      fixSteps: json['fix_steps'],
      status: json['status'],
      clientApproval: json['client_approval'],
      dateReceipt: DateTime.parse(json['date_receipt']),
      expectedDateOfDelivery: json['Expected_date_of_delivery'] != null
          ? DateTime.parse(json['Expected_date_of_delivery'])
          : null,
      deliverToClient: json['deliver_to_client'],
      deliverToCustomer: json['deliver_to_customer'],
      repairedInCenter: json['repaired_in_center'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

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
      'date_receipt': dateReceipt.toIso8601String(),
      'Expected_date_of_delivery': expectedDateOfDelivery?.toIso8601String(),
      'deliver_to_client': deliverToClient,
      'deliver_to_customer': deliverToCustomer,
      'repaired_in_center': repairedInCenter,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }


}
