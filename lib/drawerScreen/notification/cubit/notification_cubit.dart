// ignore_for_file: depend_on_referenced_packages, unnecessary_brace_in_string_interps

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/models/allNotifications.dart';
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

  Future<void> deleteNotification({required String id}) async {
    try {
      await Api().delete(
        path: 'api/notifications/delete/${id}',
      );
    } catch (e) {
      emit(NotificationFailur(errorMessage: e.toString()));
    }
  }

  Future<void> markAsRead({required String id}) async {
    try {
      await Api().post(
        path: 'api/notifications/mark_as_read/${id}',
      );
    } catch (e) {
      emit(NotificationFailur(errorMessage: e.toString()));
    }
  }

  final CrudController<allNotification> _crudController2 =
      CrudController<allNotification>();
  Future<void> getAllNotificationData(
      [Map<String, dynamic>? queryParams]) async {
    try {
      ReturnedObject data = await _crudController2.getAll(queryParams);
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
