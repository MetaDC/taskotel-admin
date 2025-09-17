import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'susbcription_state.dart';

class SusbcriptionCubit extends Cubit<SusbcriptionState> {
  SusbcriptionCubit() : super(SusbcriptionInitial());
}
