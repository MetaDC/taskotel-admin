import 'package:taskoteladmin/features2/super_admin/data/models/client_model.dart';

abstract class ClientRepo {
  // create, update, delete clients
  Future<ClientModel> createClient(ClientModel client);
  Future<ClientModel> updateClient(ClientModel client);
  Future<void> deleteClient(String clientId);

  // fetch clients
  Future<List<ClientModel>> fetchClients({
    String? searchQuery,
    int? limit,
    String? lastDocumentId,
  });
  Future<ClientModel> fetchClientById(String clientId);
}
