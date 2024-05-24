import 'package:graduation_mobile/models/has_id.dart';

class Rule implements HasId {
  @override
  final int? id;
  final String name;
  Rule({this.id, required this.name});

  factory Rule.fromJson(Map<String, dynamic> json) {
    return Rule(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    } as Map<String, dynamic>;
  }
}
