// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

part of 'completed_device_cubit.dart';

@immutable
sealed class CompletedDeviceState {}

final class CompletedDeviceInitial extends CompletedDeviceState {}

final class CompletedDeviceLoading extends CompletedDeviceState {}

final class CompletedDeviceSucces extends CompletedDeviceState {
  final ReturnedObject data;
  CompletedDeviceSucces({required this.data});
}

final class CompletedDeviceFailure extends CompletedDeviceState {
  var errorMessage;
  CompletedDeviceFailure({this.errorMessage});
}
