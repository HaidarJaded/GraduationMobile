// ignore_for_file: unused_field, unused_local_variable, avoid_print

import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/device_model.dart';

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
  RepairStepsCubit(this._crudController) : super(RepairStepsInitial());
  final CrudController<Device> _crudController;

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
      print('$steps add');
    } catch (e) {
      emit(RepairStepsFailure(e.toString()));
      print('Failed to add step: ${e.toString()}');
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
        Map<String, dynamic> body = {'fixSteps': fixSteps};
        var response = await Api().put(
          path: 'https://haidarjaded787.serv00.net/api/devices/$id',
          body: body,
        );
        if (response != null) {
          print('Steps saved successfully: $body');
        } else {
          throw Exception('Failed to save steps to device.');
        }
      }
    } catch (e) {
      emit(RepairStepsFailure(e.toString()));
      print('Failed to save steps to device: ${e.toString()}');
    }
  }

  void notifyClient(Device device, int id, String fixStep, String status,
      DateTime clientDateWarranty) async {
    // هنا يتم إشعار العميل بالتفاصيل
    try {
      saveStepsToDevice(device: device, id: id, fixSteps: fixStep);
      print('save notfic');
      Map<String, dynamic> body = {
        'status': 'جاهز',
        'fixSteps': fixStep,
        'clientDateWarranty': clientDateWarranty
      };
      var response = await Api().put(
        path: 'https://haidarjaded787.serv00.net/api/devices/$id',
        body: body,
      );

      // await _crudController.update(device.id!, {
      //   'status': 'جاهز',
      //   'fixSteps': fixStep,
      //   'clientDateWarranty': clientDateWarranty
      // });
      print('notfication yes');
      // إرسال الإشعار
      SnackBarAlert().alert("تم ارسال اشعار للعميل انتظر الاستجابة رجاءاً",
          color: const Color.fromARGB(255, 4, 83, 173), title: "اشعار العميل");
    } catch (e) {
      emit(RepairStepsFailure(e.toString()));
    }
  }
}
