// ignore_for_file: avoid_print
import 'package:bloc/bloc.dart';
import 'package:graduation_mobile/Delivery_man/cubit/profile_delivery_cubit/profile_delivery_state.dart';
import 'package:graduation_mobile/helper/api.dart';

class DeliveryDetailsCubit extends Cubit<DeliveryDetailsState> {
  DeliveryDetailsCubit() : super(DeliveryDetalisInitial());

  // ignore: non_constant_identifier_names
  Future<void> EditData({
    required int id,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      Map<String, dynamic> body = {
        'email': email,
        'password': password,
        'phone': phone
      };
      var infoRedponse = await Api().put(
        path: 'https://haidarjaded787.serv00.net/api/users/$id',
        body: body,
      );
      if (infoRedponse == null) return;
    } catch (e) {
      print(e);
    }
  }
}
