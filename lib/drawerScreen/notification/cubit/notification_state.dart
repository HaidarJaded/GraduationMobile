// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

part of 'notification_cubit.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationLoading extends NotificationState {}

final class NotificationSucess extends NotificationState {
  final ReturnedObject data;
  NotificationSucess({required this.data});
}

final class NotificationFailur extends NotificationState {
  var errorMessage;
  NotificationFailur({required this.errorMessage});
}
