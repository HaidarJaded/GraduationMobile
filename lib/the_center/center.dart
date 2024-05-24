// ignore_for_file: use_super_parameters, avoid_unnecessary_containers

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/the_center/Goods.dart';
import 'package:graduation_mobile/the_center/Service.dart';
import 'package:graduation_mobile/the_center/allPhoneInCenter.dart';

import '../bar/CustomBottomNavigationBar.dart';
import '../bar/custom_drawer.dart';
import '../bar/SearchAppBar.dart';
import '../main.dart';

import 'cubit/the_center_cubit.dart';

// ignore: camel_case_types
class center extends StatefulWidget {
  const center({Key? key}) : super(key: key);
  static String id = 'center';
  @override
  State<center> createState() => _center();
}

// ignore: camel_case_types
class _center extends State<center> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TheCenterCubit, TheCenterState>(
        builder: (context, state) {
      if (state is TheCenterLoading) {
        return Scaffold(
            appBar: SearchAppBar(),
            drawer: const CustomDrawer(),
            body: const Center(child: CircularProgressIndicator()));
      }
      if (state is TheCenterFailure) {
        return Scaffold(
          appBar: SearchAppBar(),
          drawer: const CustomDrawer(),
          body: Center(
            child: Text(state.errorMessage),
          ),
          bottomNavigationBar: const CustomBottomNavigationBar(),
        );
      }
      if (state is TheCenterSuccess) {
        return Scaffold(
          extendBody: true,
          appBar: SearchAppBar(),
          drawer: const CustomDrawer(),
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: const <Widget>[
              allPhoneInCenter(),
              Service1(),
              Goods(),
            ],
          ),
          bottomNavigationBar: const CustomBottomNavigationBar(),
        );
      }
      return Scaffold(
        appBar: SearchAppBar(),
        drawer: const CustomDrawer(),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: const <Widget>[Center(child: Text("wrong"))],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      );
    });
  }
}
