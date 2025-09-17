import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'masterhotel_form_state.dart';

class MasterhotelFormCubit extends Cubit<MasterhotelFormState> {
  MasterhotelFormCubit() : super(MasterhotelFormInitial());
}
