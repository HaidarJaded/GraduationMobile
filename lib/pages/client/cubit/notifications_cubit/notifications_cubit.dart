// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/Controllers/returned_object.dart';
import 'package:graduation_mobile/models/notification.dart';
part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());
  final CrudController<Notification1> _crudController =
      CrudController<Notification1>();

  Future<void> getNotificationData([Map<String, dynamic>? queryParams]) async {
    try {
      ReturnedObject data = await _crudController.getAll(queryParams);
      emit(NotificationsLoading());

      if (data.items != null) {
        emit(NotificationsSucess(data: data));
      } else {
        emit(NotificationsFailur(errorMessage: 'Error: Failed to fetch data'));
      }
    } catch (e) {
      emit(NotificationsFailur(errorMessage: 'Error: $e'));
    }
  }
}
