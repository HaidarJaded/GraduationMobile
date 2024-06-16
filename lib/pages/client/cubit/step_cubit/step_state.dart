// ignore_for_file: implementation_imports

import 'package:flutter/src/material/card.dart';

abstract class RepairStepsState {
  map(Card Function(dynamic step) param0) {}
}

class RepairStepsInitial extends RepairStepsState {}

class RepairStepsLoading extends RepairStepsState {}

class RepairStepsSuccess extends RepairStepsState {
  final List<Map<String, String>> steps;
  RepairStepsSuccess(this.steps);
}

class RepairStepsFailure extends RepairStepsState {
  final String error;
  RepairStepsFailure(this.error);
}
