// ignore_for_file: file_names
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
// ignore: unnecessary_import
import 'package:get/get_core/src/get_main.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/drawerScreen/notification/cubit/notification_cubit.dart';
import 'package:graduation_mobile/models/allNotifications.dart';
import 'package:graduation_mobile/pages/client/widget/drawer_user.dart';

// ignore: camel_case_types
class allNotificationScreen extends StatefulWidget {
  const allNotificationScreen({super.key});

  @override
  State<allNotificationScreen> createState() => _allNotificationScreenState();
}

int? selectedNotificstionId;

// ignore: camel_case_types
class _allNotificationScreenState extends State<allNotificationScreen> {
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
      var data = await CrudController<allNotification>().getAll({
        'page': currentPage,
        'per_page': perPage,
        'orderBy': 'created_at',
        'dir': 'desc',
      });
      final List<allNotification>? notification = data.items;
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
    BlocProvider.of<NotificationCubit>(Get.context!).getAllNotificationData({
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
            drawer: const UserDrawer(),
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
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 87, 42, 170),
            title: const Text('MYP'),
          ),
          drawer: const UserDrawer(),
          body: ListView.builder(
            itemCount: notification.length,
            itemBuilder: (BuildContext context, int index) {
              List notificationBodyList = notification[index].body;
              String notificationBody = notificationBodyList.join(' ');
              if (notification.length > index) {
                allNotification notification1 = notification[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    color: notification1.read_at == null
                        ? const Color.fromARGB(255, 211, 201, 219)
                        : const Color.fromARGB(255, 252, 234, 251),
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
        );
      }
      if (state is NotificationFailur) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 87, 42, 170),
              title: const Text('MYP'),
            ),
            drawer: const UserDrawer(),
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
