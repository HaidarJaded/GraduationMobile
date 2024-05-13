// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'the_center_state.dart';

class TheCenterCubit extends Cubit<TheCenterState> {
  TheCenterCubit() : super(TheCenterInitial());
}
