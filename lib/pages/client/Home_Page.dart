// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_mobile/pages/client/add_detalis.dart';
import 'package:graduation_mobile/pages/client/step.dart';
import 'package:graduation_mobile/pages/client/updateStatus.dart';

import '../../bar/SearchAppBar.dart';

import '../../login/loginScreen/loginPage.dart';
import '../../widget/custom_card.dart';
import 'notification.dart';
import 'phone_cubit/phone_cubit.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePages();
}

class _HomePages extends State<HomePages> {
  bool loading = false;
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
            ListTile(
              leading: const Icon(Icons.notifications_active_sharp),
              title: const Text("notifications"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return NotificationScreen();
                }));
              },
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }),
                );
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
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: BlocConsumer<PhoneCubit, PhoneState>(
                listener: (context, state) {
              if (state is PhoneLoading) {
                const Center(
                  child: CircularProgressIndicator(),
                );
              }
              // ignore: non_constant_identifier_names, avoid_types_as_parameter_names
            }, builder: (context, State) {
              return ListView.builder(itemBuilder: (context, index) {
                return ExpansionTile(title: const Text("Phone"), children: [
                  CustomCard(
                    title: const Text('title'),
                    subtitle: const Text('body'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const UpdateStatus();
                              }));
                            },
                            icon: const Icon(Icons.tips_and_updates)),
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.list),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const RepairSteps();
                            }));
                          },
                        ),
                      ],
                    ),
                  )
                ]);
              });
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddDetalis();
          }));
        },
        child: const Icon(Icons.post_add_outlined),
      ),
    );
  }
}
