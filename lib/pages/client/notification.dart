// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

@immutable
class NotificationScreen extends StatelessWidget {
  final List<String> notifications = ['jgvjgg'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 4.0,
              child: ListTile(
                title: Text(notifications[index]),
                leading: const CircleAvatar(
                  child: Icon(Icons.notifications),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // يمكنك إضافة رمزية لحذف الإشعار هنا
                    // يمكنك تنفيذ الطريقة التي تفضلها لحذف الإشعار
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notification deleted')),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
