import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/Controllers/returned_object.dart';
import '../../Controllers/crud_controller.dart';
import '../../models/device_model.dart';
import '../../models/has_id.dart';
part 'all_devices_state.dart';

class AllDevicesCubit<T extends HasId> extends Cubit<AllDevicesState> {
  final CrudController<Device> _crudController = CrudController<Device>();

  AllDevicesCubit() : super(AllDevicesInitial());

  Future<void> getDeviceData([Map<String, dynamic>? queryParams]) async {
    try {
      emit(AllDevicesLoading());
      ReturnedObject data = await _crudController.getAll(queryParams);

      if (data.items != null) {
        emit(AllDevicesSucces(data: data));
      } else {
        emit(AllDevicesfailure(errorMessage: 'Error: Failed to fetch data'));
      }
    } catch (e) {
      emit(AllDevicesfailure(errorMessage: 'Error: $e'));
    }
  }
}
