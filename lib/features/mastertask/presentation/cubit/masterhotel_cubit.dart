import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'masterhotel_state.dart';

class MasterhotelCubit extends Cubit<MasterhotelState> {
  MasterhotelCubit() : super(MasterhotelInitial());
}
