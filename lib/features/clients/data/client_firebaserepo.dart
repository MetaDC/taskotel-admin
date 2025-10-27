import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hotel_model.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
import 'package:taskoteladmin/features/clients/domain/repo/client_repo.dart';

class ClientFirebaseRepo extends ClientRepo {
  final clientsCollectionRef = FBFireStore.clients;

  // CRUD
  @override
  Future<String> createAndRegisterClient(
    ClientModel client,
    String password,
  ) async {
    try {
      final res = await FBFunctions.ff.httpsCallable('createClient').call({
        "name": client.name.toLowerCase(),
        "email": client.email,
        "password": password,
        "phone": client.phone,
        "status": client.status,
        "totalHotels": client.totalHotels,
        "totalRevenue": client.totalRevenue,
        "lastPaymentExpiry": client.lastPaymentExpiry?.millisecondsSinceEpoch,
        "lastLogin": client.lastLogin?.millisecondsSinceEpoch,
        "createdAt": client.createdAt.millisecondsSinceEpoch,
        "updatedAt": client.updatedAt.millisecondsSinceEpoch,
      });

      if (res.data?['success'] == false) {
        throw Exception(res.data?['msg']);
      } else {
        return res.data['docId'];
      }
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  @override
  Future<void> updateClient(ClientModel client) async {
    try {
      await clientsCollectionRef.doc(client.docId).update(client.toJson());
    } catch (e) {
      throw Exception("Failed to update client: $e");
    }
  }

  @override
  Future<void> deleteClient(String clientId) async {
    try {
      final res = await FBFunctions.ff.httpsCallable('deleteUser').call({
        "userId": clientId,
      });

      if (res.data?['success'] == false) {
        throw Exception(res.data?['msg']);
      }
    } catch (e) {
      throw Exception("Failed to delete client: $e");
    }
  }

  @override
  Future<List<ClientModel>> searchClients(String query) async {
    try {
      // Search by name
      final nameSnapshot = await clientsCollectionRef
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf7ff')
          .get();

      // Search by email
      final emailSnapshot = await clientsCollectionRef
          .where('email', isGreaterThanOrEqualTo: query)
          .where('email', isLessThanOrEqualTo: '$query\uf7ff')
          .get();

      // Combine results and remove duplicates
      final allDocs = <String, QueryDocumentSnapshot>{};

      // Add name search results
      for (var doc in nameSnapshot.docs) {
        allDocs[doc.id] = doc;
      }

      // Add email search results
      for (var doc in emailSnapshot.docs) {
        allDocs[doc.id] = doc;
      }

      return allDocs.values
          .map(
            (doc) => ClientModel.fromDocSnap(
              doc as QueryDocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception("Failed to search clients: $e");
    }
  }

  // Client Details Cubit Functions
  @override
  Future<ClientModel> getClientDetials(String clientId) async {
    try {
      final doc = await clientsCollectionRef.doc(clientId).get();
      if (!doc.exists) {
        throw Exception("Client not found");
      }
      return ClientModel.fromSnap(doc);
    } catch (e) {
      throw Exception("Failed to get client: $e");
    }
  }

  @override
  Future<List<HotelModel>> getClientHotels(String clientId) async {
    try {
      final snapshot = await FBFireStore.hotels
          .where('clientId', isEqualTo: clientId)
          .get();

      return snapshot.docs.map((doc) => HotelModel.fromDocSnap(doc)).toList();
    } catch (e) {
      throw Exception("Failed to get client hotels: $e");
    }
  }

  @override
  Future<List<CommonTaskModel>> getHotelTasks(String hotelId) async {
    try {
      final snapshot = await FBFireStore.tasks
          .where('hotelId', isEqualTo: hotelId)
          .get();

      return snapshot.docs.map((doc) => CommonTaskModel.fromSnap(doc)).toList();
    } catch (e) {
      throw Exception("Failed to get hotel tasks: $e");
    }
  }

  //Client Analytics
  // @override
  // Future<ClientListAnalytics> getClientsAnalytics() async {
  //   final activeClients = FBFireStore.clients
  //       .where('status', whereIn: ['active', 'trial'])
  //       .count();

  //   final lostClients = FBFireStore.clients
  //       .where('status', whereIn: ['churned', 'inactive', 'suspended'])
  //       .count();

  //   final totalHotels = FBFireStore.hotels.count();

  //   final snapshot = await Future.wait([
  //     activeClients.get(),
  //     lostClients.get(),
  //     totalHotels.get(),
  //   ]);
  // }
}
