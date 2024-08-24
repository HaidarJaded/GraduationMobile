// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/helper/api.dart';
import 'detalis_state.dart';

class DeviceDetailsCubit extends Cubit<DeviceDetailsState> {
  DeviceDetailsCubit() : super(DeviceDetalisInitial());

  // ignore: non_constant_identifier_names
  Future<bool> EditDetalis({
    required int id,
    required double costToClient,
    required String problem,
    required DateTime expectedDateOfDelivery,
  }) async {
    emit(DeviceDetalisLoading());
    try {
      Map<String, dynamic> body = {
        'cost_to_client': costToClient,
        'expected_date_of_delivery': expectedDateOfDelivery.toIso8601String(),
        'problem': problem,
      };
      var infoRedponse = await Api().put(
        path: 'https://haidarjaded787.serv00.net/api/devices/$id',
        body: body,
      );
      if (infoRedponse == null) {
        emit(DeviceDetalisFailure(errormess: 'Error updating'));
        return false;
      }
      var statusResponse = await Api().put(
        path: 'https://haidarjaded787.serv00.net/api/devices/$id',
        body: {
          'status': 'بانتظار استجابة العميل',
        },
      );
      if (statusResponse == null) {
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
