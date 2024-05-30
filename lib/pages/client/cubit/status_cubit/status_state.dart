part of 'status_cubit.dart';

sealed class StatusState {}

final class StatusInitial extends StatusState {}

final class StatusLoading extends StatusState {}

final class StatusSuccess extends StatusState {}

final class StatusFailure extends StatusState {
  // ignore: prefer_typing_uninitialized_variables
  var errorMessage;
  StatusFailure({required this.errorMessage});
}
