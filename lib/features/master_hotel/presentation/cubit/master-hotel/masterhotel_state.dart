part of 'masterhotel_cubit.dart';

class MasterhotelState extends Equatable {
  final bool isLoading;
  final String? message;
  final List<MasterHotelModel> masterHotels;

  const MasterhotelState({
    required this.isLoading,
    this.message,
    required this.masterHotels,
  });

  factory MasterhotelState.initial() {
    return const MasterhotelState(
      isLoading: false,
      message: null,
      masterHotels: [],
    );
  }

  MasterhotelState copyWith({
    bool? isLoading,
    String? message,
    List<MasterHotelModel>? masterHotels,
  }) {
    return MasterhotelState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      masterHotels: masterHotels ?? this.masterHotels,
    );
  }

  @override
  List<Object?> get props => [isLoading, message, masterHotels];
}
