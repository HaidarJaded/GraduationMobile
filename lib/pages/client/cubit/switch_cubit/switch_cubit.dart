import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/helper/api.dart';
part 'switch_state.dart';

class SwitchCubit extends Cubit<SwitchState> {
  SwitchCubit(
    bool initialState,
  ) : super(SwitchInitial(initialState));

  void toggleSwitch(int id) async {
    final newState = !(state is SwitchInitial
        ? (state as SwitchInitial).switchValue
        : (state as SwitchChanged).switchValue);
    print(newState);
    Map<String, dynamic> body = {'at_work': newState};

    try {
      await Api().put(
        path: 'api/users/$id',
        body: body,
      );
      emit(SwitchChanged(newState));
    } catch (e) {
      print('حدث خطأ أثناء تحديث الحالة: $e');
      // إذا حدث خطأ، نعيد الحالة السابقة
      emit(state);
    }
  }
}
