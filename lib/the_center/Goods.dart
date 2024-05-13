// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Goods extends StatefulWidget {
  const Goods({super.key});

  @override
  State<Goods> createState() => _GoodsState();
}

Icon check = const Icon(Icons.check);

class _GoodsState extends State<Goods> {
  @override
  Widget build(BuildContext context) {
    bool icon = false;
    return Scaffold(
        // ignore: sized_box_for_whitespace
        body: GridView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisExtent: 360),
      children: [
        Card(
          elevation: 12,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    child: Image.asset(
                      'images/screen.PNG',
                      height: 200,
                    ),
                  ),
                ),
                const Text(
                  "Screen",
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Enter the type",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "impotatent";
                    }
                    return null;
                  },
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (check.icon == Icons.check) {
                          check = const Icon(Icons.check_box);

                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: const Text(
                                      "اذا كنت متأكد اضغط زر تأكيد حتى يتم ارسال اشعار لك بالسعر"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          icon = true;
                                        },
                                        child: const Text("تأكيد")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("الغاء"))
                                  ],
                                );
                              });
                        } else if (check.icon == Icons.check_box &&
                            icon == false) {
                          check = const Icon(Icons.check);
                        }
                      });
                    },
                    color: const Color.fromARGB(255, 63, 17, 100),
                    icon: check)
              ],
            ),
          ),
        ),
        Card(
            elevation: 12,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        // ignore: avoid_unnecessary_containers
                        child: Container(
                          child: Image.asset(
                            'images/screen.PNG',
                            height: 200,
                          ),
                        ),
                      ),
                    ])))
      ],
    ));
  }
}
