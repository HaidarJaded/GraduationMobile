import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RepairSteps extends StatelessWidget {
  const RepairSteps({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Repair Steps')),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dropdown for selecting the category
                SizedBox(
                  height: 12,
                ),
                Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(FontAwesomeIcons.wrench),
                    title: Text(
                      "Step 1: order",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                        "Rerum dolor ullam rerum. Consequuntur consectetur beatae saepe fuga animi culpa"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(FontAwesomeIcons.wrench),
                    title: Text(
                      "Step 1: order",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                        "Rerum dolor ullam rerum. Consequuntur consectetur beatae saepe fuga animi culpa"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: InkWell(
          onTap: () async {},
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 14,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(colors: [
                Color(0xFF3E7FF8),
                Color(0xFF21468A),
              ]),
            ),
            width: MediaQuery.of(context).size.width,
            child: const Center(
              child: Text(
                'Send to customer',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
