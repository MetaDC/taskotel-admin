import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';

abstract class ClientRepo {
  // create client function
  Future<void> createAndRegisterClient(
    String name,
    String email,
    String password,
  );
}
