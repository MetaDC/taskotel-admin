import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/features/clients/domain/entity/%20analytics_models.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hotel_model.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';

abstract class ClientRepo {
  //Cients Page
  // --Client CRUD operations
  Future<void> createAndRegisterClient(ClientModel client, String password);
  Future<void> updateClient(ClientModel client);
  Future<void> deleteClient(String clientId);
  Future<List<ClientModel>> searchClients(String query);

  //Client Details Page
  Future<ClientModel> getClientDetials(String clientId);
  Future<List<HotelModel>> getClientHotels(String clientId);
  Future<List<CommonTaskModel>> getHotelTasks(String hotelId);

  //client analytics
  // Future<ClientListAnalytics> getClientsAnalytics();
}
