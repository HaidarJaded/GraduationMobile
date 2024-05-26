// ignore_for_file: must_be_immutable

part of 'all_phone_in_center_cubit.dart';

@immutable
sealed class AllPhoneInCenterState {}

final class AllPhoneInCenterInitial extends AllPhoneInCenterState {}

final class AllPhoneInCenterLoading extends AllPhoneInCenterState {}

final class AllPhoneInCenterSuccess extends AllPhoneInCenterState {
  final ReturnedObject data;
  AllPhoneInCenterSuccess({required this.data});
}

final class AllPhoneInCenterFailuer extends AllPhoneInCenterState {
  String errorMessage;
  AllPhoneInCenterFailuer({required this.errorMessage});
}
