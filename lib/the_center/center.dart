// ignore_for_file: unnecessary_import, use_key_in_widget_constructors, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/the_center/Goods.dart';
import 'package:graduation_mobile/the_center/allPhoneInCenter.dart';
import 'package:graduation_mobile/the_center/cubit/the_center_cubit.dart';

import '../bar/CustomBottomNavigationBar.dart';
import '../bar/SearchAppBar.dart';
import '../bar/custom_drawer.dart';
import '../main.dart';
import 'Service.dart';

class center extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TheCenterCubit, TheCenterState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          appBar: SearchAppBar(),
          drawer: const CustomDrawer(),
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: const <Widget>[allPhoneInCenter(), Goods(), Service1()],
          ),
          bottomNavigationBar: const CustomBottomNavigationBar(),
        );
      },
    );
  }
}
