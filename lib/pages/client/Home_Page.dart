// ignore_for_file: file_names, avoid_print, use_build_context_synchronously, avoid_unnecessary_containers, unnecessary_import, unused_element
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_mobile/Controllers/auth_controller.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/models/user_model.dart';
import 'package:graduation_mobile/pages/client/add_detalis.dart';
import 'package:graduation_mobile/pages/client/cubit/switch_cubit/switch_cubit.dart';
import 'package:graduation_mobile/pages/client/drawer/notificationScreen.dart';
import 'package:graduation_mobile/pages/client/drawer/old_phone_user.dart';
import 'package:graduation_mobile/pages/client/update_status_page.dart';
import 'package:graduation_mobile/pages/client/widget/device_info.dart';
import '../../login/loginScreen/loginPage.dart';
import 'cubit/phone_cubit/phone_cubit.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePages();
}

class _HomePages extends State<HomePages> {
  int currentPage = 1;
  List<dynamic> devices = [];
  bool firstTime = true;
  int pagesCount = 0;
  int perPage = 20;
  bool readyToBuild = false;
  final scrollController = ScrollController();
  int totalCount = 0;
  int? userId;
  User? user;

  late CrudController<Device> _crudController;
  late PhoneCubit _phoneCubit;

  @override
  void dispose() {
    _phoneCubit.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    readyToBuild = false;
    _phoneCubit = PhoneCubit();
    InstanceSharedPrefrences().getId().then((id) {
      userId = id;
      _crudController = CrudController<Device>();
      _phoneCubit
          .getDevicesByUserId({
            'page': currentPage,
            'per_page': perPage,
            'orderBy': 'date_receipt',
            'dir': 'desc',
            'user_id': userId,
            'with': 'client',
            'deliver_to_client': 0,
          } as Map<String, dynamic>?)
          .then((value) => readyToBuild = true);
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
        'with': 'client',
        'deliver_to_client': 0,
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

  Future<void> updateDeviceStatus(Device device, String status) async {
    // هنا يتم تحديث حالة الجهاز
    setState(() {
      device.status = status;
    });
    await _crudController.update(device.id!, {'status': status});
  }

  void logout() async {
    if (await BlocProvider.of<loginCubit>(Get.context!).logout()) {
      SnackBarAlert().alert("تم تسجيل الخروج بنجاح",
          color: const Color.fromRGBO(0, 200, 0, 1), title: "إلى اللقاء");
      Get.offAll(() => const LoginPage());
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      currentPage = 1;
      devices.clear();
      fetchDevices(currentPage);
    });
  }

  void _showStatusDialog(String status, Device device, Function() action) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('هل تريد تغيير حالة الجهاز الى $status'),
          actions: <Widget>[
            TextButton(
              child: const Text('لا'),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              onPressed: action,
              child: const Text('نعم'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 87, 42, 170),
        title: const Text('MYP'),
        actions: [
          BlocBuilder<SwitchCubit, SwitchState>(builder: (context, state) {
            bool switchValue = state is SwitchInitial
                ? state.switchValue
                : (state as SwitchChanged).switchValue;

            return Switch(
              value: switchValue,
              onChanged: (value) {
                context.read<SwitchCubit>().toggleSwitch(userId!);
                if (user != null) {
                  user!.atWork = value ? 1 : 0;
                }
                print(value);
              },
            );
          })
        ],
      ),
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
            ListTile(
              leading: const Icon(Icons.list_alt_rounded),
              title: const Text("Old Phone"),
              onTap: () {
                Get.to(const oldPhoneUser());
              },
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
                    Container(
                        color: Colors.white,
                        child:
                            const Center(child: CircularProgressIndicator()));
                  }
                },
                builder: (context, state) {
                  print(state);
                  if (state is PhoneLoading || readyToBuild == false) {
                    return Container(
                        color: Colors.white,
                        child:
                            const Center(child: CircularProgressIndicator()));
                  } else if (state is PhoneSuccess) {
                    if (firstTime) {
                      totalCount = state.data.pagination?['total'];
                      currentPage = state.data.pagination?['current_page'];
                      pagesCount = state.data.pagination?['last_page'];
                      devices.addAll(state.data.items!);
                      firstTime = false;
                    }
                    return RefreshIndicator(
                        onRefresh: _refreshData,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: scrollController,
                          itemCount: devices.length + 1,
                          itemBuilder: (context, index) {
                            if (index < devices.length) {
                              final device = devices[index];
                              return Card(
                                color: const Color.fromARGB(255, 252, 234, 251),
                                child: ExpansionTile(
                                  title: Text(device.model),
                                  subtitle: Text(device.imei),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (device.status ==
                                          'لم يتم بدء العمل فيه') ...[
                                        IconButton(
                                            onPressed: () {
                                              _showStatusDialog(
                                                  'يتم فحصه', device, () {
                                                updateDeviceStatus(
                                                    device, 'يتم فحصه');
                                                Get.back();
                                              });
                                            },
                                            icon:
                                                const Icon(Icons.saved_search))
                                      ],
                                      if (device.status == 'قيد العمل') ...[
                                        IconButton(
                                          onPressed: () {
                                            // هنا يتم تحديد نتيجة العمل كجاهز
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateStatusPage(
                                                  device: device,
                                                  status: device.status,
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                              Icons.check_circle_outline),
                                        ),
                                      ] else ...[
                                        if (device.status == 'يتم فحصه') ...[
                                          IconButton(
                                            onPressed: () async {
                                              // تغيير الحالة إلى "بانتظار استجابة العميل"
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddDetalis(
                                                    device: device,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                                FontAwesomeIcons.penToSquare),
                                          ),
                                        ] else ...[
                                          if (device.status ==
                                              'بانتظار استجابة العميل') ...[
                                            IconButton(
                                                onPressed: () {
                                                  SnackBarAlert().alert(
                                                      "تم ارسال اشعار للعميل مسبقاً انتظر الاستجابة رجاءاً",
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 4, 83, 173),
                                                      title: "اشعار العميل");
                                                },
                                                icon:
                                                    const Icon(Icons.alarm_on))
                                          ]
                                        ],
                                      ],
                                      if (device.status == 'لا يصلح' ||
                                          device.status ==
                                              'لم يوافق على لعمل به' ||
                                          device.status == 'جاهز') ...[
                                        FutureBuilder(
                                            future: User.hasPermission(
                                                'تسليم جهاز'),
                                            builder: ((BuildContext context,
                                                AsyncSnapshot<bool> snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.data!) {
                                                return IconButton(
                                                  onPressed: () {
                                                    _showConfirmProcessDialog(
                                                        device.id, () {
                                                      setState(() {
                                                        devices.remove(device);
                                                      });
                                                      Api().put(
                                                          path:
                                                              'api/devices/${device.id}',
                                                          body: {
                                                            'deliver_to_client':
                                                                1
                                                          });
                                                      Get.back();
                                                    });
                                                  },
                                                  icon: const Icon(Icons
                                                      .local_shipping_outlined),
                                                );
                                              } else {
                                                return const SizedBox(); // Placeholder widget if permission check is pending or user doesn't have permission
                                              }
                                            }))
                                      ],
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25,
                                          top: 5,
                                          bottom: 5,
                                          right: 25),
                                      child: Container(
                                        transformAlignment: Alignment.topRight,
                                        decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 242, 235, 247),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        padding: const EdgeInsets.all(10),
                                        alignment: Alignment.topLeft,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text('العطل :'),
                                                const SizedBox(
                                                  width: 150,
                                                ),
                                                Text(
                                                    '${device.problem ?? 'لم يحدد بعد'}')
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                const Text('التكلفة :'),
                                                const SizedBox(
                                                  width: 150,
                                                ),
                                                Text(
                                                    '${device.costToClient ?? 'لم يحدد بعد'}'),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                const Text('الحالة :'),
                                                const SizedBox(
                                                  width: 150,
                                                ),
                                                Text('${device.status}'),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        child: DeviceInfo(
                                                            device: device),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: const Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child:
                                                      Text('عرض جميع البيانات'),
                                                )),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
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
                                  ? firstTime
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : const Center(
                                          child: Text('لا يوجد اجهزة'))
                                  : devices.length >= 20
                                      ? const Center(
                                          child: Text('لا يوجد المزيد'))
                                      : null;
                            }
                          },
                        ));
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
    );
  }
}

void _showConfirmProcessDialog(int deviceId, Function() action) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
            'هل انت متأكد من رغبتك بتسليم الجهاز؟\n لا يمكن التراجع عن الخطوة'),
        actions: <Widget>[
          TextButton(
            child: const Text('لا'),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            onPressed: action,
            child: const Text('نعم'),
          ),
        ],
      );
    },
  );
}
