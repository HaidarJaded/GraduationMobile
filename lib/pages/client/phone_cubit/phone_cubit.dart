import 'package:bloc/bloc.dart';
part 'phone_state.dart';

class PhoneCubit extends Cubit<PhoneState> {
  PhoneCubit() : super(PhoneInitial());

  void getData() async {}
}
