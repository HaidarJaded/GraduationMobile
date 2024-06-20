// ignore_for_file: unused_element

import 'package:graduation_mobile/models/has_id.dart';

class Product implements HasId {
  @override
  int? id;
  static String table = "products";
  String name;
  double price;
  String quantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'].toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

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
