import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/helper/api.dart';
part 'switch_delivery_state.dart';

class SwitchDeliveryCubit extends Cubit<SwitchDeliveryState> {
  SwitchDeliveryCubit(
    bool initialState,
  ) : super(SwitchDeliveryInitial(initialState));

  void toggleSwitch(int id) async {
    final newState = !(state is SwitchDeliveryInitial
        ? (state as SwitchDeliveryInitial).switchValue
        : (state as SwitchDeliveryChanged).switchValue);
    Map<String, dynamic> body = {'at_work': newState};

    try {
      await Api().put(
        path: 'api/users/$id',
        body: body,
      );
      emit(SwitchDeliveryChanged(newState));
    } catch (e) {
      // إذا حدث خطأ، نعيد الحالة السابقة
      emit(SwitchDeliveryFailure(errormessage: 'Error:${e.toString()}'));
    }
  }
}
