import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/Controllers/auth_controller.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/pages/client/add_detalis.dart';
import 'package:graduation_mobile/pages/client/notification.dart';
import 'package:graduation_mobile/pages/client/updateStatus.dart';
import '../../bar/SearchAppBar.dart';
import '../../login/loginScreen/loginPage.dart';
import 'cubit/phone_cubit/phone_cubit.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  late CrudController<Device> _crudController;
  late PhoneCubit _phoneCubit;
  int? userId;
  int? deviceId;

  Future<void> fetch() async {
    userId = await InstanceSharedPrefrences().getId();
    _crudController = CrudController<Device>();

    if (userId != null) {
      _phoneCubit.getDevicesByUserId(userId!);
    } else {
      print('fetch: userId is null');
    }
  }

  @override
  void initState() {
    super.initState();
    _phoneCubit = PhoneCubit();
    fetch();
  }

  @override
  void dispose() {
    _phoneCubit.close();
    super.dispose();
  }

  Future<void> updateDeviceStatus(Device device, String status) async {
    deviceId = device.id;
    if (deviceId == null) {
      print('Device ID is null. Cannot update device status.');
      return;
    }

    try {
      device.status = status;
      print('Updating device status to: $status for device ID: $deviceId');
      await _crudController.update(device.id!, device.toJson());
      if (userId != null) {
        await _phoneCubit
            .getDevicesByUserId(userId!); // تحديث قائمة الأجهزة بعد التعديل
        print('Device status updated successfully.');
      } else {
        print('userId is null. Cannot fetch devices.');
      }
    } catch (e) {
      print('Error updating device status: $e');
    }
  }

  void notifyClient(
      double cost, String issue, DateTime expectedDeliveryDate) async {
    Device? device;
    if (device!.id == null) {
      print('Device ID is null. Cannot notify client.');
      return;
    }

    device.status = 'بانتظار استجابة العميل';

    try {
      await _crudController.update(device.id!, device.toJson());
      if (userId != null) {
        _phoneCubit.getDevicesByUserId(userId!);
        print('Notification sent to client');
        SnackBarAlert().alert("Notification sent to client",
            color: const Color.fromRGBO(0, 200, 0, 1), title: "Notification");
      } else {
        print('userId is null. Cannot fetch devices.');
      }
    } catch (e) {
      print('Error notifying client: $e');
    }
  }

  void logout() async {
    if (await BlocProvider.of<loginCubit>(context).logout()) {
      SnackBarAlert().alert("Logout successfully",
          color: const Color.fromRGBO(0, 200, 0, 1), title: "Successfully");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
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
            Row(children: [
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
                  if (state is PhoneSuccess) {
                    return ListView.builder(
                      itemCount: state.device.length,
                      itemBuilder: (context, index) {
                        final device = state.device[index];
                        return GestureDetector(
                          onTap: () {},
                          child: Card(
                            color: const Color.fromARGB(255, 252, 234, 251),
                            child: ListTile(
                              leadingAndTrailingTextStyle: const TextStyle(
                                  fontFamily: AutofillHints.birthday),
                              title: Text(device.model),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(device.status),
                                  Text(device.imei)
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (device.status == 'قيد العمل') ...[
                                    IconButton(
                                      onPressed: () {
                                        // هنا يتم تحديد نتيجة العمل كجاهز
                                        print('22222222222222222222');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const UpdateStatus(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                          Icons.check_circle_outlined),
                                    ),
                                  ] else ...[
                                    IconButton(
                                      onPressed: () async {
                                        if (device.status == 'يتم فحصه') {
                                          // تغيير الحالة إلى "بانتظار استجابة العميل"
                                          await updateDeviceStatus(
                                              device, 'بانتظار استجابة العميل');
                                          _showStatusDialog(
                                              device.status,
                                              device,
                                              (newvalue) =>
                                                  device.status = newvalue);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AddDetalis(
                                                device: device,
                                              ),
                                            ),
                                          );
                                        }

                                        if (device.status ==
                                            'لم يتم بدء العمل فيه') {
                                          // تغيير الحالة إلى "يتم فحصه"
                                          print('gggggggggggggggggggggggg');

                                          await updateDeviceStatus(
                                              device, device.status);
                                          _showStatusDialog(
                                              device.status,
                                              device,
                                              (newvalue) =>
                                                  device.status = newvalue);
                                        }
                                        if (device.status == 'لا يصلح' ||
                                            device.status ==
                                                'لم يوافق على لعمل به') {
                                          //ارسال اشعار للعميل كيف يريد ان يستلمه
                                        }
                                      },
                                      icon: const Icon(Icons.tips_and_updates),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
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
    );
  }

  void _showStatusDialog(String title, Device device, Function(String) onSave) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('هل تريد ابقاء الحالة $title'),
          actions: <Widget>[
            TextButton(
              child: const Text('لا'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpdateStatus(),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text('نعم'),
              onPressed: () {
                onSave(title);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddDetalis(
                      device: device,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
