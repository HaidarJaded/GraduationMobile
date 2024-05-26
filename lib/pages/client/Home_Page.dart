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

  Future fetch() async {
    userId = await InstanceSharedPrefrences().getId();
    _crudController = CrudController<Device>();

    _phoneCubit.getDevicesByUserId(userId!);
    print('fetch');
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
    // هنا يتم تحديث حالة الجهاز
    device.status = status;
    await _crudController.update(
        device.id.hashCode, device as Map<String, dynamic>);
    _phoneCubit.getDevicesByUserId(userId!); // تحديث قائمة الأجهزة بعد التعديل
  }

  void notifyClient(Device device, double cost, String issue,
      DateTime expectedDeliveryDate) async {
    // هنا يتم إشعار العميل بالتفاصيل
    device.status = 'بانتظار استجابة العميل';
    device.costToCustomer = cost;
    device.problem = issue;
    device.expectedDateOfDelivery = expectedDeliveryDate;
    await _crudController.update(
        device.id.hashCode, device as Map<String, dynamic>);
    _phoneCubit.getDevicesByUserId(userId!); // تحديث قائمة الأجهزة بعد التعديل
    // إرسال الإشعار
    SnackBarAlert().alert("Notification sent to client",
        color: const Color.fromRGBO(0, 200, 0, 1), title: "Notification");
  }

  void logout() async {
    if (await BlocProvider.of<loginCubit>(context).logout()) {
      SnackBarAlert().alert("Logout successfuly",
          color: const Color.fromRGBO(0, 200, 0, 1), title: "Successfuly");
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
                  if (state is PhoneSuccess) {
                    print('Loaded devices: ${state.device}');
                    return ListView.builder(
                      itemCount: state.device.length,
                      itemBuilder: (context, index) {
                        final device = state.device[index];
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
                                            DateTime(2024, 22, 1));
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
                      },
                    );
                  } else if (state is PhoneFailure) {
                    return Center(
                      child:
                          Text('Failed to load devices: ${state.errorMessage}'),
                    );
                  } else {
                    print('===============');
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
