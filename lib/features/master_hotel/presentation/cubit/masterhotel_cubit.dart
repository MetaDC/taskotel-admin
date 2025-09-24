import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskoteladmin/features/master_hotel/data/masterhotel_firebaserepo.dart';
import 'package:taskoteladmin/features/master_hotel/models/masterhotel_model.dart';

part 'masterhotel_state.dart';

class MasterhotelCubit extends Cubit<MasterhotelState> {
  final MasterHotelFirebaseRepo masterHotelRepo;
  MasterhotelCubit({required this.masterHotelRepo})
    : super(MasterhotelState.initial());

  StreamSubscription<List<MasterHotelModel>>? masterHotelsStream;

  void fetchMasterHotels() async {
    emit(state.copyWith(isLoading: true));
    masterHotelsStream?.cancel();
    try {
      masterHotelsStream = masterHotelRepo.getMasterHotelsStream().listen((
        hotels,
      ) {
        emit(state.copyWith(masterHotels: hotels, isLoading: false));
      });
    } catch (e) {
      print('Error fetching master hotels: $e');
      emit(state.copyWith(isLoading: false, message: e.toString()));
    }
  }
  

  @override
  Future<void> close() {
    masterHotelsStream?.cancel();
    return super.close();
  }
}
