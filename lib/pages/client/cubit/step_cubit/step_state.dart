import 'package:graduation_mobile/pages/client/cubit/step_cubit/step_cubit.dart';

sealed class Stepstate {
  map(Function(dynamic step) param0) {}
}

final class StepInitialState extends Stepstate {}

final class StepLoadingState extends Stepstate {}

final class StepSuccessState extends Stepstate {}

final class StepFailureState extends Stepstate {
  // ignore: prefer_typing_uninitialized_variables
  var errormessage;
  StepFailureState({required this.errormessage});
}
