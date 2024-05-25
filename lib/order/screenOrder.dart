// ignore_for_file: avoid_unnecessary_containers, unnecessary_const, unnecessary_import, unnecessary_string_interpolations, body_might_complete_normally_nullable, file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:graduation_mobile/bar/SearchAppBar.dart';
import 'package:graduation_mobile/bar/custom_drawer.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';

import 'package:graduation_mobile/order/cubit/order_cubit.dart';

class order extends StatefulWidget {
  const order({super.key});

  @override
  State<order> createState() => _orderState();
}

class _orderState extends State<order> {
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
                          itemCount: state.data.items!.length,
                          itemBuilder: (context, i) {
                            Card(
                                color: const Color.fromARGB(255, 252, 234, 251),
                                child: Column(
                                  children: [
                                    ExpansionTile(
                                        title: Text(
                                            state.data.items?[i].client.name))
                                  ],
                                ));
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
