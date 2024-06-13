// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

part of 'add_devices_cubit.dart';

@immutable
sealed class AddDevicesState {}

final class AddDevicesInitial extends AddDevicesState {}

final class AddDevicesLoading extends AddDevicesState {}

final class AddDevicesSuccess extends AddDevicesState {
  final int? deviceId;
  final bool isRepairedInCenter;
  AddDevicesSuccess({required this.deviceId,required this.isRepairedInCenter});
}

final class AddDevicesNotFound extends AddDevicesState {}

final class AddDevicesFound extends AddDevicesState {
  final List<Customer> result;
  AddDevicesFound({required this.result});
}

final class AddDevicesFailure extends AddDevicesState {
  var errormessage;
  AddDevicesFailure({required errorMessage});
}
