// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

part of 'edit_profile_cubit.dart';

sealed class EditProfileState {}

final class EditProfileInitial extends EditProfileState {}

final class EditProfileLoading extends EditProfileState {}

final class EditProfileSucess extends EditProfileState {}

final class EditProfileFailure extends EditProfileState {
  var errorMessage;
  EditProfileFailure({this.errorMessage});
}
