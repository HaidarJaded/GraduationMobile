part of 'all_devices_cubit.dart';

abstract class AllDevicesState {}

class AllDevicesInitial extends AllDevicesState {}

class AllDevicesLoading extends AllDevicesState {}

class AllDevicesSucces extends AllDevicesState {
  final ReturnedObject data;
  AllDevicesSucces({required this.data});
}

class AllDevicesfailure extends AllDevicesState {
  // ignore: prefer_typing_uninitialized_variables
  var errorMessage;
  AllDevicesfailure({this.errorMessage});
}
