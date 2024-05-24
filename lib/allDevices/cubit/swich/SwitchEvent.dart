// ignore_for_file: file_names, override_on_non_overriding_member

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Event
abstract class SwitchEvent {
  const SwitchEvent();

  @override
  List<Object> get props => [];
}

class ToggleSwitch extends SwitchEvent {
  final bool value;
  const ToggleSwitch(this.value);

  @override
  List<Object> get props => [value];
}

// State
class SwitchState {
  final bool inCenter;

  const SwitchState(this.inCenter);

  @override
  List<Object> get props => [inCenter];
}

// Bloc
class SwitchBloc extends Bloc<SwitchEvent, SwitchState> {
  SwitchBloc() : super(const SwitchState(false)) {
    // تسجيل معالج الأحداث للحدث ToggleSwitch
    on<ToggleSwitch>((event, emit) {
      emit(SwitchState(event.value));
    });
  }
}
