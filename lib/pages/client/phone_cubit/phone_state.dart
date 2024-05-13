part of 'phone_cubit.dart';

sealed class PhoneState {}

final class PhoneInitial extends PhoneState {}

final class PhoneLoading extends PhoneState {}

final class PhoneSuccess extends PhoneState {}

final class PhoneFailure extends PhoneState {}
