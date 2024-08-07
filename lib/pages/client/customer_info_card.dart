import 'package:flutter/material.dart';
import 'package:graduation_mobile/models/customer_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerInfoCard extends StatelessWidget {
  final Customer customer;
  const CustomerInfoCard({super.key, required this.customer});

  // Function to launch the phone dialer
  void _makePhoneCall(String phone) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phone';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('بيانات الزبون'),
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: ListBody(children: [
          const SizedBox(height: 10.0),
          Text('الاسم: ${customer.name}'),
          Text('الكنية: ${customer.lastName}'),
          if (customer.nationalId != null)
            Text('الرقم الوطني: ${customer.nationalId}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('رقم الهاتف: ${customer.phone}'),
              IconButton(
                icon: const Icon(Icons.call),
                color: Colors.green,
                onPressed: () => _makePhoneCall(customer.phone),
              ),
            ],
          ),
          if (customer.email != null)
            Text('البريد الالكتروني: ${customer.email}'),
          Text('عدد الزيارات: ${customer.devicesCount}'),
        ]),
      ),
    );
  }
}
