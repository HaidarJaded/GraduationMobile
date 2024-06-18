import 'package:graduation_mobile/models/has_id.dart';

class Service1 implements HasId {
  @override
  final int? id;
  static String table = "services";
  final String name;
  final String price;
  final Duration timeRequired;
  final DateTime createdAt;
  final DateTime updatedAt;

  Service1({
    this.id,
    required this.name,
    required this.price,
    required this.timeRequired,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service1.fromJson(Map<String, dynamic> json) {
    return Service1(
      id: json['id'],
      name: json['name'],
      price: json['price'].toString(),
      timeRequired: _parseTime(json['time_required']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'time_required': timeRequired.toString(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // static Duration _parseTime(String timeString) {
  //   final parts = timeString.split(':');
  //   final hours = int.parse(parts[0]);
  //   final minutes = int.parse(parts[1]);
  //   final seconds = int.parse(parts[2]);
  //   return Duration(hours: hours, minutes: minutes, seconds: seconds);
  // }
  static Duration _parseTime(String timeString) {
    // Remove any non-digit characters except for the colon
    final cleanedTimeString = timeString.replaceAll(RegExp(r'[^\d:]'), '');
    // Split the string by colon
    final parts = cleanedTimeString.split(':');
    // Parse hours, minutes, and seconds accordingly
    final hours = parts.isNotEmpty ? int.parse(parts[0]) : 0;
    final minutes = parts.length > 1 ? int.parse(parts[1]) : 0;
    final seconds = parts.length > 2 ? int.parse(parts[2]) : 0;
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }
}
