import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/client_model.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/models/user_model.dart';
import 'package:graduation_mobile/pages/client/add_detalis.dart';
import 'package:graduation_mobile/pages/client/cubit/phone_cubit/phone_cubit.dart';
import 'package:graduation_mobile/pages/client/update_status_page.dart';
import 'package:graduation_mobile/pages/client/widget/device_info.dart';

class DevicesByClient extends StatefulWidget {
  final Client client;
  const DevicesByClient({super.key, required this.client});

  @override
  State<DevicesByClient> createState() => _DevicesByClientState();
}

class _DevicesByClientState extends State<DevicesByClient> {
  int currentPage = 1;
  List<dynamic> devices = [];
  bool readyToBuild = false;
  bool firstTime = true;
  int pagesCount = 0;
  int perPage = 20;
  int? userId;
  late CrudController<Device> _crudController;
  late PhoneCubit _phoneCubit;
  final scrollController = ScrollController();
  int totalCount = 0;

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
            'page': 1,
            'per_page': perPage,
            'orderBy': 'client_priority',
            'user_id': userId,
            'client_id': widget.client.id,
            'deliver_to_client': 0,
            'with': 'client'
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 87, 42, 170),
        title: Text(widget.client.name),
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

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      currentPage = 1;
      devices.clear();
      fetchDevices(currentPage);
    });
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
              'التكلفة:', "${device.costToClient ?? 'لم يحدد بعد'}"),
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
      if (totalCount == 0) {
        return const Center(
          child: Text('لا يوجد أجهزة'),
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (devices.length >= 20) {
      return const Center(
        child: Text('لا يوجد المزيد'),
      );
    } else {
      return const SizedBox();
    }
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

  Future<void> updateDeviceStatus(Device device, String status) async {
    // هنا يتم تحديث حالة الجهاز
    setState(() {
      device.status = status;
    });
    await _crudController.update(device.id!, {'status': status});
  }

  Future<void> fetchDevices([int page = 1, int perPage = 20]) async {
    try {
      if (currentPage > pagesCount) {
        return;
      }
      var data = await CrudController<Device>().getAll({
        'page': currentPage,
        'per_page': perPage,
        'orderBy': 'client_priority',
        'with': 'client',
        'user_id': userId,
        'client_id': widget.client.id,
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
      return;
    }
  }
}
