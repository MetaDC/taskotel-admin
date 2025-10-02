import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
import 'package:taskoteladmin/features/master_hotel/domain/entity/masterhotel_model.dart';

abstract class MasterHotelTaskRepo {
  // Master Hotel Cubit Functions
  Stream<List<MasterHotelModel>> getMasterHotelsStream();

  Future<void> createMasterHotel(MasterHotelModel masterHotel);

  Future<void> updateMasterHotel(MasterHotelModel masterHotel);
  Future<void> updateStatusOfMasterHotel(String docId, bool isActive);

  Future<void> deleteMasterHotel(String docId);

  //Master Task Cubit Functions
  Stream<List<CommonTaskModel>> getTaskOfHotel(String hotelId, String role);

  Future<List<CommonTaskModel>> getTaskForExcel(
    String hotelId,
    String taskId,
  );
  Future<void> createTaskForHotel(CommonTaskModel task);
  Future<void> updateTaskForHotel( String docId,CommonTaskModel task);
  Future<void> deleteTask(String taskId);
}
