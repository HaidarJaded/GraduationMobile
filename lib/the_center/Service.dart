// ignore_for_file: file_names, unnecessary_import, camel_case_types, unnecessary_this

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:graduation_mobile/models/service_model.dart';
import 'package:graduation_mobile/the_center/cubit/service_cubit.dart';

import '../Controllers/crud_controller.dart';
import '../bar/SearchAppBar.dart';
import '../bar/custom_drawer.dart';
import '../helper/shared_perferences.dart';

class ServiceScreeen extends StatefulWidget {
  const ServiceScreeen({super.key});

  @override
  State<ServiceScreeen> createState() => _serviceScreeenState();
}

class _serviceScreeenState extends State<ServiceScreeen> {
  int perPage = 20;
  int currentPage = 1;
  int pagesCount = 0;
  int totalCount = 0;
  List<dynamic> service = [];
  bool firstTime = true;
  bool readyToBuild = false;
  Future<void> fetchService([int page = 1, int perPage = 20]) async {
    try {
      if (currentPage > pagesCount) {
        return;
      }

      var data = await CrudController<Service1>().getAll({
        'page': 1,
        'per_page': perPage,
      });
      final List<Service1>? services = data.items;
      if (services != null) {
        int currentPage = data.pagination?['current_page'];
        int lastPage = data.pagination?['last_page'];
        int totalCount = data.pagination?['total'];
        setState(() {
          this.currentPage = currentPage;
          pagesCount = lastPage;
          this.service.addAll(services);
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
              BlocProvider.of<ServiceCubit>(Get.context!).getServicData(
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
        await fetchService(currentPage);
      }
    });
  }

  List test = [
    {'name': 'ghina', 'price': '5555'},
    {'name': 'ghina', 'price': '5555'},
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceCubit, ServiceState>(
      builder: (context, state) {
        if (state is ServiceLoading || readyToBuild == false) {
          return Scaffold(
              appBar: SearchAppBar(),
              drawer: const CustomDrawer(),
              body: Container(
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator())));
        } else if (state is ServiceSucces) {
          if (firstTime) {
            totalCount = state.data.pagination?['total'];
            currentPage = state.data.pagination?['current_page'];
            pagesCount = state.data.pagination?['last_page'];
            service.addAll(state.data.items!);
            firstTime = false;
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 87, 42, 170),
              title: const Text('MYP'),
            ),
            drawer: const CustomDrawer(),
            body: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: controller,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 100),
              itemCount: service.length + 1,
              itemBuilder: (context, index) {
                if (index < service.length) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15), // Rounded corners for the card
                    ),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service[index].name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Text(
                          //   service[index].timeRequired,
                          //   style: const TextStyle(
                          //     fontSize: 16,
                          //   ),
                          // ),
                          const SizedBox(height: 5),
                          Text(
                            service[index].price,
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
                  return service.isEmpty
                      ? firstTime
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const Center(child: Text('لا يوجد خدمات متاحة'))
                      : service.length >= 20
                          ? const Center(child: Text('لا يوجد المزيد'))
                          : null;
                }
              },
            ),
          );
        }
        // if (state is ServiceFailuer) {
        //   return Text("${state.errorMessage}");
        // }
        return Scaffold(
            appBar: SearchAppBar(),
            drawer: const CustomDrawer(),
            body: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio:
                    3 / 2, // Adjust the aspect ratio to your preference
                crossAxisSpacing:
                    10, // Add spacing between items on the cross axis
                mainAxisSpacing:
                    10, // Add spacing between items on the main axis
                mainAxisExtent: 150, // Adjust the extent to fit your content
              ),
              itemCount: test.length,
              itemBuilder: (context, index) {
                if (index < service.length) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15), // Rounded corners for the card
                    ),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(
                          8), // Adjust padding to fit your content
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            test[index]['name'],
                            style: const TextStyle(
                              fontSize:
                                  20, // Adjust font size to fit your content
                              fontWeight: FontWeight.bold, // Make the text bold
                            ),
                          ),
                          const SizedBox(
                              height: 5), // Space between name and price
                          Text(
                            '${test[index]['price']}', // Ensure price is formatted correctly
                            style: const TextStyle(
                              fontSize:
                                  16, // Adjust font size to fit your content
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
                  return service.isNotEmpty
                      ? firstTime
                          ? const Center(child: Text('لا يوجد اجهزة'))
                          : service.length >= 20
                              ? const Center(child: Text('لا يوجد المزيد'))
                              : null
                      : const Center(
                          child: CircularProgressIndicator(),
                        );
                }
              },
            ));
      },
    );
  }
}
