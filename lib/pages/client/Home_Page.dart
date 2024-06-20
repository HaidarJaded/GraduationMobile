// ignore_for_file: file_names, avoid_print, use_build_context_synchronously, avoid_unnecessary_containers, unnecessary_import, unused_element, unnecessary_null_comparison

import 'package:flutter/material.dart';
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
import 'package:graduation_mobile/pages/client/drawer/notificationScreen.dart';
import 'package:graduation_mobile/pages/client/drawer/old_phone_user.dart';
import 'package:graduation_mobile/pages/client/drawer/profile_user.dart';
import 'package:graduation_mobile/pages/client/update_status_page.dart';
import 'package:graduation_mobile/pages/client/widget/device_info.dart';
import '../../login/loginScreen/loginPage.dart';
import 'cubit/phone_cubit/phone_cubit.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  int currentPage = 1;
  List<Device> devices = [];
  bool isLoading = false;
  bool isAtWork = false;
  bool readyToBuild = false;
  final ScrollController scrollController = ScrollController();
  int totalCount = 0;
  int pagesCount = 0;
  int perPage = 20;
  int? userId;
  User? _user;

  User get user => _user!;

  set user(User value) {
    _user = value;
  }

  late CrudController<Device> _crudController;
  late PhoneCubit _phoneCubit;

  @override
  void dispose() {
    _phoneCubit.close();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _crudController = CrudController<Device>();
    _phoneCubit = PhoneCubit();
    _initializeData();
    scrollController.addListener(_scrollListener);
  }

  void _initializeData() async {
    userId = await InstanceSharedPrefrences().getId();
    if (userId != null) {
      _fetchUserDetails(userId!);
      await _fetchDevices();
    } else {
      print('No user ID found');
    }
  }

  void _fetchUserDetails(int userId) async {
    // Fetch user details here, assuming you have a method for this
    var fetchedUser = await _crudController.getUserDetails(userId);
    if (fetchedUser != null) {
      setState(() {
        _user = fetchedUser;
      });
    }
  }

  void _scrollListener() async {
    if (scrollController.position.atEdge) {
      if (scrollController.position.pixels != 0) {
        setState(() {
          if (currentPage <= pagesCount) {
            currentPage++;
          }
        });
        await _fetchDevices();
      }
    }
  }

  Future<void> _fetchDevices() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      var data = await _crudController.getAll({
        'page': currentPage,
        'per_page': perPage,
        'orderBy': 'date_receipt',
        'dir': 'desc',
        'user_id': userId,
        'with': 'client',
        'deliver_to_client': 0,
      });
      if (data != null) {
        setState(() {
          devices.addAll(data.items!);
          pagesCount = data.pagination?['last_page'] ?? 1;
          totalCount = data.pagination?['total'] ?? 0;
        });
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      setState(() {
        isLoading = false;
        readyToBuild = true;
      });
    }
  }

  Future<bool> editAtWork(int newStatus) async {
    try {
      var response = await Api().put(
        path: 'api/users/$userId',
        body: {'at_work': newStatus},
      );
      return response != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateDeviceStatus(Device device, String status) async {
    setState(() {
      device.status = status;
    });
    await _crudController.update(device.id!, {'status': status});
  }

  void logout() async {
    if (await BlocProvider.of<loginCubit>(context).logout()) {
      SnackBarAlert().alert("تم تسجيل الخروج بنجاح",
          color: const Color.fromRGBO(0, 200, 0, 1), title: "إلى اللقاء");
      Get.offAll(() => const LoginPage());
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      currentPage = 1;
      devices.clear();
    });
    await _fetchDevices();
  }

  void _showStatusDialog(String status, Device device, Function() action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('هل تريد تغيير حالة الجهاز إلى $status؟'),
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

  void _showConfirmProcessDialog(int deviceId, Function() action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              'هل أنت متأكد من رغبتك بتسليم الجهاز؟\n لا يمكن التراجع عن هذه الخطوة.'),
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
          Switch(
            value: isAtWork,
            onChanged: (newStatus) async {
              setState(() {
                isAtWork = newStatus;
              });
              if (await editAtWork(newStatus ? 1 : 0)) {
                InstanceSharedPrefrences().editAtWork(newStatus ? 1 : 0);
              } else {
                setState(() {
                  isAtWork = !newStatus;
                });
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: IconButton(
                      onPressed: () {
                        Get.to(UserProfilePage(userId: userId));
                      },
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
                title: const Text("الإشعارات"),
                onTap: () {
                  Get.to(NotificationScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.list_alt_rounded),
                title: const Text("الهاتف القديم"),
                onTap: () {
                  Get.to(const oldPhoneUser());
                },
              ),
              const ListTile(
                leading: Icon(Icons.help),
                title: Text("أي سؤال"),
              ),
              const ListTile(
                leading: Icon(Icons.settings),
                title: Text("الإعدادات"),
              ),
              InkWell(
                onTap: logout,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
                      'تسجيل الخروج',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => _phoneCubit,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: BlocConsumer<PhoneCubit, PhoneState>(
                listener: (context, state) {
                  if (state is PhoneLoading) {
                    Container(
                      color: Colors.white,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is PhoneLoading || !readyToBuild) {
                    return Container(
                      color: Colors.white,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is PhoneSuccess) {
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
                                trailing: _buildTrailingActions(device),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: _buildDeviceDetails(device),
                                  ),
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
                            return _buildNoMoreDevices();
                          }
                        },
                      ),
                    );
                  } else if (state is PhoneFailure) {
                    return Center(
                      child:
                          Text('فشل في تحميل الأجهزة: ${state.errorMessage}'),
                    );
                  } else {
                    return const Center(child: Text('لا يوجد أجهزة'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailingActions(Device device) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (device.status == 'لم يتم بدء العمل فيه')
          IconButton(
            onPressed: () {
              _showStatusDialog('يتم فحصه', device, () {
                updateDeviceStatus(device, 'يتم فحصه');
                Get.back();
              });
            },
            icon: const Icon(Icons.handyman_outlined),
          ),
        if (device.status == 'قيد العمل')
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateStatusPage(
                    device: device,
                    status: device.status,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.check_circle_outline),
          ),
        if (device.status == 'يتم فحصه')
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddDetalis(device: device),
                ),
              );
            },
            icon: const Icon(FontAwesomeIcons.penToSquare),
          ),
        if (device.status == 'بانتظار استجابة العميل')
          IconButton(
            onPressed: () {
              SnackBarAlert().alert(
                "تم ارسال اشعار للعميل مسبقاً انتظر الاستجابة رجاءاً",
                color: const Color.fromARGB(255, 4, 83, 173),
                title: "اشعار العميل",
              );
            },
            icon: const Icon(Icons.alarm_on),
          ),
        if (device.status == 'لا يصلح' ||
            device.status == 'لم يوافق على العمل به' ||
            device.status == 'جاهز')
          FutureBuilder(
            future: User.hasPermission('تسليم جهاز'),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                return IconButton(
                  onPressed: () {
                    _showConfirmProcessDialog(device.id!, () {
                      setState(() {
                        devices.remove(device);
                      });
                      Api().put(path: 'api/devices/${device.id}', body: {
                        'deliver_to_client': 1,
                      });
                      Get.back();
                    });
                  },
                  icon: const Icon(Icons.local_shipping_outlined),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
      ],
    );
  }

  Widget _buildDeviceDetails(Device device) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 242, 235, 247),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _buildDetailRow('العطل:', device.problem ?? 'لم يحدد بعد'),
          _buildDetailRow(
              'التكلفة:', device.costToClient.toString() ?? 'لم يحدد بعد'),
          _buildDetailRow('الحالة:', device.status),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DeviceInfo(device: device);
                },
              );
            },
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text('عرض جميع البيانات'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      children: [
        Text(title),
        const SizedBox(width: 150),
        Text(value),
      ],
    );
  }

  Widget _buildNoMoreDevices() {
    if (devices.isEmpty) {
      return const Center(
        child: Text('لا يوجد أجهزة'),
      );
    } else if (devices.length >= 20) {
      return const Center(
        child: Text('لا يوجد المزيد'),
      );
    } else {
      return const SizedBox();
    }
  }
}
