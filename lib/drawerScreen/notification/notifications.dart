// ignore_for_file: camel_case_types, unnecessary_import, body_might_complete_normally_nullable, avoid_unnecessary_containers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:graduation_mobile/drawerScreen/notification/allNotificationScreen.dart';
import 'package:graduation_mobile/drawerScreen/notification/cubit/notification_cubit.dart';

import '../../Controllers/crud_controller.dart';

import '../../bar/custom_drawer.dart';
import '../../models/notification.dart';

class notificationsScreen extends StatefulWidget {
  const notificationsScreen({super.key});

  @override
  State<notificationsScreen> createState() => _notificationsScreenState();
}

int? selectedNotificstionId;

class _notificationsScreenState extends State<notificationsScreen> {
  int perPage = 20;
  int currentPage = 1;
  int pagesCount = 0;
  int totalCount = 0;
  List<dynamic> notification = [];
  bool firstTime = true;
  bool readyToBuild = false;
  Future<void> fetchNotification([int page = 1, int perPage = 20]) async {
    try {
      if (currentPage > pagesCount) {
        return;
      }
      var data = await CrudController<Notification1>().getAll({
        'page': currentPage,
        'per_page': perPage,
        'orderBy': 'created_at',
        'dir': 'desc',
      });
      final List<Notification1>? notification = data.items;
      if (notification != null) {
        int currentPage = data.pagination?['current_page'];
        int lastPage = data.pagination?['last_page'];
        int totalCount = data.pagination?['total'];
        setState(() {
          this.currentPage = currentPage;
          pagesCount = lastPage;
          this.notification.addAll(notification);
          this.totalCount = totalCount;
        });
        return;
      }
      return;
    } catch (e) {
      Get.snackbar("title", e.toString());
      return;
    }
  }

  final controller = ScrollController();
  @override
  void initState() {
    super.initState();
    readyToBuild = false;
    BlocProvider.of<NotificationCubit>(Get.context!).getNotificationData({
      'page': 1,
      'per_page': perPage,
      'orderBy': 'created_at',
      'dir': 'desc',
    }).then((value) => readyToBuild = true);

    controller.addListener(() async {
      if (controller.position.maxScrollExtent == controller.offset) {
        setState(() {
          if (currentPage <= pagesCount) {
            currentPage++;
          }
        });
        await fetchNotification(currentPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
      if (state is NotificationLoading || readyToBuild == false) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 87, 42, 170),
              title: const Text('MYP'),
            ),
            drawer: const CustomDrawer(),
            body: Container(
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator())));
      } else if (state is NotificationSucess) {
        if (firstTime) {
          totalCount = state.data.pagination?['total'];
          currentPage = state.data.pagination?['current_page'];
          pagesCount = state.data.pagination?['last_page'];
          notification.addAll(state.data.items!);
          firstTime = false;
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => const allNotificationsScreen());
            },
            child: const Icon(Icons.list_alt),
          ),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 87, 42, 170),
            title: const Text('MYP'),
          ),
          drawer: const CustomDrawer(),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerRight,
                child: const Text(
                  "اسحب للتمييز كمقروء",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 246, 26, 26)),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: notification.length,
                  itemBuilder: (BuildContext context, int index) {
                    List notificationBodyList = notification[index].body;
                    String notificationBody = notificationBodyList.join(' ');
                    if (notification.length > index) {
                      Notification1 notification1 = notification[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Dismissible(
                          key: Key(notification1.StringId!),
                          onDismissed: (direction) {
                            setState(() {
                              BlocProvider.of<NotificationCubit>(context)
                                  .deleteNotification(
                                      id: notification1.StringId!);
                              notification.removeAt(index);
                            });
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Dismissible(
                            key: Key(notification[index].StringId!),
                            background: Container(
                              color: const Color.fromARGB(255, 155, 66, 233),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              child: const Icon(Icons.mark_email_read,
                                  color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              setState(() {
                                BlocProvider.of<NotificationCubit>(context)
                                    .markAsRead(
                                  id: notification[index].StringId!,
                                );

                                notification.removeAt(index);
                              });
                            },
                            child: Card(
                              color: const Color.fromARGB(255, 252, 234, 251),
                              elevation: 4.0,
                              child: ListTile(
                                title: Text(notification[index].title),
                                subtitle: Text(notificationBody),
                                leading: const Column(
                                  children: [
                                    CircleAvatar(
                                      child: Icon(Icons.notifications),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    BlocProvider.of<NotificationCubit>(context)
                                        .deleteNotification(
                                            id: notification[index].StringId!);
                                    setState(() {
                                      notification.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (currentPage <= pagesCount && pagesCount > 1) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return _buildNoMoreNotification();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }
      if (state is NotificationFailur) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 87, 42, 170),
              title: const Text('MYP'),
            ),
            drawer: const CustomDrawer(),
            body: Center(child: Text("${state.errorMessage}")));
      }

      return Container();
    });
  }

  Widget _buildNoMoreNotification() {
    if (notification.isEmpty) {
      if (totalCount == 0) {
        return const Center(
          child: Text('لا يوجد اشعارات'),
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (notification.length >= 20) {
      return const Center(
        child: Text('لا يوجد المزيد'),
      );
    } else {
      return const Text('لا يوجد اشعارات');
    }
  }
}
