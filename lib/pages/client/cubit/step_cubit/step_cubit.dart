import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/models/device_model.dart';

class RepairStepsCubit extends Cubit<List<Map<String, String>>> {
  RepairStepsCubit() : super([]);

  void addStep(String description, int currentStep) {
    try {
      List<Map<String, String>> steps = List.from(state);
      steps.add({
        'title': 'الخطوة ${currentStep + 1}',
        'description': description,
      });
      print(steps);
      emit(steps);
    } catch (e) {
      print(e);
    }
  }

  void saveStepsToDevice(Device device) {
    String fixSteps = state.map((step) => step['description']).join('\n');
    device.fixSteps = fixSteps;
  }
}
