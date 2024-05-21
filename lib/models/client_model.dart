import 'package:graduation_mobile/models/rule_model.dart';

class Client {
  final int id;
  final String centerName;
  final String? phone;
  final int devicesCount;
  final String email;
  final String name;
  final String lastName;
  final String nationalId;
  final int? ruleId;
  final DateTime? emailVerifiedAt;
  final String password;
  final String address;
  final String? rememberToken;
  final bool accountActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Rule? rule;

  const Client({
    required this.id,
    required this.centerName,
    this.phone,
    required this.devicesCount,
    required this.email,
    required this.name,
    required this.lastName,
    required this.nationalId,
    this.ruleId,
    this.emailVerifiedAt,
    required this.password,
    required this.address,
    this.rememberToken,
    required this.accountActive,
    required this.createdAt,
    required this.updatedAt,
    this.rule,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'center_name': centerName,
      'phone': phone,
      'devices_count': devicesCount,
      'email': email,
      'name': name,
      'last_name': lastName,
      'national_id': nationalId,
      'rule_id': ruleId,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'password': password,
      'address': address,
      'remember_token': rememberToken,
      'account_active': accountActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'] as int,
      centerName: map['center_name'] as String,
      phone: map['phone'] as String?,
      devicesCount: map['devices_count'] as int,
      email: map['email'] as String,
      name: map['name'] as String,
      lastName: map['last_name'] as String,
      nationalId: map['national_id'] as String,
      ruleId: map['rule_id'] as int?,
      emailVerifiedAt: map['email_verified_at'] != null
          ? DateTime.parse(map['email_verified_at'] as String)
          : null,
      password: map['password'] as String,
      address: map['address'] as String,
      rememberToken: map['remember_token'] as String?,
      accountActive: map['account_active'] as bool,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      rule: map['rule'],
    );
  }
}
