import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/Controllers/returned_object.dart';
import 'package:graduation_mobile/allDevices/screen/TextFormField.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/order/cubit/order_cubit.dart';

class AddOrderForm extends StatefulWidget {
  const AddOrderForm({super.key});

  @override
  State<AddOrderForm> createState() => _AddOrderFormState();
}

enum OrderTypes { sending, reciveing }

class _AddOrderFormState extends State<AddOrderForm> {
  String? _selectedOrderType;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  TextEditingController deviceCodeController = TextEditingController();
  bool areThereDeliveries = false;
  bool isCodeOk = false;

  Future<bool> areThereDelivery() async {
    var response = await Api().get(path: 'api/are_there_deliveries');
    if (response == null) {
      return false;
    }
    final body = response['body'];
    if (body.length == 0) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    areThereDelivery().then((areThereDelivery) {
      setState(() {
        areThereDeliveries = areThereDelivery;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('اضافة طلب جديد'),
      content: Form(
        key: globalKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropdownButton<String>(
              hint: const Text('نوع الطلب'),
              value: _selectedOrderType,
              onChanged: (String? value) {
                setState(() {
                  _selectedOrderType = value;
                });
              },
              items: OrderTypes.values.map((OrderTypes orderType) {
                return DropdownMenuItem<String>(
                  value: orderType == OrderTypes.sending
                      ? 'تسليم للمركز'
                      : 'تسليم للعميل',
                  child: Text(orderType == OrderTypes.sending
                      ? 'ارسال للمركز'
                      : 'إحضار من المركز'),
                );
              }).toList(),
            ),
            textFormField(
              labelText: "كود الجهاز",
              icon: const Icon(Icons.ad_units),
              controller: deviceCodeController,
              validator: (value) {
                if (value.length == 0) {
                  return 'الرجاء تعبئة حقل الكود';
                }
              },
            )
          ],
        ),
      ),
      actions: <Widget>[
        FloatingActionButton(
          child: const Text('اضافة'),
          onPressed: () async {
            if (globalKey.currentState!.validate()) {
              if (!areThereDeliveries) {
                bool reCheckDelivery = await areThereDelivery();
                if (!reCheckDelivery) {
                  SnackBarAlert()
                      .alert("عذراً لا يوجد عمّال توصيل في الوقت الحالي");
                  return;
                }
                setState(() {
                  areThereDeliveries = reCheckDelivery;
                });
              }
              if (_selectedOrderType == null) {
                SnackBarAlert().alert("الرجاء اختيار نوع الطلب");
                return;
              }
              int? clientId = await InstanceSharedPrefrences().getId();
              if (clientId == null) {
                Get.back();
                return;
              }
              ReturnedObject? response = await CrudController<Device>().getAll({
                'client_id': clientId,
                'code': deviceCodeController.text,
                'with': 'orders',
                'deliver_to_client': 0,
              });
              Device? device =
                  response.items!.isEmpty ? null : response.items![0];
              if (device == null) {
                SnackBarAlert().alert("الرجاء ادخال كود صالح");
                return;
              }
              if (device.orders != null &&
                  device.orders!.isNotEmpty &&
                  device.orders!.where((order) => order.done == 0).isNotEmpty) {
                SnackBarAlert().alert("الجهاز المطلوب موجود في الطلبات مسبقاً");
                return;
              }
              if (_selectedOrderType == 'تسليم للعميل' &&
                  device.dateReceipt == null) {
                SnackBarAlert().alert("عذراً الجهاز غير موجود بالمركز");
                return;
              }
              if (_selectedOrderType == 'تسليم للمركز' &&
                  device.dateReceipt != null) {
                SnackBarAlert().alert("عذراً الجهاز موجود بالمركز مسبقاً");
                return;
              }
              List<String> orederableStatus = [
                'جاهز',
                'غير جاهز',
                'لم يتم بدء العمل فيه',
                'لم يوافق على العمل به',
                'لا يصلح'
              ];
              if (!orederableStatus.contains(device.status)) {
                SnackBarAlert()
                    .alert("عذراً لا يمكن اضافة طلب لجهاز قيد العمل");
                return;
              }
              var devicesList = [];

              devicesList = devicesList
                  .map((device) => {device.id.toString(): _selectedOrderType})
                  .toList();
              Map<String, dynamic> requestBody = {
                // 'devices_ids': {device.id.toString(): _selectedOrderType},
                'client_id': clientId,
                'description': _selectedOrderType == 'تسليم للعميل'
                    ? 'توصيل طلب الى العميل'
                    : 'توصيل طلب للمركز'
              };
              var addingOrderResponse =
                  await Api().post(path: 'api/orders', body: requestBody);
              if (addingOrderResponse != null) {
                BlocProvider.of<OrderCubit>(Get.context!).getOrder({
                  'with': 'devices,products,devices_orders,products_orders',
                  'done': 0,
                  'all_data': 1,
                  'orderBy': 'date',
                  'dir': 'desc',
                  'client_id': clientId
                });
                SnackBarAlert().alert("تمت الاضافة بنجاح",
                    title: 'تمت الاضافة',
                    color: const Color.fromRGBO(0, 200, 0, 1));
              }
              Navigator.of(Get.context!).pop();
            }
          },
        ),
        FloatingActionButton(
          child: const Text('الغاء'),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    );
  }
}
