import 'package:graduation_mobile/models/user_model.dart';

sealed class DeliveryDetailsState {}

final class DeliveryDetalisInitial extends DeliveryDetailsState {}

final class DeliveryDetalisSuccesses extends DeliveryDetailsState {
  final List<User> details;

  DeliveryDetalisSuccesses({required this.details});
}

final class DeliveryDetalisFailure extends DeliveryDetailsState {
  // ignore: prefer_typing_uninitialized_variables
  var errormess;
  DeliveryDetalisFailure({required this.errormess});
}

final class DeliveryDetalisLoading extends DeliveryDetailsState {}

final class DeliveryDetalisEditing extends DeliveryDetailsState {}
