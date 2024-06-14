// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

part of 'delivery_man_cubit.dart';

@immutable
sealed class DeliveryManState {}

final class DeliveryManInitial extends DeliveryManState {}

final class DeliveryManLoading extends DeliveryManState {}

final class DeliveryManSucces extends DeliveryManState {
  final ReturnedObject data;
  DeliveryManSucces({required this.data});
}

final class DeliveryManFailuer extends DeliveryManState {
  var errorMessage;
  DeliveryManFailuer({required this.errorMessage});
}
