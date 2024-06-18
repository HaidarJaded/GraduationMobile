part of 'deliver_to_customer_cubit.dart';

@immutable
sealed class DeliverToCustomerState {}

final class DeliverToCustomerInitial extends DeliverToCustomerState {}

final class DeliverToCustomerSucess extends DeliverToCustomerState {}
