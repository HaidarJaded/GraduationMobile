// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'detalis_state.dart';

// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'detalis_state.dart';

class DeviceDetailsCubit extends Cubit<DeviceDetailsState> {
  DeviceDetailsCubit() : super(DeviceDetalisInitial());

  // ignore: non_constant_identifier_names
  Future<bool> EditDetalis({
    required int id,
    double? costToClient, // يمكن أن يكون فارغاً إذا كان الجهاز لا يصلح
    required String problem,
    required DateTime expectedDateOfDelivery,
    bool isNotRepairable = false, // إضافة المعامل هنا
  }) async {
    emit(DeviceDetalisLoading());
    try {
      Map<String, dynamic> body = {
        'expected_date_of_delivery': expectedDateOfDelivery.toIso8601String(),
        'problem': problem,
        'status': isNotRepairable ? 'لا يصلح' : 'بانتظار استجابة العميل',
      };
      if (!isNotRepairable) {
        body['cost_to_client'] = costToClient;
      }

      var infoResponse = await Api().put(
        path: 'https://haidarjaded787.serv00.net/api/devices/$id',
        body: body,
      );
      if (infoResponse == null) {
        emit(DeviceDetalisFailure(errormess: 'Error updating'));
        return false;
      }

      emit(DeviceDetalisInitial());
      return true;
    } catch (e) {
      emit(DeviceDetalisFailure(errormess: e.toString()));
      return false;
    }
  }

  void dispose() {
    emit(DeviceDetalisInitial());
  }
}
