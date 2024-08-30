// ignore_for_file: non_constant_identifier_names, file_names, camel_case_types

import 'package:graduation_mobile/models/client_model.dart';
import 'package:graduation_mobile/models/has_id.dart';

class allNotification implements HasId {
  @override
  int? id;
  String? StringId;
  static String table = "notifications";
  String? title;
  List? body;
  String? notifiable_name;
  String? notifiable_type;
  DateTime? read_at;
  DateTime? created_at;
  Client? client;
  allNotification(
      {this.id,
      this.title,
      this.body,
      this.notifiable_name,
      this.notifiable_type,
      this.read_at,
      this.StringId,
      this.created_at});
  factory allNotification.fromJson(Map<String, dynamic> json) {
    var notification = allNotification(
      StringId: json['id'],
      title: json['title'],
      body: json['body'],
      notifiable_name: json['notifiable_name'],
      notifiable_type: json['notifiable_type'],
      read_at: DateTime.tryParse(json['read_at'] ?? ''),
      created_at: DateTime.tryParse(json['created_at'] ?? ''),
    );
    return notification;
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'notifiable_name': notifiable_name,
      'notifiable_type': notifiable_type,
      'read_at': read_at?.toIso8601String(),
      'created_at': created_at?.toIso8601String()
    };
  }
}
