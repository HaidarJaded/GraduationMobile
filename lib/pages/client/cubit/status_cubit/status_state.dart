// Cubit States
abstract class UpdateStatusState {}

class UpdateStatusInitial extends UpdateStatusState {}

class UpdateStatusReady extends UpdateStatusState {
  final String warrantyEndDate;

  UpdateStatusReady(this.warrantyEndDate);
}

class UpdateStatusNotRepairable extends UpdateStatusState {}

class UpdateStatusError extends UpdateStatusState {
  final String message;

  UpdateStatusError(this.message);
}
