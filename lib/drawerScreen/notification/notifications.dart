// ignore_for_file: camel_case_types, unnecessary_import, body_might_complete_normally_nullable, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:graduation_mobile/drawerScreen/notification/cubit/notification_cubit.dart';
import 'package:graduation_mobile/models/notification.dart';

import '../../Controllers/crud_controller.dart';

import '../../bar/custom_drawer.dart';
import '../../helper/snack_bar_alert.dart';

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
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 87, 42, 170),
            title: const Text('MYP'),
          ),
          drawer: const CustomDrawer(),
          body: ListView.builder(
            itemCount: notification.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  elevation: 4.0,
                  child: ListTile(
                    title: Text(notification[index].title),
                    leading: const CircleAvatar(
                      child: Icon(Icons.notifications),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        BlocProvider.of<NotificationCubit>(context)
                            .deleteNotification(
                                id: notification[index].StringId!);
                      },
                    ),
                  ),
                ),
              );
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
            drawer: const CustomDrawer(),
            body: Center(child: Text("${state.errorMessage}")));
      }
      if (state is NotificationDeleteSucsee) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          SnackBarAlert().alert("تمت العملية",
              color: const Color.fromRGBO(0, 200, 0, 1),
              title: "تم تحديث البيانات بنجاح");
          Get.offAll(() => const notificationsScreen());
        });
      }
      return Container();
    });
  }
}
