part of 'edit_cubit.dart';

@immutable
abstract class EditState {}

final class EditInitial extends EditState {}

final class EditFound extends EditState {
  final Device editDevicesDatat;
  EditFound({required this.editDevicesDatat});
}

final class Editloading extends EditState {}

final class EditSuccess extends EditState {}

final class EditFailur extends EditState {
  final String errMessage;
  EditFailur({required this.errMessage});
}
