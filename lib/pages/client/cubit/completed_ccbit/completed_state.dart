// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

part of 'completed_cubit.dart';

sealed class CompletedState {}

final class CompletedInitial extends CompletedState {}

final class CompletedLoading extends CompletedState {}

final class CompletedSucces extends CompletedState {
  final ReturnedObject data;
  CompletedSucces({required this.data});
}

final class CompletedFailure extends CompletedState {
  var errorMessage;
  CompletedFailure({this.errorMessage});
}
