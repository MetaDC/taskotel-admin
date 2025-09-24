import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/master_hotel/domain/entity/masterhotel_model.dart';
import 'package:taskoteladmin/features/master_hotel/domain/repo/masterhotel_repo.dart';

class MasterHotelFirebaseRepo extends MasterHotelRepo {
  final masterHotelCollectionRef = FBFireStore.masterHotels;

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
}
