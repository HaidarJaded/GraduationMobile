// ignore_for_file: camel_case_types, body_might_complete_normally_nullable, unnecessary_import, avoid_unnecessary_containers, file_names, prefer_const_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:graduation_mobile/Delivery_man/cubit/delivery_man_cubit.dart';
import 'package:graduation_mobile/Delivery_man/screen/drawerDelivery.dart';
import 'package:graduation_mobile/Delivery_man/screen/delivery_orders_page.dart';
import 'package:collection/collection.dart';
import 'package:graduation_mobile/helper/api.dart';

import 'package:graduation_mobile/models/order_model.dart';
import '../../Controllers/crud_controller.dart';
import '../../helper/shared_perferences.dart';

class Delivery_man extends StatefulWidget {
  final int? orderId;

  const Delivery_man({super.key, this.orderId});

  @override
  State<Delivery_man> createState() => _Delivery_manState();
}

class _Delivery_manState extends State<Delivery_man> {
  Map<int?, List<dynamic>> orders = {};
  bool firstTime = true;
  bool readyToBuild = false;
  final controller = ScrollController();
  int? userId;
  bool isAtWork = false;
  int getIndexOfId(List items, int id) {
    int index = items.indexWhere((element) => element.id == id);
    return index;
  }

  @override
  void initState() {
    super.initState();
    readyToBuild = false;
    InstanceSharedPrefrences().isAtWork().then((isAtWork) {
      setState(() {
        this.isAtWork = isAtWork;
      });
    });
    InstanceSharedPrefrences()
        .getId()
        .then((id) => {
              userId = id,
              BlocProvider.of<DeliveryManCubit>(Get.context!).getorderData({
                'orderBy': 'date',
                'done': 0,
                'dir': 'desc',
                'with':
                    'devices,products,devices_orders,products_orders,client',
                'user_id': userId,
                'all_data': 1,
              })
            })
        .then((value) => readyToBuild = true);
  }

  int? clientId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryManCubit, DeliveryManState>(
      builder: (context, state) {
        if (state is DeliveryManLoading || readyToBuild == false) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 87, 42, 170),
                title: const Text('MYP'),
              ),
              body: Container(
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator())));
        }
        if (state is DeliveryManSucces) {
          if (firstTime) {
            orders = groupBy(state.data.items!, (order) => order.client?.id);
            firstTime = false;
          }
          if (widget.orderId != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              int? clientId = orders.entries
                  .firstWhereOrNull(
                    (entry) =>
                        entry.value.any((order) => order.id == widget.orderId),
                  )
                  ?.key;
              if (clientId != null) {
                var clientOrders = orders[clientId] ?? [];
                int index = getIndexOfId(clientOrders, widget.orderId!);
                if (index != -1) {
                  var order = clientOrders[index];
                  clientOrders.removeAt(index);
                  clientOrders.insert(0, order);
                }
                Get.to(() => DeliveryOrdersPage(
                      clientOrders: orders[clientId]!.cast<Order>(),
                      clientName: (orders[clientId]!.cast<Order>())
                              .first
                              .client
                              ?.name ??
                          'عميل',
                      orderIdFromNotification: widget.orderId,
                    ));
              }
            });
          }
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
            drawer: draweDelivery(
              userId: userId!,
            ),
            body: Container(
              child: Container(
                  padding: const EdgeInsets.all(5),
                  child: RefreshIndicator(
                      onRefresh: _refreshData,
                      child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          controller: controller,
                          itemCount: orders.length + 1,
                          itemBuilder: (context, i) {
                            if (i >= orders.length) {
                              return Center(
                                child: const Text('لا يوجد طلبات'),
                              );
                            }
                            int? key = orders.keys.elementAt(i);
                            List<Order>? groupedItems =
                                orders[key]?.cast<Order>();
                            String? centerName =
                                groupedItems?.first.client?.centerName;
                            String? clientAddress =
                                groupedItems?.first.client?.address;
                            String? clientName =
                                groupedItems?.first.client?.name;
                            return Column(
                              children: [
                                MaterialButton(
                                    color: Color.fromARGB(255, 247, 236, 240),
                                    onPressed: () {
                                      Get.to(() => DeliveryOrdersPage(
                                            clientOrders: groupedItems!,
                                            clientName: clientName ?? 'عميل',
                                          ));
                                    },
                                    minWidth: 300,
                                    height: 50,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            centerName ?? '',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            clientAddress ?? " ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    )),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            );
                          }))),
            ),
          );
        }
        if (state is DeliveryManFailuer) {
          Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 87, 42, 170),
              title: const Text('MYP'),
            ),
            body: Center(
              child: Text("${state.errorMessage}"),
            ),
          );
        }
        return Container();
      },
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      int? id = await InstanceSharedPrefrences().getId();
      var data = await CrudController<Order>().getAll({
        'orderBy': 'date',
        'done': 0,
        'dir': 'desc',
        'with': 'devices,products,devices_orders,products_orders,client',
        'user_id': id,
        'all_data': 1,
      });
      final List<Order>? orders = data.items;
      if (orders != null) {
        setState(() {
          this.orders.clear();
          this.orders.addAll(groupBy(orders, (order) => order.client?.id));
        });
      }
    } catch (e) {
      Get.snackbar("title", e.toString());
      return;
    }
  }
}

Future<bool> editAtWork(int newStatus) async {
  int? userId = await InstanceSharedPrefrences().getId();
  Map<String, dynamic> body = {'at_work': newStatus};
  try {
    var response = await Api().put(
      path: 'api/users/$userId',
      body: body,
    );
    if (response == null) {
      return false;
    }
    return true;
  } catch (e) {
    return false;
  }
}
