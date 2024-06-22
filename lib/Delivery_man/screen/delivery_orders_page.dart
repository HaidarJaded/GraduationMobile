// ignore_for_file: camel_case_types, non_constant_identifier_names, unnecessary_const, avoid_unnecessary_containers, must_be_immutable, body_might_complete_normally_nullable, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graduation_mobile/bar/SearchAppBar.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/order_model.dart';
import 'package:graduation_mobile/models/user_model.dart';

class DeliveryOrdersPage extends StatefulWidget {
  DeliveryOrdersPage(
      {super.key,
      required this.clientOrders,
      required this.clientName,
      this.orderIdFromNotification});
  List<Order> clientOrders;
  String clientName;
  int? orderIdFromNotification;
  @override
  State<DeliveryOrdersPage> createState() => _ordersState();
}

enum OrderTypes {
  product,
  device,
}

class _ordersState extends State<DeliveryOrdersPage> {
  bool hasAddingOrderPermission = false;
  bool hasSelectDevicesOrderPermission = false;
  bool hasSelectProductsOrderPermission = false;
  Future checkPermission() async {
    hasAddingOrderPermission = await User.hasPermission('اضافة طلب');
    hasSelectDevicesOrderPermission =
        await User.hasPermission('استعلام عن طلبات الاجهزة');
    hasSelectProductsOrderPermission =
        await User.hasPermission('استعلام عن طلبات المنتجات');
  }

  Future<bool> isDeliverToUser(order) async {
    if (order == null) {
      return false;
    }
    if (order['deliver_to_user'] == 1) {
      return true;
    }
    return false;
  }

  Future confirmOrder(OrderTypes orderType, var orderItem) async {
    if (orderType == OrderTypes.device) {
      var response = await Api().put(
          path: 'api/devices_orders/${orderItem['id']}',
          body: {'deliver_to_user': 1});
      if (response == null) {
        return;
      }
    } else {
      var response = await Api().put(
          path: 'api/product_orders/${orderItem['id']}',
          body: {'deliver_to_user': 1});
      if (response == null) {
        return;
      }
    }
    setState(() {
      orderItem['deliver_to_user'] = 1;
    });
    SnackBarAlert().alert("شكراً جزيلا لتعاونك",
        title: "تم استلام الجهاز",
        color: const Color.fromARGB(255, 51, 48, 247));
  }

  @override
  void dispose() {
    super.dispose();
    setState(() {
      widget.orderIdFromNotification = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 87, 42, 170),
          title: Text(widget.clientName),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: search());
              },
            ),
          ],
        ),
        body: Container(
            child: Container(
                padding: const EdgeInsets.all(5),
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: widget.clientOrders.length,
                    itemBuilder: (context, orderIndex) {
                      if (orderIndex >= widget.clientOrders.length) {
                        if (widget.clientOrders.isEmpty) {
                          return const Center(
                            child: Text("لا يوجد طلبات"),
                          );
                        }
                        return const SizedBox();
                      }
                      var order = widget.clientOrders[orderIndex];
                      return FutureBuilder(
                          future: checkPermission(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return ExpansionTile(
                                initiallyExpanded:
                                    order.id == widget.orderIdFromNotification,
                                title: Text(order.description ?? "طلب"),
                                children: [
                                  if (order.devices != null &&
                                      hasSelectDevicesOrderPermission)
                                    for (var device in order.devices!)
                                      Card(
                                        child: ListTile(
                                          title:
                                              Text("Device: ${device.model}"),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('IMEI: ${device.imei}'),
                                              Text('Code: ${device.code}'),
                                              Text(
                                                  'نوع الطلب: ${order.devicesOrders.firstWhere((deviceOrder) => deviceOrder['device_id'] == device.id, orElse: () => null)?['order_type']}'),
                                              FutureBuilder(
                                                future: isDeliverToUser(order
                                                    .devicesOrders
                                                    .firstWhere(
                                                        (deviceOrder) =>
                                                            deviceOrder[
                                                                'device_id'] ==
                                                            device.id,
                                                        orElse: () => null)),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState ==
                                                          ConnectionState
                                                              .done &&
                                                      snapshot.hasData &&
                                                      !snapshot.data!) {
                                                    return MaterialButton(
                                                      onPressed: () async {
                                                        await confirmOrder(
                                                            OrderTypes.device,
                                                            order.devicesOrders.firstWhere(
                                                                (deviceOrder) =>
                                                                    deviceOrder[
                                                                        'device_id'] ==
                                                                    device.id,
                                                                orElse: () =>
                                                                    null));
                                                      },
                                                      color:
                                                          const Color.fromRGBO(
                                                              150,
                                                              150,
                                                              150,
                                                              0.5),
                                                      child: const Text(
                                                          "تأكيد استلام الطلب"),
                                                    );
                                                  } else if (snapshot.hasData &&
                                                      snapshot.data!) {
                                                    return const Card(
                                                      color: Color.fromARGB(
                                                          255, 12, 74, 207),
                                                      child: Text(
                                                        " تم استلامه  ",                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1)),
                                                      ),
                                                    );
                                                  }
                                                  return const SizedBox(
                                                    width: 25,
                                                    height: 25,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  if (order.products != null &&
                                      hasSelectProductsOrderPermission)
                                    for (var product in order.products!)
                                      Card(
                                        child: ListTile(
                                          title:
                                              Text("المنتج: ${product.name}"),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('السعر: ${product.price}'),
                                              FutureBuilder(
                                                future: isDeliverToUser(order
                                                    .productsOrders
                                                    .firstWhere(
                                                        (productOrder) =>
                                                            productOrder[
                                                                'product_id'] ==
                                                            product.id,
                                                        orElse: () => null)),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState ==
                                                          ConnectionState
                                                              .done &&
                                                      snapshot.hasData &&
                                                      !snapshot.data!) {
                                                    return MaterialButton(
                                                      onPressed: () async {
                                                        confirmOrder(
                                                            OrderTypes.product,
                                                            order.productsOrders.firstWhere(
                                                                (productOrder) =>
                                                                    productOrder[
                                                                        'product_id'] ==
                                                                    product.id,
                                                                orElse: () =>
                                                                    null));
                                                      },
                                                      color:
                                                          const Color.fromRGBO(
                                                              150,
                                                              150,
                                                              150,
                                                              0.5),
                                                      child: const Text(
                                                          "تأكيد استلام الطلب"),
                                                    );
                                                  } else if (snapshot.hasData &&
                                                      snapshot.data!) {
                                                    return const Card(
                                                      color: Color.fromARGB(
                                                          255, 12, 74, 207),
                                                      child: Text(
                                                        " تم استلامه  ",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1)),
                                                      ),
                                                    );
                                                  }
                                                  return const SizedBox(
                                                    width: 25,
                                                    height: 25,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                ],
                              );
                            }
                            return Container();
                          });
                    }))));
  }
}
