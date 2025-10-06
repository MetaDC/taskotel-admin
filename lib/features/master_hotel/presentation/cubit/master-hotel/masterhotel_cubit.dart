import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskoteladmin/features/master_hotel/data/masterhotel_firebaserepo.dart';
import 'package:taskoteladmin/features/master_hotel/domain/entity/masterhotel_model.dart';

part 'masterhotel_state.dart';

class MasterHotelCubit extends Cubit<MasterhotelState> {
  final MasterHotelFirebaseRepo masterHotelRepo;
  MasterHotelCubit({required this.masterHotelRepo})
    : super(MasterhotelState.initial());

  StreamSubscription<List<MasterHotelModel>>? masterHotelsStream;

  void fetchMasterHotels() async {
    emit(state.copyWith(isLoading: true, message: ""));
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

  void updateStatusOfMasterHotel(String docId, bool isActive) {
    masterHotelRepo.updateStatusOfMasterHotel(docId, isActive);
  }

  void deleteMasterHotel(String docId) async {
    emit(state.copyWith(isLoading: true, message: null));
    masterHotelRepo.deleteMasterHotel(docId);
    print("Hotel Deleted--${state.isLoading}");
    await Future.delayed(Duration(milliseconds: 3000));
    emit(state.copyWith(isLoading: false, message: "Hotel Deleted"));
    print("Hotel Loader--${state.isLoading}");
  }

  @override
  Future<void> close() {
    masterHotelsStream?.cancel();
    return super.close();
  }
}
