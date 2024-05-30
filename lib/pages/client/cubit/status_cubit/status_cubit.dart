import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/Controllers/notification_controller.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/pages/client/step.dart';

// Cubit States
abstract class UpdateStatusState {}

class UpdateStatusInitial extends UpdateStatusState {}

class UpdateStatusReady extends UpdateStatusState {
  final String warrantyEndDate;

  UpdateStatusReady(this.warrantyEndDate);
}

class UpdateStatusNotRepairable extends UpdateStatusState {}

class UpdateStatusError extends UpdateStatusState {
  final String message;

  UpdateStatusError(this.message);
}

// Cubit
class UpdateStatusCubit extends Cubit<UpdateStatusState> {
  final NotificationController notificationController;
  final CrudController<Device> crudController;

  UpdateStatusCubit(this.notificationController, this.crudController)
      : super(UpdateStatusInitial());

  void updateStatus(String state, String? warrantyEndDate) async {
    try {
      if (state == 'جاهز') {
        if (warrantyEndDate == null || warrantyEndDate.isEmpty) {
          emit(UpdateStatusError('تاريخ انتهاء الكفالة مطلوب'));
          return;
        }
        emit(UpdateStatusReady(warrantyEndDate));
      } else if (state == 'لا يصلح') {
        notificationController.showLocalNotificationWithActions(
          'الجهاز لا يصلح للإصلاح',
          'يرجى اختيار طريقة استلام الجهاز',
          jsonEncode([
            {
              "title": "نعم",
              "url": "/api/device/pickup",
              "request_body": {},
              "method": "POST"
            },
            {
              "title": "لا",
              "url": "/api/device/reject",
              "request_body": {},
              "method": "POST"
            }
          ]),
        );
        emit(UpdateStatusNotRepairable());
      } else {
        // Handle other states if necessary
        emit(UpdateStatusInitial());
      }
    } catch (e) {
      emit(UpdateStatusError(e.toString()));
    }
  }
}
