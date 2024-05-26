import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/Controllers/returned_object.dart';
import 'package:graduation_mobile/models/device_model.dart';
part 'phone_state.dart';

final CrudController<Device> _crudController = CrudController<Device>();

class PhoneCubit extends Cubit<PhoneState> {
  PhoneCubit() : super(PhoneInitial());

  Future<void> getDevicesByUserId(int userId) async {
    emit(PhoneLoading());
    try {
      final ReturnedObject allDevices =
          await _crudController.getAll({'user_id': userId});
      final List? userDevises = allDevices.items;

      if (userDevises != null) {
        print(userDevises);
        emit(PhoneSuccess(device: userDevises as List<Device>));
      } else {
        emit(PhoneFailure(errorMessage: 'Failed to fetch data'));
      }
    } catch (e) {
      print('Error in getDevicesByUserId: $e');
      emit(PhoneFailure(errorMessage: 'Failed to fetch data'));
    }
  }
}
