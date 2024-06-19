import 'package:graduation_mobile/models/user_model.dart';

sealed class UserDetailsState {}

final class UserDetalisInitial extends UserDetailsState {}

final class UserDetalisSuccesses extends UserDetailsState {
  final List<User> details;

  UserDetalisSuccesses({required this.details});
}

final class UserDetalisFailure extends UserDetailsState {
  // ignore: prefer_typing_uninitialized_variables
  var errormess;
  UserDetalisFailure({required this.errormess});
}

final class UserDetalisLoading extends UserDetailsState {}

final class UserDetalisEditing extends UserDetailsState {}
