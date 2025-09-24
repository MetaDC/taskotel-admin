// 1. Update ClientRepo to support pagination
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';

abstract class ClientRepo {
  // Fetch clients with pagination
  Future<List<ClientModel>> fetchClients(
    int limit,
    DateTime? startAfter,
    String clientStatus,
  );

  Future<ClientModel> fetchClientById(String clientId);
}
