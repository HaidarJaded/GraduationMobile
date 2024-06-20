// ignore_for_file: must_be_immutable, camel_case_types, prefer_typing_uninitialized_variables, avoid_unnecessary_containers, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:graduation_mobile/allDevices/screen/TextFormField.dart';
import 'package:graduation_mobile/drawerScreen/profile/cubit/edit_profile_cubit.dart';
import 'package:graduation_mobile/drawerScreen/profile/profile.dart';

import '../../helper/snack_bar_alert.dart';

class editProfile extends StatelessWidget {
  editProfile(
      {super.key,
      this.labelText,
      required this.icon,
      required this.controller,
      this.validator,
      this.inputFormatters});
  GlobalKey<FormState> myform = GlobalKey<FormState>();
  TextEditingController phone = TextEditingController();
  TextEditingController centerName = TextEditingController();
  TextEditingController addres = TextEditingController();
  final labelText;
  Icon icon;
  final TextEditingController controller;
  final validator;
  List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
        builder: (context, state) {
      if (state is EditProfileLoading) {
        return Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()));
      }
      if (state is EditProfileSucess) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          SnackBarAlert().alert("تمت العملية",
              color: const Color.fromRGBO(0, 200, 0, 1),
              title: "تم تحديث البيانات بنجاح");
          Get.offAll(() => const profile());
        });
      }
      if (state is EditProfileFailure) {
        if (state.errorMessage == "No data to update") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            SnackBarAlert().alert("No data to update",
                color: const Color.fromARGB(255, 200, 0, 0), title: "Error");
            Get.offAll(() => const profile());
          });
        }
      }
      return Container(
          child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              // labelStyle: const TextStyle(fontFamily: "Roboto"),
              prefixIcon: icon,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: validator,
            inputFormatters: inputFormatters,
          ),
          InkWell(
            onTap: () async {
              if (myform.currentState?.validate() ?? false) {
                BlocProvider.of<EditProfileCubit>(context).editClients(
                  phone: phone.text,
                  centerName: centerName.text,
                  address: addres.text,
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(colors: [
                  Color(0xFF3E7FF8),
                  Color(0xFF21468A),
                ]),
              ),
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ));
    });
  }
}
