import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_hotel_model.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_task_model.dart';

abstract class ClientRepo {
  // Client CRUD operations
  Future<void> createAndRegisterClient(ClientModel client, String password);
  Future<void> updateClient(ClientModel client);
  Future<void> deleteClient(String clientId);
  Stream<List<ClientModel>> getActiveClientsStream();
  Stream<List<ClientModel>> getLostClientsStream();
  Future<List<ClientModel>> searchClients(String query);
  Future<Map<String, dynamic>> getClientAnalytics();

  // Client Hotels operations
  Stream<List<ClientHotelModel>> getClientHotelsStream(String clientId);
  Future<ClientHotelModel> getClientHotel(String hotelId);

  // Client Tasks operations
  Stream<List<ClientTaskModel>> getClientHotelTasksStream(String hotelId);
  Future<List<ClientTaskModel>> getClientHotelTasks(
    String hotelId,
    String role,
  );
}
