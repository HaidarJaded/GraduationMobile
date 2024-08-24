import 'package:flutter/material.dart';
import 'package:graduation_mobile/models/client_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientInfoCard extends StatelessWidget {
  final Client client;
  const ClientInfoCard({super.key, required this.client});

  void _makePhoneCall(String phone) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('بيانات العميل'),
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: ListBody(children: [
          const SizedBox(height: 10.0),
          Text('الاسم: ${client.name} ${client.lastName}'),
          Text('الرقم الوطني: ${client.nationalId}'),
          if (client.phone != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('رقم الهاتف: ${client.phone}'),
                if (client.phone != null)
                  IconButton(
                    icon: const Icon(Icons.call),
                    color: Colors.green,
                    onPressed: () => _makePhoneCall(client.phone!),
                  ),
              ],
            ),
          Text('اسم المركز: ${client.centerName}'),
        ]),
      ),
    );
  }
}
