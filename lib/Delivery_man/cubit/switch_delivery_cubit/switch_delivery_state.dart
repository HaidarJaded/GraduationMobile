part of 'switch_delivery_cubit.dart';

abstract class SwitchDeliveryState {}

class SwitchDeliveryInitial extends SwitchDeliveryState {
  final bool switchValue;

  SwitchDeliveryInitial(this.switchValue);
}

class SwitchDeliveryChanged extends SwitchDeliveryState {
  final bool switchValue;

  SwitchDeliveryChanged(this.switchValue);
}

class SwitchDeliveryFailure extends SwitchDeliveryState {
  String errormessage;

  SwitchDeliveryFailure({required this.errormessage});
}
