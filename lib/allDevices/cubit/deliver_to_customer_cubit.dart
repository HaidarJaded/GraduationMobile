import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'deliver_to_customer_state.dart';

class DeliverToCustomerCubit extends Cubit<DeliverToCustomerState> {
  DeliverToCustomerCubit() : super(DeliverToCustomerInitial());
}
