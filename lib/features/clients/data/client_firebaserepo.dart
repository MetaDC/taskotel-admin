import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/domain/repo/client_repo.dart';

class ClientFirebaseRepo extends ClientRepo {
  final clientsCollectionRef = FBFireStore.clients;

  @override
  Future<void> createAndRegisterClient(
    String name,
    String email,
    String password,
  ) async {
    try {
      final res = await FBFunctions.ff.httpsCallable('createUser').call({
        "name": name,
        "email": email,
        "password": password,
      });
      if (res.data?['success'] == false) {
        throw Exception(res.data?['msg']);
      }
    } catch (e) {
      throw Exception("Registeration failed: $e");
    }
  }
}
