import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hotel_model.dart';
import 'package:taskoteladmin/features/clients/domain/repo/client_repo.dart';

part 'client_detail_state.dart';

class ClientDetailCubit extends Cubit<ClientDetailState> {
  final ClientRepo clientRepo;
  ClientDetailCubit({required this.clientRepo})
    : super(ClientDetailState.initial());

  void loadClientDetails(String clientId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final client = await clientRepo.getClient(clientId);
      print("Client loaded: ${client.name}");
      // final hotels = await clientRepo.getClientHotels(clientId);
      emit(state.copyWith(client: client, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, message: e.toString()));
    }
  }
}
