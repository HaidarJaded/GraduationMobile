// ignore_for_file: must_be_immutable

part of 'order_cubit.dart';

@immutable
sealed class OrderState {}

final class OrderInitial extends OrderState {}

final class OrderSucess extends OrderState {
  final ReturnedObject data;
  OrderSucess({required this.data});
}

final class OrderFailur extends OrderState {
  String errorMessage;
  OrderFailur({required this.errorMessage});
}

final class OrderLoading extends OrderState {}
