// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:meta/meta.dart';
import '../../../Controllers/returned_object.dart';
import '../../../models/notification.dart';
part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());
  final CrudController<Notification1> _crudController =
      CrudController<Notification1>();

  Future<void> getNotificationData([Map<String, dynamic>? queryParams]) async {
    try {
      ReturnedObject data = await _crudController.getAll(queryParams);
      emit(NotificationLoading());

      if (data.items != null) {
        emit(NotificationSucess(data: data));
      } else {
        emit(NotificationFailur(errorMessage: 'Error: Failed to fetch data'));
      }
    } catch (e) {
      emit(NotificationFailur(errorMessage: 'Error: $e'));
    }
  }
}
