import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/Controllers/returned_object.dart';
import 'package:graduation_mobile/models/device_model.dart';
part 'phone_state.dart';

final CrudController<Device> _crudController = CrudController<Device>();

class PhoneCubit extends Cubit<PhoneState> {
  PhoneCubit() : super(PhoneInitial());

  Future<void> getDevicesByUserId([Map<String, dynamic>? queryParams]) async {
    emit(PhoneLoading());
    try {
      final ReturnedObject allDevices =
          await _crudController.getAll(queryParams);
      final List? userDevises = allDevices.items;

      if (userDevises != null) {
        emit(PhoneSuccess(data: allDevices));
      } else {
        emit(PhoneFailure(errorMessage: 'Failed to fetch data'));
      }
    } catch (e) {
      emit(PhoneFailure(errorMessage: 'Failed to fetch data'));
    }
  }
}
