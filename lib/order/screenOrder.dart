// ignore_for_file: avoid_unnecessary_containers, unnecessary_const, unnecessary_import, unnecessary_string_interpolations, body_might_complete_normally_nullable, file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:graduation_mobile/bar/SearchAppBar.dart';
import 'package:graduation_mobile/bar/custom_drawer.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/user_model.dart';

import 'package:graduation_mobile/order/cubit/order_cubit.dart';

class order extends StatefulWidget {
  const order({super.key});

  @override
  State<order> createState() => _orderState();
}

enum OrderTypes {
  product,
  device,
}

class _orderState extends State<order> {
  bool hasAddingOrderPermission = false;
  bool hasSelectDevicesOrderPermission = false;
  bool hasSelectProductsOrderPermission = false;

  Future confirmOrder(OrderTypes orderType, int orderId) async {
    if (orderType == OrderTypes.device) {
      var response = await Api().put(
          path: 'api/devices_orders/$orderId', body: {'deliver_to_client': 1});
      if (response == null) {
        return;
      }
    } else {
      var response = await Api().put(
          path: 'api/product_orders/$orderId', body: {'deliver_to_client': 1});
      if (response == null) {
        return;
      }
    }
    SnackBarAlert().alert("شكراً جزيلا لتعاونك",
        title: "تم استلام الجهاز",
        color: const Color.fromARGB(255, 51, 48, 247));
    BlocProvider.of<OrderCubit>(Get.context!).getOrder({
      'with': 'devices,products,devices_orders,products_orders',
      'done': 0,
      'all_data': 1
    });
  }

  Future<bool> isDeliverToClinet(OrderTypes orderType, int? orderId) async {
    if (orderId == null) {
      return false;
    }
    if (orderType == OrderTypes.device) {
      var response = await Api().get(path: 'api/devices_orders/$orderId');
      if (response != null) {
        var deliverToClient = response['body']['deliver_to_client'];
        return deliverToClient == 1;
      }
    } else {
      var response = await Api().get(path: 'api/product_orders/$orderId');
      if (response != null) {
        var deliverToClient = response['body']['deliver_to_client'];
        return deliverToClient == 1;
      }
    }
    return false;
  }

  Future checkPermission() async {
    hasAddingOrderPermission = await User.hasPermission('اضافة طلب');
    hasSelectDevicesOrderPermission =
        await User.hasPermission('استعلام عن طلبات الاجهزة');
    hasSelectProductsOrderPermission =
        await User.hasPermission('استعلام عن طلبات المنتجات');
  }

  @override
  void initState() {
    super.initState();
    InstanceSharedPrefrences().getId().then((clientId) {
      BlocProvider.of<OrderCubit>(Get.context!).getOrder({
        'with': 'devices,products,devices_orders,products_orders',
        'done': 0,
        'all_data': 1,
        'orderBy': 'created_at',
        'dir': 'desc',
        'client_id': clientId
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return Scaffold(
              appBar: SearchAppBar(),
              body: const Center(
                child: const CircularProgressIndicator(),
              ));
        }
        if (state is OrderSucess) {
          return Scaffold(
              appBar: SearchAppBar(),
              drawer: const CustomDrawer(),
              body: Container(
                  child: Container(
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
                            return FutureBuilder(
                                future: checkPermission(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return ExpansionTile(
                                      title: Text(order.description ?? "طلب"),
                                      children: [
                                        if (order.devices != null &&
                                            hasSelectDevicesOrderPermission)
                                          for (var device in order.devices)
                                            Card(
                                              child: ListTile(
                                                title: Text(
                                                    "Device: ${device.model}"),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'IMEI: ${device.imei}'),
                                                    Text(
                                                        'Code: ${device.code}'),
                                                    FutureBuilder(
                                                      future: isDeliverToClinet(
                                                          OrderTypes.device,
                                                          order.devicesOrders.firstWhere(
                                                              (deviceOrder) =>
                                                                  deviceOrder[
                                                                      'device_id'] ==
                                                                  device.id,
                                                              orElse: () =>
                                                                  null)?['id']),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.connectionState ==
                                                                ConnectionState
                                                                    .done &&
                                                            snapshot.hasData &&
                                                            !snapshot.data!) {
                                                          return MaterialButton(
                                                            onPressed:
                                                                () async {
                                                             await confirmOrder(
                                                                  OrderTypes
                                                                      .device,
                                                                  order.devicesOrders.firstWhere(
                                                                      (deviceOrder) =>
                                                                          deviceOrder[
                                                                              'device_id'] ==
                                                                          device
                                                                              .id,
                                                                      orElse: () =>
                                                                          null)?['id']);
                                                            },
                                                            color: const Color
                                                                .fromRGBO(150,
                                                                150, 150, 0.5),
                                                            child: const Text(
                                                                "تأكيد استلام الطلب"),
                                                          );
                                                        } else if (snapshot
                                                                .hasData &&
                                                            snapshot.data!) {
                                                          return const Card(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    12,
                                                                    74,
                                                                    207),
                                                            child: Text(
                                                              " تم استلامه  ",
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          1)),
                                                            ),
                                                          );
                                                        }
                                                        return const SizedBox(width: 25,height: 25,child: CircularProgressIndicator(),);
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
                                                title: Text(
                                                    "المنتج: ${product.name}"),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'السعر: ${product.price}'),
                                                    FutureBuilder(
                                                      future: isDeliverToClinet(
                                                          OrderTypes.product,
                                                          order.productsOrders.firstWhere(
                                                              (productOrder) =>
                                                                  productOrder[
                                                                      'product_id'] ==
                                                                  product.id,
                                                              orElse: () =>
                                                                  null)?['id']),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.connectionState ==
                                                                ConnectionState
                                                                    .done &&
                                                            snapshot.hasData &&
                                                            !snapshot.data!) {
                                                          return MaterialButton(
                                                            onPressed:
                                                                () async {
                                                              confirmOrder(
                                                                  OrderTypes
                                                                      .product,
                                                                  order.productsOrders.firstWhere(
                                                                      (productOrder) =>
                                                                          productOrder[
                                                                              'product_id'] ==
                                                                          product
                                                                              .id,
                                                                      orElse: () =>
                                                                          null)?['id']);
                                                            },
                                                            color: const Color
                                                                .fromRGBO(150,
                                                                150, 150, 0.5),
                                                            child: const Text(
                                                                "تأكيد استلام الطلب"),
                                                          );
                                                        } else if (snapshot
                                                                .hasData &&
                                                            snapshot.data!) {
                                                          return const Card(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    12,
                                                                    74,
                                                                    207),
                                                            child: Text(
                                                              " تم استلامه  ",
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          1)),
                                                            ),
                                                          );
                                                        }
                                                        return const SizedBox(width: 25,height: 25,child: CircularProgressIndicator(),);
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
        if (state is OrderFailur) {
          SnackBarAlert().alert("${state.errorMessage}");
          return Scaffold(
            appBar: SearchAppBar(),
            drawer: const CustomDrawer(),
            body: Center(child: Text("${state.errorMessage}")),
          );
        }
        return Scaffold(
          appBar: SearchAppBar(),
          drawer: const CustomDrawer(),
          body: Container(
            child: const Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text("nothing")
              ],
            ),
          ),
        );
      },
    );
  }
}
