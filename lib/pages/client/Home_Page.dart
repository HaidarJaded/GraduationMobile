// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_mobile/Controllers/auth_controller.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/pages/client/add_detalis.dart';
import 'package:graduation_mobile/pages/client/notification.dart';
import 'package:graduation_mobile/pages/client/step.dart';
import 'package:graduation_mobile/pages/client/updateStatus.dart';
import '../../bar/SearchAppBar.dart';
import '../../login/loginScreen/loginPage.dart';
import 'cubit/phone_cubit/phone_cubit.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePages();
}

class _HomePages extends State<HomePages> {
  late CrudController<Device> _crudController;
  late PhoneCubit _phoneCubit;
  int? userId;
  int perPage = 20;
  int currentPage = 1;
  int pagesCount = 0;
  int totalCount = 0;
  List<dynamic> devices = [];
  bool firstTime = true;
  bool readyToBuild = false;

  Future<void> fetchDevices([int page = 1, int perPage = 20]) async {
    try {
      if (currentPage > pagesCount) {
        return;
      }
      var data = await CrudController<Device>().getAll({
        'page': currentPage,
        'per_page': perPage,
        'orderBy': 'date_receipt',
        'dir': 'desc',
        'user_id': userId,
      });
      final List<Device>? devices = data.items;
      if (devices != null) {
        int currentPage = data.pagination?['current_page'];
        int lastPage = data.pagination?['last_page'];
        int totalCount = data.pagination?['total'];
        setState(() {
          this.currentPage = currentPage;
          pagesCount = lastPage;
          this.devices.addAll(devices);
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

  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    readyToBuild = false;
    _phoneCubit = PhoneCubit();
    InstanceSharedPrefrences().getId().then((id) {
      userId = id;
      _crudController = CrudController<Device>();
      _phoneCubit.getDevicesByUserId({
        'page': currentPage,
        'per_page': perPage,
        'orderBy': 'date_receipt',
        'dir': 'desc',
        'user_id': userId,
      }).then((value) => readyToBuild = true);
    });
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        setState(() {
          if (currentPage <= pagesCount) {
            currentPage++;
          }
        });
        await fetchDevices(currentPage);
      }
    });
  }

  @override
  void dispose() {
    _phoneCubit.close();
    super.dispose();
  }

  Future<void> updateDeviceStatus(Device device, String status) async {
    // هنا يتم تحديث حالة الجهاز
    device.status = status;
    await _crudController.update(device.id!, {'status': status});
    await _phoneCubit.getDevicesByUserId({
      'page': currentPage,
      'per_page': perPage,
      'orderBy': 'date_receipt',
      'dir': 'desc',
      'user_id': userId,
    }); // تحديث قائمة الأجهزة بعد التعديل
  }

  void notifyClient(Device device, double cost, String issue,
      DateTime expectedDeliveryDate) async {
    // هنا يتم إشعار العميل بالتفاصيل
    device.status = 'بانتظار استجابة العميل';
    device.costToClient = cost;
    device.problem = issue;
    device.expectedDateOfDelivery = expectedDeliveryDate;
    await _crudController.update(device.id!, {
      'status': 'بانتظار استجابة العميل',
      'cost_to_client': cost,
      'problem': issue,
      'Expected_date_of_delivery': expectedDeliveryDate.toString()
    });
    _phoneCubit.getDevicesByUserId({
      'page': currentPage,
      'per_page': perPage,
      'orderBy': 'date_receipt',
      'dir': 'desc',
      'user_id': userId,
    }); // تحديث قائمة الأجهزة بعد التعديل
    // إرسال الإشعار
    SnackBarAlert().alert("تم ارسال اشعار للعميل انتظر الاستجابة رجاءاً",
        color: const Color.fromARGB(255, 4, 83, 173), title: "اشعار العميل");
  }

  void logout() async {
    if (await BlocProvider.of<loginCubit>(Get.context!).logout()) {
      SnackBarAlert().alert("تم تسجيل الخروج بنجاح",
          color: const Color.fromRGBO(0, 200, 0, 1), title: "إلى اللقاء");
      Get.offAll(() => const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(),
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: ListView(children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.person),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<String?>(
                    future: InstanceSharedPrefrences().getName(),
                    builder: (context, nameSnapshot) {
                      return FutureBuilder<String?>(
                        future: InstanceSharedPrefrences().getEmail(),
                        builder: (context, emailSnapshot) {
                          if (nameSnapshot.hasData && emailSnapshot.hasData) {
                            return ListTile(
                              title: Text(nameSnapshot.data!),
                              subtitle: Text(emailSnapshot.data!),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active_sharp),
              title: const Text("notifications"),
              onTap: () {
                Get.to(NotificationScreen());
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
            InkWell(
              onTap: logout,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255, 203, 139, 248),
                    Color.fromARGB(255, 67, 25, 146),
                  ]),
                ),
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
      body: BlocProvider(
        create: (context) => _phoneCubit,
        child: Column(
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
                },
                builder: (context, state) {
                  if (state is PhoneLoading || readyToBuild == false) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PhoneSuccess) {
                    if (firstTime) {
                      totalCount = state.data.pagination?['total'];
                      currentPage = state.data.pagination?['current_page'];
                      pagesCount = state.data.pagination?['last_page'];
                      devices.addAll(state.data.items!);
                      firstTime = false;
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: devices.length + 1,
                      itemBuilder: (context, index) {
                        if (index < devices.length) {
                          final device = devices[index];
                          return Card(
                            color: const Color.fromARGB(255, 252, 234, 251),
                            child: ListTile(
                              title: Text(device.model),
                              subtitle: Text(device.imei),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (device.status == 'قيد العمل') ...[
                                    IconButton(
                                      onPressed: () {
                                        // هنا يتم عرض خطوات الإصلاح
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const RepairSteps(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(FontAwesomeIcons.list),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // هنا يتم تحديد نتيجة العمل كجاهز
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const UpdateStatus(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.check_circle),
                                    ),
                                  ] else ...[
                                    IconButton(
                                      onPressed: () async {
                                        if (device.status == 'يتم فحصه') {
                                          // تغيير الحالة إلى "بانتظار استجابة العميل"
                                          notifyClient(
                                              device,
                                              100.0,
                                              "Issue details",
                                              DateTime(2024, 6, 1));
                                        } else {
                                          // تغيير الحالة إلى "يتم فحصه"
                                          await updateDeviceStatus(
                                              device, 'يتم فحصه');
                                        }
                                      },
                                      icon: const Icon(Icons.tips_and_updates),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        } else if (currentPage <= pagesCount &&
                            pagesCount > 1) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return devices.isEmpty
                              ? const Center(child: Text('لا يوجد اجهزة'))
                              : devices.length >= 20
                                  ? const Center(child: Text('لا يوجد المزيد'))
                                  : null;
                        }
                      },
                    );
                  } else if (state is PhoneFailure) {
                    return Center(
                      child:
                          Text('Failed to load devices: ${state.errorMessage}'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddDetalis(),
            ),
          );
        },
        child: const Icon(Icons.post_add_outlined),
      ),
    );
  }
}
