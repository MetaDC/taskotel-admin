part of 'client_detail_cubit.dart';

class ClientDetailState extends Equatable {
  ClientModel? client;
  List<HotelModel> hotels;
  bool isLoading;
  String? message;

  ClientDetailState({
    required this.client,
    required this.hotels,
    required this.isLoading,
    this.message,
  });

  factory ClientDetailState.initial() {
    return ClientDetailState(
      client: null,
      hotels: [],
      isLoading: false,
      message: null,
    );
  }

  ClientDetailState copyWith({
    ClientModel? client,
    List<HotelModel>? hotels,
    bool? isLoading,
    String? message,
  }) {
    return ClientDetailState(
      client: client ?? this.client,
      hotels: hotels ?? this.hotels,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [];
}
