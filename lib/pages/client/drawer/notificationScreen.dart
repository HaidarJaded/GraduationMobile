// ignore_for_file: file_names, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/models/notification.dart';
import 'package:graduation_mobile/pages/client/cubit/notifications_cubit/notifications_cubit.dart';

import '../../../drawerScreen/notification/cubit/notification_cubit.dart';

@immutable
// ignore: use_key_in_widget_constructors
class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int perPage = 20;
  int currentPage = 1;
  int pagesCount = 0;
  int totalCount = 0;
  List<dynamic> notifications = [];
  bool firstTime = true;
  bool readyToBuild = false;
  late final List<Notification1>? notification;

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
      notification = data.items;
      if (notification != null) {
        int currentPage = data.pagination?['current_page'];
        int lastPage = data.pagination?['last_page'];
        int totalCount = data.pagination?['total'];
        setState(() {
          this.currentPage = currentPage;
          pagesCount = lastPage;
          // ignore: unnecessary_this
          this.notifications.addAll(notification!);
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
    BlocProvider.of<NotificationsCubit>(Get.context!).getNotificationData({
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
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "الاشعارات",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationsFailur) {
            return Center(
              child: Text('حدث خطأ: ${state.errorMessage}',
                  style: const TextStyle(color: Colors.red)),
            );
          }
          if (state is NotificationsSucess) {
            if (firstTime) {
              totalCount = state.data.pagination?['total'];
              currentPage = state.data.pagination?['current_page'];
              pagesCount = state.data.pagination?['last_page'];
              notifications.addAll(state.data.items!);
              firstTime = false;
            }
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    elevation: 4.0,
                    child: ListTile(
                      title: Text('${notifications[index].title}'),
                      leading: const CircleAvatar(
                        child: Icon(Icons.notifications),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('تأكيد الحذف'),
                                content: const Text(
                                    'هل أنت متأكد أنك تريد حذف هذا الإشعار؟'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('إلغاء'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('حذف'),
                                    onPressed: () {
                                      BlocProvider.of<NotificationCubit>(
                                              context)
                                          .deleteNotification(
                                              id: notifications[index]
                                                  .StringId!);
                                      setState(() {
                                        notifications.removeAt(index);
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text('هل أنت متأكد أنك تريد حذف هذا الإشعار؟'),
          actions: <Widget>[
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('حذف'),
              onPressed: () {
                setState(() {
                  notifications.removeAt(index);
                });
                Navigator.of(context).pop(); // إغلاق حوار التأكيد
              },
            ),
          ],
        );
      },
    );
  }
}
