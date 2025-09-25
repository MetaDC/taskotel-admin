import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/master_hotel/models/masterhotel_model.dart';

class MasterHotelFirebaseRepo {
  final masterHotelCollectionRef = FBFireStore.masterHotels;

  Stream<List<MasterHotelModel>> getMasterHotelsStream() {
    return masterHotelCollectionRef.snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => MasterHotelModel.fromDocSnap(doc))
          .toList();
    });
  }

  Future<void> createMasterHotel(MasterHotelModel masterHotel) async {
    await masterHotelCollectionRef.add(masterHotel.toJson());
  }

  Future<void> updateMasterHotel(MasterHotelModel masterHotel) async {
    await masterHotelCollectionRef
        .doc(masterHotel.docId)
        .update(masterHotel.toJson());
  }

  Future<void> updateStatusOfMasterHotel(String docId, bool isActive) async {
    await masterHotelCollectionRef.doc(docId).update({'isActive': isActive});
  }

  Future<void> deleteMasterHotel(String docId) async {
    await masterHotelCollectionRef.doc(docId).delete();
  }
}
