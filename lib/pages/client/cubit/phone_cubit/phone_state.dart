part of 'phone_cubit.dart';

sealed class PhoneState {}

final class PhoneInitial extends PhoneState {}

final class PhoneLoading extends PhoneState {}

final class PhoneSuccess extends PhoneState {
  final ReturnedObject data;
  PhoneSuccess({required this.data});
}

final class PhoneFailure extends PhoneState {
  // ignore: prefer_typing_uninitialized_variables
  var errorMessage;
  PhoneFailure({required this.errorMessage});
}
