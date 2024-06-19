import 'package:graduation_mobile/models/has_id.dart';
import 'package:graduation_mobile/models/rule_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Client implements HasId {
  static const _clientPermissionKey = 'client_permissions';

  @override
  final int? id;
  static String table = "clients";
  final String centerName;
  final String? phone;
  final int devicesCount;
  final String email;
  final String name;
  final String lastName;
  final String nationalId;
  final int? ruleId;
  final DateTime? emailVerifiedAt;
  final String address;
  final String? rememberToken;
  final int accountActive;
  final Rule? rule;

  const Client({
    this.id,
    required this.centerName,
    this.phone,
    required this.devicesCount,
    required this.email,
    required this.name,
    required this.lastName,
    required this.nationalId,
    this.ruleId,
    this.emailVerifiedAt,
    required this.address,
    this.rememberToken,
    required this.accountActive,
    this.rule,
  });

  Map<String, dynamic> toJson() {
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
      'address': address,
      'remember_token': rememberToken,
      'account_active': accountActive,
    };
  }

  factory Client.fromJson(Map<String, dynamic> map) {
    return Client(
      id: map['id'] as int?,
      centerName: map['center_name'] as String,
      phone: map['phone'] as String?,
      devicesCount: map['devices_count'] as int,
      email: map['email'] as String,
      name: map['name'] as String,
      lastName: map['last_name'] as String,
      nationalId: map['national_id'] as String,
      ruleId: map['rule_id'] as int?,
      emailVerifiedAt: DateTime.tryParse(map['email_verified_at'] ?? ''),
      address: map['address'] as String,
      accountActive: map['account_active'] as int,
      rule: map['rule'] != null ? Rule.fromJson(map['rule']) : null,
    );
  }
  static Future<void> saveUserPermissions(List<String> permissions) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_clientPermissionKey, permissions.toList());
  }

  static Future<List<String>> getUserPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? permissions = prefs.getStringList(_clientPermissionKey);
    return permissions != null ? permissions.toList() : [];
  }

  static Future<bool> hasPermission(String permission) async {
    List<String> userPermissions = await getUserPermissions();
    return userPermissions.contains(permission);
  }
}
