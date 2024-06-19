part of 'switch_cubit.dart';

abstract class SwitchState {}

class SwitchInitial extends SwitchState {
  final bool switchValue;

  SwitchInitial(this.switchValue);
}

class SwitchChanged extends SwitchState {
  final bool switchValue;

  SwitchChanged(this.switchValue);
}

class SwitchFailure extends SwitchState {
  String errormessage;

  SwitchFailure({required this.errormessage});
}
