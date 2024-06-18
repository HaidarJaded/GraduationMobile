// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

part of 'service_cubit.dart';

@immutable
sealed class ServiceState {}

final class ServiceInitial extends ServiceState {}

final class ServiceLoading extends ServiceState {}

final class ServiceSucces extends ServiceState {
  final ReturnedObject data;
  ServiceSucces({required this.data});
}

final class ServiceFailuer extends ServiceState {
  var errorMessage;
  ServiceFailuer({this.errorMessage});
}
