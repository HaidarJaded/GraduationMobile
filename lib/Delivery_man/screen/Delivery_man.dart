// ignore_for_file: camel_case_types, body_might_complete_normally_nullable, unnecessary_import, avoid_unnecessary_containers, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:graduation_mobile/Delivery_man/cubit/delivery_man_cubit.dart';
import 'package:graduation_mobile/Delivery_man/screen/orders.dart';
import 'package:graduation_mobile/bar/custom_drawer.dart';
import 'package:graduation_mobile/models/order_model.dart';
import '../../Controllers/crud_controller.dart';
import '../../helper/shared_perferences.dart';

class Delivery_man extends StatefulWidget {
  const Delivery_man({super.key});

  @override
  State<Delivery_man> createState() => _Delivery_manState();
}

class _Delivery_manState extends State<Delivery_man> {
  int perPage = 20;
  int currentPage = 1;
  int pagesCount = 0;
  int totalCount = 0;
  List<dynamic> order = [];
  bool firstTime = true;
  bool readyToBuild = false;
  Future<void> fetchOrder([int page = 1, int perPage = 20]) async {
    try {
      if (currentPage > pagesCount) {
        return;
      }
      int? id = await InstanceSharedPrefrences().getId();
      var data = await CrudController<Order>().getAll({
        'page': currentPage,
        'per_page': perPage,
        'orderBy': 'date_receipt',
        'dir': 'desc',
        'user_id': id
      });
      final List<Order>? order = data.items;
      if (order != null) {
        int currentPage = data.pagination?['current_page'];
        int lastPage = data.pagination?['last_page'];
        int totalCount = data.pagination?['total'];
        setState(() {
          this.currentPage = currentPage;
          pagesCount = lastPage;
          this.order.addAll(order);
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

  final controller = ScrollController();
  @override
  void initState() {
    super.initState();
    readyToBuild = false;
    InstanceSharedPrefrences()
        .getId()
        .then((id) => {
              BlocProvider.of<DeliveryManCubit>(Get.context!).getorderData({
                'page': 1,
                'per_page': perPage,
                'orderBy': 'date_receipt',
                'dir': 'desc',
                'user_id': id
              })
            })
        .then((value) => readyToBuild = true);

    controller.addListener(() async {
      if (controller.position.maxScrollExtent == controller.offset) {
        setState(() {
          if (currentPage <= pagesCount) {
            currentPage++;
          }
        });
        await fetchOrder(currentPage);
      }
    });
  }

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
              body: const Center(child: CircularProgressIndicator()));
        }
        if (state is DeliveryManSucces) {
          if (firstTime) {
            totalCount = state.data.pagination?['total'];
            currentPage = state.data.pagination?['current_page'];
            pagesCount = state.data.pagination?['last_page'];
            order.addAll(state.data.items!);
            firstTime = false;
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 87, 42, 170),
              title: const Text('MYP'),
            ),
            drawer: CustomDrawer(),
            body: Container(
              child: Container(
                padding: const EdgeInsets.all(5),
                child: ListView.builder(
                    controller: controller,
                    itemCount: order.length + 1,
                    itemBuilder: (context, i) {
                      if (i < order.length) {
                        return Column(
                          children: [
                            MaterialButton(
                                onPressed: () {
                                  Get.off(orders());
                                },
                                minWidth: 300,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${order[i].client?.centerName ?? ""}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "${order[i].client?.phone ?? ""}",
                                        style: const TextStyle(
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
                      }
                    }),
              ),
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
}
