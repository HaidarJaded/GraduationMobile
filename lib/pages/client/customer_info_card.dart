import 'package:flutter/material.dart';
import 'package:graduation_mobile/models/client_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerInfoCard extends StatelessWidget {
  final Client client;
  const CustomerInfoCard({super.key, required this.client});

  // Function to launch the phone dialer
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
          Text('الاسم: ${client.name}'),
          Text('الكنية: ${client.lastName}'),
          if (client.nationalId != null)
            Text('الرقم الوطني: ${client.nationalId}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('رقم الهاتف: ${client.phone}'),
              IconButton(
                icon: const Icon(Icons.call),
                color: Colors.green,
                onPressed: () => _makePhoneCall(client.phone!),
              ),
            ],
          ),
          Text('عدد الزيارات: ${client.devicesCount}'),
        ]),
      ),
    );
  }
}
