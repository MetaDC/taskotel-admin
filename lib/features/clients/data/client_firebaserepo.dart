// 2. Update ClientFirebaseRepo implementation
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/domain/repo/client_repo.dart';

class ClientFirebaseRepo extends ClientRepo {
  final clientCollectionRef = FBFireStore.clients;

  @override
  Future<ClientModel> fetchClientById(String clientId) async {
    try {
      final doc = await clientCollectionRef.doc(clientId).get();
      if (doc.exists) {
        return ClientModel.fromSnap(doc);
      }
      throw Exception('Client not found');
    } catch (e) {
      print('Error fetching client by ID: $e');
      rethrow;
    }
  }

  @override
  Future<List<ClientModel>> fetchClients(
    int limit,
    DateTime? startAfter,
    String clientStatus,
  ) {
    // TODO: implement fetchClients
    throw UnimplementedError();
  }
}
