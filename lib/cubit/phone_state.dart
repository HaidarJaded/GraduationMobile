// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

part of 'phone_cubit.dart';

@immutable
sealed class PhoneState {}

final class PhoneInitial extends PhoneState {}

final class PhoneLoading extends PhoneState {}

final class PhoneSuccess extends PhoneState {
  final List<Device> device;
  PhoneSuccess({required this.device});
}

final class PhoneFailure extends PhoneState {
  var errorMessage;
  PhoneFailure({required this.errorMessage});
}
