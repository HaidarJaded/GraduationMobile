import 'package:graduation_mobile/models/device_model.dart';

sealed class DeviceDetailsState {}

final class DeviceDetalisInitial extends DeviceDetailsState {}

final class DeviceDetalisSuccesses extends DeviceDetailsState {
  final List<Device> details;

  DeviceDetalisSuccesses({required this.details});
}

final class DeviceDetalisFailure extends DeviceDetailsState {
  // ignore: prefer_typing_uninitialized_variables
  var errormess;
  DeviceDetalisFailure({required this.errormess});
}

final class DeviceDetalisLoading extends DeviceDetailsState {}

final class DeviceDetalisEditing extends DeviceDetailsState {}
