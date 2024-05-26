import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:graduation_mobile/bar/SearchAppBar.dart';
=======
import 'package:get/get.dart';
>>>>>>> 314dd05dfbfbfd4865aac7b23c2af75636fa961e

import '../../login/loginScreen/loginPage.dart';

class HomeDelivery extends StatelessWidget {
  const HomeDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(),
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: ListView(children: [
            Row(children: [
              // ignore: avoid_unnecessary_containers
              Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.person))),
              ),
              const Expanded(
                  child: ListTile(
                title: Text("Esraa Alazmeh"),
                subtitle: Text("esraa@gmail.com"),
              ))
            ]),
            const ListTile(
              leading: Icon(Icons.notifications_active_sharp),
              title: Text("notifications"),
            ),
            const ListTile(
              leading: Icon(Icons.help),
              title: Text("Any question"),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
            ),
            MaterialButton(
              onPressed: () {
                Get.offAll(const LoginPage());
              },
              minWidth: 10,
              color: const Color(0xFF3E7FF8),
              child: const Text("log out"),
            )
          ]),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(itemBuilder: (context, index) {
              return const Card(
                  color: Color.fromARGB(255, 252, 234, 251),
                  child: Column(children: [
                    ExpansionTile(
                      // key: ValueKey(),
                      expandedAlignment: FractionalOffset.topRight,
                      title: Text('الطلب الاول'),
                      children: [],
                    )
                  ]));
            }),
          )
        ],
      ),
    );
  }
}
