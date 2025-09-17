import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/master_hotel/domain/entity/masterhotel_model.dart';
import 'package:taskoteladmin/features2/clients/domain/repo/client_repo.dart';
import 'package:taskoteladmin/features/master_hotel/domain/repo/masterhotel_repo.dart';

class MasterHotelFirebaseRepo extends MasterHotelRepo {
  final masterHotelCollectionRef = FBFireStore.masterHotels;

  @override
  Future<void> createMasterHotel(MasterHotelModel masterHotel) async {
    await masterHotelCollectionRef.add(masterHotel.toJson());
  }
}
