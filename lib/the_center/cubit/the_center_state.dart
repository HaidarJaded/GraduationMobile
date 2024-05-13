// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

part of 'the_center_cubit.dart';

@immutable
sealed class TheCenterState {}

final class TheCenterInitial extends TheCenterState {}

final class TheCenterLoading extends TheCenterState {}

final class TheCenterSuccess extends TheCenterState {}

final class TheCenterFailure extends TheCenterState {
  var errorMessage;
  TheCenterFailure({required this.errorMessage});
}
