// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables
part of 'notifications_cubit.dart';

sealed class NotificationsState {}

final class NotificationsInitial extends NotificationsState {}

final class NotificationsLoading extends NotificationsState {}

final class NotificationsSucess extends NotificationsState {
  final ReturnedObject data;
  NotificationsSucess({required this.data});
}

final class NotificationsFailur extends NotificationsState {
  var errorMessage;
  NotificationsFailur({required this.errorMessage});
}
