// ignore_for_file:  file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:graduation_mobile/bar/SearchAppBar.dart';
import 'package:graduation_mobile/bar/custom_drawer.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/user_model.dart';
import 'package:graduation_mobile/order/add_order_form.dart';

import 'package:graduation_mobile/order/cubit/order_cubit.dart';

class ordersPage extends StatefulWidget {
  final int? orderId;

  const ordersPage({super.key, this.orderId});

  @override
  State<ordersPage> createState() => _orderState();
}

enum OrderTypes {
  product,
  device,
}

class _orderState extends State<ordersPage> {
  bool hasAddingOrderPermission = false;
  bool hasSelectDevicesOrderPermission = false;
  bool hasSelectProductsOrderPermission = false;
  bool readyToBuild = false;
  Future confirmOrder(OrderTypes orderType, var orderItem) async {
    if (orderType == OrderTypes.device) {
      var response = await Api().put(
          path: 'api/devices_orders/${orderItem['id']}',
          body: {'deliver_to_client': 1});
      if (response == null) {
        return;
      }
    } else {
      var response = await Api().put(
          path: 'api/product_orders/${orderItem['id']}',
          body: {'deliver_to_client': 1});
      if (response == null) {
        return;
      }
    }
    setState(() {
      orderItem['deliver_to_client'] = 1;
    });
    SnackBarAlert().alert("شكراً جزيلا لتعاونك",
        title: "تم استلام الجهاز",
        color: const Color.fromARGB(255, 51, 48, 247));
  }

  Future<bool> isDeliverToClinet(OrderTypes orderType, var orderItem) async {
    if (orderItem == null) {
      return false;
    }
    var deliverToClient = orderItem['deliver_to_client'];
    var orderType = orderItem['order_type'];
    return deliverToClient == 1 || orderType == 'تسليم للمركز';
  }

  Future checkPermission() async {
    bool hasAddingOrderPermission = await User.hasPermission('اضافة طلب') &&
        await User.hasPermission('اضافة طلب لجهاز');
    bool hasSelectDevicesOrderPermission =
        await User.hasPermission('استعلام عن طلبات الاجهزة');
    bool hasSelectProductsOrderPermission =
        await User.hasPermission('استعلام عن طلبات المنتجات');
    setState(() {
      this.hasAddingOrderPermission = hasAddingOrderPermission;
      this.hasSelectDevicesOrderPermission = hasSelectDevicesOrderPermission;
      this.hasSelectProductsOrderPermission = hasSelectProductsOrderPermission;
      readyToBuild = true;
    });
  }

  int getIndexOfId(List items, int id) {
    int index = items.indexWhere((element) => element.id == id);
    return index;
  }

  @override
  void initState() {
    super.initState();
    InstanceSharedPrefrences().getId().then((clientId) {
      BlocProvider.of<OrderCubit>(Get.context!).getOrder({
        'with': 'devices,products,devices_orders,products_orders',
        'done': 0,
        'all_data': 1,
        'orderBy': 'date',
        'dir': 'desc',
        'client_id': clientId
      });
    });
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 87, 42, 170),
                title: const Text('MYP'),
              ),
              drawer: const CustomDrawer(),
              body: Container(
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator())));
        }
        if (state is OrderSucess) {
          if (widget.orderId != null) {
            int index = getIndexOfId(state.data.items!, widget.orderId!);
            if (index != -1) {
              var order = state.data.items![index];
              state.data.items!.removeAt(index);
              state.data.items!.insert(0, order);
            }
          }
          return Scaffold(
              floatingActionButton: readyToBuild
                  ? hasAddingOrderPermission
                      ? FloatingActionButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AddOrderForm();
                                });
                          },
                          child: const Icon(Icons.add),
                        )
                      : null
                  : const CircularProgressIndicator(),
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 87, 42, 170),
                title: const Text('MYP'),
              ),
              drawer: const CustomDrawer(),
              body: Container(
                  padding: const EdgeInsets.all(5),
                  child: ListView.builder(
                      itemCount: state.data.items!.length + 1,
                      itemBuilder: (context, orderIndex) {
                        if (orderIndex >= state.data.items!.length) {
                          if (state.data.items!.isEmpty) {
                            return const Center(
                              child: Text("لا يوجد طلبات"),
                            );
                          }
                          return const SizedBox();
                        }
                        var order = state.data.items?[orderIndex];
                        if (order == null) {
                          return const SizedBox();
                        }
                        return ExpansionTile(
                          title: Text(order.description ?? "طلب"),
                          initiallyExpanded: order.id == widget.orderId,
                          children: [
                            if (order.devices != null &&
                                hasSelectDevicesOrderPermission)
                              for (var device in order.devices)
                                Card(
                                  child: ListTile(
                                    title: Text("Device: ${device.model}"),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('IMEI: ${device.imei}'),
                                        Text('Code: ${device.code}'),
                                        Text(
                                            'نوع الطلب: ${order.devicesOrders.firstWhere((deviceOrder) => deviceOrder['device_id'] == device.id, orElse: () => null)?['order_type']}'),
                                        FutureBuilder(
                                          future: isDeliverToClinet(
                                              OrderTypes.device,
                                              order.devicesOrders.firstWhere(
                                                  (deviceOrder) =>
                                                      deviceOrder[
                                                          'device_id'] ==
                                                      device.id,
                                                  orElse: () => null)),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                    ConnectionState.done &&
                                                snapshot.hasData &&
                                                !snapshot.data!) {
                                              if (order.devicesOrders.firstWhere(
                                                          (deviceOrder) =>
                                                              deviceOrder[
                                                                  'device_id'] ==
                                                              device.id,
                                                          orElse: () => null)[
                                                      'deliver_to_user'] ==
                                                  1) {
                                                return MaterialButton(
                                                  onPressed: () async {
                                                    await confirmOrder(
                                                        OrderTypes.device,
                                                        order.devicesOrders
                                                            .firstWhere(
                                                                (deviceOrder) =>
                                                                    deviceOrder[
                                                                        'device_id'] ==
                                                                    device.id,
                                                                orElse: () =>
                                                                    null));
                                                  },
                                                  color: const Color.fromRGBO(
                                                      150, 150, 150, 0.5),
                                                  child: const Text(
                                                      "تأكيد استلام الطلب"),
                                                );
                                              } else {
                                                return const SizedBox();
                                              }
                                            } else if (snapshot.hasData &&
                                                snapshot.data!) {
                                              return order.devicesOrders.firstWhere(
                                                              (deviceOrder) =>
                                                                  deviceOrder[
                                                                      'device_id'] ==
                                                                  device.id,
                                                              orElse: () =>
                                                                  null)?[
                                                          'order_type'] ==
                                                      'تسليم للمركز'
                                                  ? const SizedBox()
                                                  : const Card(
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
                                ),
                            if (order.products != null &&
                                hasSelectProductsOrderPermission)
                              for (var product in order.products)
                                Card(
                                  child: ListTile(
                                    title: Text("المنتج: ${product.name}"),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('السعر: ${product.price}'),
                                        FutureBuilder(
                                          future: isDeliverToClinet(
                                              OrderTypes.product,
                                              order.productsOrders.firstWhere(
                                                  (productOrder) =>
                                                      productOrder[
                                                          'product_id'] ==
                                                      product.id,
                                                  orElse: () => null)),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                    ConnectionState.done &&
                                                snapshot.hasData &&
                                                !snapshot.data!) {
                                              if (order.productsOrders.firstWhere(
                                                          (productOrder) =>
                                                              productOrder[
                                                                  'product_id'] ==
                                                              product.id,
                                                          orElse: () => null)[
                                                      'deliver_to_user'] ==
                                                  1) {
                                                return MaterialButton(
                                                  onPressed: () async {
                                                    confirmOrder(
                                                        OrderTypes.product,
                                                        order.productsOrders
                                                            .firstWhere(
                                                                (productOrder) =>
                                                                    productOrder[
                                                                        'product_id'] ==
                                                                    product.id,
                                                                orElse: () =>
                                                                    null));
                                                  },
                                                  color: const Color.fromRGBO(
                                                      150, 150, 150, 0.5),
                                                  child: const Text(
                                                      "تأكيد استلام الطلب"),
                                                );
                                              } else {
                                                return const SizedBox();
                                              }
                                            } else if (snapshot.hasData &&
                                                snapshot.data!) {
                                              return const Card(
                                                color: Color.fromARGB(
                                                    255, 12, 74, 207),
                                                child: Text(
                                                  " تم استلامه  ",
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          255, 255, 255, 1)),
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
                      })));
        }
        if (state is OrderFailur) {
          SnackBarAlert().alert(state.errorMessage);
          return Scaffold(
            appBar: SearchAppBar(),
            drawer: const CustomDrawer(),
            body: Center(child: Text(state.errorMessage)),
          );
        }
        return Scaffold(
          appBar: SearchAppBar(),
          drawer: const CustomDrawer(),
          body: const Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text("nothing")
            ],
          ),
        );
      },
    );
  }
}
