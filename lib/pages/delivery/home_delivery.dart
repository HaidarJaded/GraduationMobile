import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../login/loginScreen/loginPage.dart';

class HomeDelivery extends StatelessWidget {
  const HomeDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.grey,
        title: const Text(
          "MYP",
          style: TextStyle(fontFamily: AutofillHints.birthday, fontSize: 30),
        ),
      ),
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
              leading: Icon(Icons.list_alt_rounded),
              title: Text("Old Phone"),
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
          GridView(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 2),
            children: const [Card.filled()],
          )
        ],
      ),
    );
  }
}
