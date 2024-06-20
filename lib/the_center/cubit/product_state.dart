// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

part of 'product_cubit.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductSucces extends ProductState {
  final ReturnedObject data;
  ProductSucces({required this.data});
}

final class ProductFailure extends ProductState {
  var errorMessage;
  ProductFailure({this.errorMessage});
}
