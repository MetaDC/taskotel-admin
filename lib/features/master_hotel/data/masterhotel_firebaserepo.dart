import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
import 'package:taskoteladmin/features/master_hotel/domain/entity/masterhotel_model.dart';
import 'package:taskoteladmin/features/master_hotel/domain/repo/mastertask_repo.dart';

class MasterHotelFirebaseRepo extends MasterHotelTaskRepo {
  final masterHotelCollectionRef = FBFireStore.masterHotels;

  // Master Hotel Cubit Functions
  @override
  Stream<List<MasterHotelModel>> getMasterHotelsStream() {
    return masterHotelCollectionRef.snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => MasterHotelModel.fromDocSnap(doc))
          .toList();
    });
  }

  @override
  Future<void> createMasterHotel(MasterHotelModel masterHotel) async {
    await masterHotelCollectionRef.add(masterHotel.toJson());
  }

  @override
  Future<void> updateMasterHotel(MasterHotelModel masterHotel) async {
    await masterHotelCollectionRef
        .doc(masterHotel.docId)
        .update(masterHotel.toJson());
  }

  @override
  Future<void> updateStatusOfMasterHotel(String docId, bool isActive) async {
    await masterHotelCollectionRef.doc(docId).update({'isActive': isActive});
  }

  @override
  Future<void> deleteMasterHotel(String docId) async {
    await masterHotelCollectionRef.doc(docId).delete();
  }

  //Master Task Cubit Functions
  @override
  Stream<List<CommonTaskModel>> getTaskOfHotel(String hotelId) {
    return FBFireStore.masterTasks
        .where('hotelId', isEqualTo: hotelId)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs
              .map((doc) => CommonTaskModel.fromSnap(doc))
              .toList();
        });
  }

  @override
  Future<void> createTaskForHotel(CommonTaskModel task) async {
    await FBFireStore.masterTasks.add(task.toMap());
  }
}
