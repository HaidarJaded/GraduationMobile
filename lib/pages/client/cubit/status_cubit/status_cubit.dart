import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_mobile/Controllers/crud_controller.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'package:graduation_mobile/pages/client/cubit/status_cubit/status_state.dart';

// Cubit
class UpdateStatusCubit extends Cubit<UpdateStatusState> {
  final CrudController<Device> crudController;

  UpdateStatusCubit(this.crudController) : super(UpdateStatusInitial());

  void updateStatus(int id, String state, String? warrantyEndDate) async {
    try {
      if (state == 'جاهز') {
        if (warrantyEndDate == null || warrantyEndDate.isEmpty) {
          emit(UpdateStatusError('تاريخ انتهاء الكفالة مطلوب'));
          return;
        }
        emit(UpdateStatusReady(warrantyEndDate));
      } else if (state == 'لا يصلح' || state == 'غير جاهز') {
        Map<String, dynamic> body = {
          'status': state,
          'clientDateWarranty': warrantyEndDate
        };
        print(body);
        var response = await Api().put(
          path: 'https://haidarjaded787.serv00.net/api/devices/$id',
          body: body,
        );

        emit(UpdateStatusNotRepairable());
      } else {
        // Handle other states if necessary
        emit(UpdateStatusInitial());
      }
    } catch (e) {
      emit(UpdateStatusError(e.toString()));
    }
  }
}
