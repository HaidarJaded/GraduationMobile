// ignore_for_file: file_names, camel_case_types, unnecessary_import, unnecessary_this

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:graduation_mobile/models/product_model.dart';
import 'package:graduation_mobile/the_center/cubit/product_cubit.dart';

import '../Controllers/crud_controller.dart';
import '../bar/SearchAppBar.dart';
import '../bar/custom_drawer.dart';
import '../helper/shared_perferences.dart';

class productsScreen extends StatefulWidget {
  const productsScreen({super.key});

  @override
  State<productsScreen> createState() => _productsScreensState();
}

Icon check = const Icon(Icons.check);

class _productsScreensState extends State<productsScreen> {
  int perPage = 20;
  int currentPage = 1;
  int pagesCount = 0;
  int totalCount = 0;
  List<dynamic> product = [];
  bool firstTime = true;
  bool readyToBuild = false;
  Future<void> fetchproducts([int page = 1, int perPage = 20]) async {
    try {
      if (currentPage > pagesCount) {
        return;
      }

      var data = await CrudController<Product>().getAll({
        'page': 1,
        'per_page': perPage,
      });
      final List<Product>? products = data.items;
      if (products != null) {
        int currentPage = data.pagination?['current_page'];
        int lastPage = data.pagination?['last_page'];
        int totalCount = data.pagination?['total'];
        setState(() {
          this.currentPage = currentPage;
          pagesCount = lastPage;
          this.product.addAll(product);
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
              BlocProvider.of<ProductCubit>(Get.context!).getProductData(
                  {'page': 1, 'per_page': perPage, 'orderBy': 'name'})
            })
        .then((value) => readyToBuild = true);

    controller.addListener(() async {
      if (controller.position.maxScrollExtent == controller.offset) {
        setState(() {
          if (currentPage <= pagesCount) {
            currentPage++;
          }
        });
        await fetchproducts(currentPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
      if (state is ProductLoading || readyToBuild == false) {
        return Scaffold(
            appBar: SearchAppBar(),
            drawer: const CustomDrawer(),
            body: Container(
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator())));
      } else if (state is ProductSucces) {
        if (firstTime) {
          totalCount = state.data.pagination?['total'];
          currentPage = state.data.pagination?['current_page'];
          pagesCount = state.data.pagination?['last_page'];
          product.addAll(state.data.items!);
          firstTime = false;
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 87, 42, 170),
            title: const Text('MYP'),
          ),
          drawer: const CustomDrawer(),
          body: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 100),
              itemCount: product.length + 1,
              itemBuilder: (context, index) {
                if (index < product.length) {
                  return Card(
                    elevation: 12,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   // ignore: avoid_unnecessary_containers
                          //   child: Container(
                          //     child: Image.asset(
                          //       'images/screen.PNG',
                          //       height: 200,
                          //     ),
                          //   ),
                          // ),
                          Text(
                            product[index].name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            product[index].price.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (currentPage <= pagesCount && pagesCount > 1) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return product.isNotEmpty
                      ? firstTime
                          ? const Center(child: Text('لا يوجد اجهزة'))
                          : product.length >= 20
                              ? const Center(child: Text('لا يوجد المزيد'))
                              : null
                      : const Center(
                          child: CircularProgressIndicator(),
                        );
                }
              }),
        );
      }
      if (state is ProductFailure) {
        Scaffold(
            appBar: SearchAppBar(),
            drawer: const CustomDrawer(),
            body: Center(
              child: Text('${state.errorMessage}'),
            ));
      }
      return Container();
    });
  }
}
