// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/Controllers/returned_object.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/helper/shared_perferences.dart';
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
      print(userDevises);

      if (userDevises != null) {
        emit(PhoneSuccess(data: allDevices));
      }
    } catch (e) {
      emit(PhoneFailure(errorMessage: 'Failed to fetch data'));
    }
  }

  void EditActive({
    required atwork,
  }) async {
    emit(PhoneLoading());
    var user_id = await InstanceSharedPrefrences().getId();
    print(user_id);
    var respons = await Api().put(
        path: 'https://haidarjaded787.serv00.net/api/users',
        body: {'at_work': atwork});
    print(respons);
  }
}
