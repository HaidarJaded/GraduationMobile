// ignore_for_file: unused_field, unused_local_variable, avoid_print

import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/pages/client/Home_Page.dart';

abstract class RepairStepsState {}

class RepairStepsInitial extends RepairStepsState {}

class RepairStepsLoading extends RepairStepsState {}

class RepairStepsSuccess extends RepairStepsState {
  final List<Map<String, String>> steps;
  RepairStepsSuccess(this.steps);
}

class RepairStepsFailure extends RepairStepsState {
  final String error;
  RepairStepsFailure(this.error);
}

class RepairStepsCubit extends Cubit<RepairStepsState> {
  RepairStepsCubit() : super(RepairStepsInitial());

  void addStep(String description, int currentStep) {
    try {
      List<Map<String, String>> steps = [];
      if (state is RepairStepsSuccess) {
        steps = List.from((state as RepairStepsSuccess).steps);
      }
      steps.add({
        'title': 'الخطوة ${currentStep + 1}',
        'description': description,
      });
      emit(RepairStepsSuccess(steps));
    } catch (e) {
      emit(RepairStepsFailure(e.toString()));
    }
  }

  Future<void> saveStepsToDevice(
      {Device? device, int? id, String? fixSteps}) async {
    try {
      if (state is RepairStepsSuccess) {
        fixSteps = (state as RepairStepsSuccess)
            .steps
            .map((step) => step['description'])
            .join('\n');
        device?.fixSteps = fixSteps;
        Map<String, dynamic> body = {'fix_steps': fixSteps};
        var response = await Api().put(
          path: 'https://haidarjaded787.serv00.net/api/devices/$id',
          body: body,
        );
        if (response != null) {
        } else {
          throw Exception('Failed to save steps to device.');
        }
      }
    } catch (e) {
      emit(RepairStepsFailure(e.toString()));
    }
  }

  void saveStepsAndChangeDeviceStatus(Device device, int id, String fixSteps,
      String status, DateTime clientDateWarranty) async {
    try {
      // saveStepsToDevice(device: device, id: id, fixSteps: fixStep);
      fixSteps = (state as RepairStepsSuccess)
          .steps
          .map((step) => step['description'])
          .join('\n');
      Map<String, dynamic> body = {
        'status': 'جاهز',
        'client_date_warranty': clientDateWarranty.toIso8601String(),
        'fix_steps': fixSteps
      };
      var response = await Api().put(
        path: 'https://haidarjaded787.serv00.net/api/devices/$id',
        body: body,
      );
      if (response != null) {
        SnackBarAlert().alert("تم تحديث حالة الجهاز وإعلام العميل",
            color: const Color.fromARGB(255, 4, 83, 173),
            title: "تحديث حالة جهاز");
      }
      emit(RepairStepsInitial());
      Get.off(() => const HomePages());
    } catch (e) {
      emit(RepairStepsFailure(e.toString()));
    }
  }
}
