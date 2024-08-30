// ignore_for_file: file_names, camel_case_types, unnecessary_import, unnecessary_this

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/product_model.dart';
import 'package:graduation_mobile/models/user_model.dart';
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
  List<dynamic> products = [];
  bool firstTime = true;
  bool readyToBuild = false;
  Future<void> fetchproducts([int page = 1, int perPage = 20]) async {
    try {
      if (currentPage > pagesCount) {
        return;
      }

      var data = await CrudController<Product>()
          .getAll({'page': 1, 'per_page': perPage, 'quantity!': 0});
      final List<Product>? products = data.items;
      if (products != null) {
        int currentPage = data.pagination?['current_page'];
        int lastPage = data.pagination?['last_page'];
        int totalCount = data.pagination?['total'];
        setState(() {
          this.currentPage = currentPage;
          pagesCount = lastPage;
          this.products.addAll(products);
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
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 87, 42, 170),
              title: const Text('MYP'),
            ),
            drawer: const CustomDrawer(),
            body: Container(
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator())));
      } else if (state is ProductSucces) {
        if (firstTime) {
          totalCount = state.data.pagination?['total'];
          currentPage = state.data.pagination?['current_page'];
          pagesCount = state.data.pagination?['last_page'];
          products.addAll(state.data.items!);
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
              itemCount: products.length + 1,
              itemBuilder: (context, index) {
                if (index < products.length) {
                  Product product = products[index];
                  return Card(
                    elevation: 12,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "السعر ${product.price}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            FutureBuilder(
                                future: checkPermissions(),
                                builder: ((context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (snapshot.data == null ||
                                      !snapshot.data!) {
                                    return const SizedBox();
                                  }
                                  return TextButton(
                                      onPressed: () async {
                                        if (product.id == null) {
                                          return;
                                        }
                                        if (await addingOrder(product.id!)) {
                                          SnackBarAlert().alert(
                                              'تمت اضافة طلب بنجاح',
                                              color: const Color.fromRGBO(
                                                  0, 222, 0, 1),
                                              title: 'تم');
                                        }
                                      },
                                      child: const Text('اضافة طلب توصيل'));
                                }))
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (currentPage <= pagesCount && pagesCount > 1) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return null;
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

  Future<bool> checkPermissions() async {
    return await User.hasPermission('اضافة طلب لمنتج') &&
        await User.hasPermission('اضافة طلب');
  }

  Future<bool> addingOrder(int productId) async {
    try {
      int? clientId = await InstanceSharedPrefrences().getId();
      if (clientId == null) {
        return false;
      }
      var response = await Api().post(path: 'api/orders', body: {
        'client_id': clientId,
        'description': 'توصيل طلب للعميل',
        'products_ids': {productId.toString(): ''}
      });
      if (response == null) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
