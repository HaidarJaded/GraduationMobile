import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/models/has_id.dart';
import 'package:graduation_mobile/models/permission_model.dart';
import 'package:graduation_mobile/models/rule_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User implements HasId {
  static const _userPermissionKey = 'user_permissions';
  @override
  final int? id;
  static String table = 'users';
  final String email;
  final String name;
  final String lastName;
  final DateTime? emailVerifiedAt;
  final int? ruleId;
  final String phone;
  final String? address;
  final int atWork;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? password;
  final String? passwordConfirmation;
  final List<Device>? devices;
  final List<Permission>? permissions;
  final Rule? rule;

  User(
      {this.id,
      required this.email,
      required this.name,
      required this.lastName,
      this.emailVerifiedAt,
      required this.ruleId,
      required this.phone,
      this.address,
      this.atWork = 0,
      this.createdAt,
      this.updatedAt,
      this.devices,
      this.rule,
      this.permissions,
      this.password,
      this.passwordConfirmation});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      lastName: json['last_name'] ?? '',
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      ruleId: json['rule_id'] != null
          ? int.tryParse(json['rule_id'].toString())
          : 0,
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      atWork:
          json['at_work'] != null ? int.parse(json['at_work'].toString()) : 0,
      createdAt: DateTime.parse(
          json['created_at']?.toString() ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(
          json['updated_at']?.toString() ?? DateTime.now().toString()),
      devices: (json['devices'] as List<dynamic>?)
              ?.map((deviceData) => Device.fromJson(deviceData))
              .toList() ??
          [],
      rule: json['rule'] != null ? Rule.fromJson(json['rule']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'last_name': lastName,
      'rule_id': ruleId.toString(),
      'phone': phone,
      'address': address ?? "",
      'at_work': atWork.toString(),
      'password_confirmation': passwordConfirmation ?? "",
      'password': password ?? ""
    } as Map<String, dynamic>;
  }

  static Future<void> saveUserPermissions(List<String> permissions) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_userPermissionKey, permissions.toList());
  }

  static Future<List<String>> getUserPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? permissions = prefs.getStringList(_userPermissionKey);
    return permissions != null ? permissions.toList() : [];
  }

  static Future<bool> hasPermission(String permission) async {
    List<String> userPermissions = await getUserPermissions();
    return userPermissions.contains(permission);
  }
}
