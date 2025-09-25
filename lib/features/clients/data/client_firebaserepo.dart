import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_hotel_model.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_task_model.dart';
import 'package:taskoteladmin/features/clients/domain/repo/client_repo.dart';

class ClientFirebaseRepo extends ClientRepo {
  final clientsCollectionRef = FBFireStore.clients;

  @override
  Future<void> createAndRegisterClient(
    ClientModel client,
    String password,
  ) async {
    print("Creating user: ${client.name}");
    try {
      final res = await FBFunctions.ff.httpsCallable('createUser').call({
        "name": client.name,
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
      print(res.data);
      if (res.data?['success'] == false) {
        throw Exception(res.data?['msg']);
      }
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  @override
  Future<void> updateClient(ClientModel client) async {
    try {
      print("Updating user -- : ${client.name}");
      await clientsCollectionRef.doc(client.docId).update(client.toJson());
      print("Updating user -- : ${client.name}");
    } catch (e) {
      throw Exception("Failed to update client: $e");
    }
  }

  @override
  Future<void> deleteClient(String clientId) async {
    try {
      await clientsCollectionRef.doc(clientId).delete();
    } catch (e) {
      throw Exception("Failed to delete client: $e");
    }
  }

  @override
  Stream<List<ClientModel>> getActiveClientsStream() {
    return clientsCollectionRef
        .where('status', isEqualTo: ClientStatus.active)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => ClientModel.fromDocSnap(doc)).toList(),
        );
  }

  @override
  Stream<List<ClientModel>> getLostClientsStream() {
    return clientsCollectionRef
        .where(
          'status',
          whereIn: [
            ClientStatus.inactive,
            ClientStatus.suspended,
            ClientStatus.churned,
          ],
        )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => ClientModel.fromDocSnap(doc)).toList(),
        );
  }

  @override
  Future<List<ClientModel>> searchClients(String query) async {
    try {
      final snapshot = await clientsCollectionRef
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return snapshot.docs.map((doc) => ClientModel.fromDocSnap(doc)).toList();
    } catch (e) {
      throw Exception("Failed to search clients: $e");
    }
  }

  @override
  Future<Map<String, dynamic>> getClientAnalytics() async {
    try {
      final activeClients = await clientsCollectionRef
          .where('status', isEqualTo: ClientStatus.active)
          .get();

      final totalClients = await clientsCollectionRef.get();

      final totalRevenue = totalClients.docs.fold<double>(
        0.0,
        (total, doc) => total + (doc.data()['totalRevenue'] ?? 0.0),
      );

      final totalHotels = totalClients.docs.fold<int>(
        0,
        (total, doc) => total + ((doc.data()['totalHotels'] ?? 0) as int),
      );

      return {
        'totalClients': totalClients.docs.length,
        'activeClients': activeClients.docs.length,
        'totalRevenue': totalRevenue,
        'totalHotels': totalHotels,
      };
    } catch (e) {
      throw Exception("Failed to get analytics: $e");
    }
  }

  @override
  Stream<List<ClientHotelModel>> getClientHotelsStream(String clientId) {
    return FBFireStore.hotels
        .where('clientId', isEqualTo: clientId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ClientHotelModel.fromDocSnap(doc))
              .toList(),
        );
  }

  @override
  Future<ClientHotelModel> getClientHotel(String hotelId) async {
    try {
      final doc = await FBFireStore.hotels.doc(hotelId).get();
      if (!doc.exists) {
        throw Exception("Hotel not found");
      }
      return ClientHotelModel.fromSnap(doc);
    } catch (e) {
      throw Exception("Failed to get hotel: $e");
    }
  }

  @override
  Stream<List<ClientTaskModel>> getClientHotelTasksStream(String hotelId) {
    return FBFireStore.tasks
        .where('hotelId', isEqualTo: hotelId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ClientTaskModel.fromDocSnap(doc))
              .toList(),
        );
  }

  @override
  Future<List<ClientTaskModel>> getClientHotelTasks(
    String hotelId,
    String role,
  ) async {
    try {
      final snapshot = await FBFireStore.tasks
          .where('hotelId', isEqualTo: hotelId)
          .where('assignedRole', isEqualTo: role)
          .get();

      return snapshot.docs
          .map((doc) => ClientTaskModel.fromDocSnap(doc))
          .toList();
    } catch (e) {
      throw Exception("Failed to get tasks: $e");
    }
  }
}
