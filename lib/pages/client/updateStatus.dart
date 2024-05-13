// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

class UpdateStatus extends StatefulWidget {
  const UpdateStatus({super.key});

  @override
  State<UpdateStatus> createState() => _UpdateStatus();
}

class _UpdateStatus extends State<UpdateStatus> {
  String? state;
  @override
  Widget build(BuildContext context) {
    TextEditingController _datecontroller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Update device status",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Status',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            RadioListTile(
                activeColor: const Color(0xFF21468A),
                title: const Text("ready"),
                value: "ready",
                groupValue: state,
                onChanged: (val) {
                  setState(() {
                    state = val;
                  });
                }),
            const SizedBox(
              height: 10,
            ),
            RadioListTile(
                activeColor: const Color(0xFF21468A),
                title: const Text("Does not fit"),
                value: "Does not fit",
                groupValue: state,
                onChanged: (val) {
                  setState(() {
                    state = val;
                  });
                }),
            const SizedBox(
              height: 10,
            ),
            RadioListTile(
                activeColor: const Color(0xFF21468A),
                title: const Text("It is checked"),
                value: "It is checked",
                groupValue: state,
                onChanged: (val) {
                  setState(() {
                    state = val;
                  });
                }),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Expected date',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.datetime,
              controller: _datecontroller,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            InkWell(
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
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
