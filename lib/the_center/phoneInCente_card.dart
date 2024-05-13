// ignore_for_file: file_names

import 'package:flutter/material.dart';

// ignore: must_be_immutable, camel_case_types
class phoneInCenter_card extends StatelessWidget {
  // ignore: use_super_parameters
  const phoneInCenter_card({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 252, 234, 251),
      child: Column(
        children: [
          ExpansionTile(
            expandedAlignment: FractionalOffset.topRight,
            title: const Text(""),
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(
                      left: 25, top: 5, bottom: 5, right: 25),
                  child: Container(
                      transformAlignment: Alignment.topRight,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 242, 235, 247),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.topLeft,
                      // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
                      child: Column(children: [
                        const Row(
                          children: [
                            Expanded(child: Text('')),
                            Expanded(child: Text(":")),
                            Expanded(child: Text("العطل")),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Expanded(child: Text()),
                        //     const Expanded(child: Text(":")),
                        //     const Expanded(child: Text("التكلفة ")),
                        //   ],
                        // ),
                        // Row(
                        //   children: [
                        //     Expanded(child: Text()),
                        //     const Expanded(child: Text(":")),
                        //     const Expanded(child: Text("اسم صاحب الجهاز")),
                        //   ],
                        // ),
                        // Row(
                        //   children: [
                        //     Expanded(child: Text()),
                        //     const Expanded(child: Text(":")),
                        //     const Expanded(
                        //       child: Text("رقم صاحب الجهاز "),
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Text(),
                        //     ),
                        //     const Expanded(child: Text(":")),
                        //     const Expanded(
                        //         child: Text("الرقم الوطني لصاحب الجهاز ")),
                        //   ],
                        // ),
                      ])))
            ],
          )
        ],
      ),
    );
  }
}
