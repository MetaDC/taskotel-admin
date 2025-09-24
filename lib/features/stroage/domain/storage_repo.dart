import 'package:taskoteladmin/core/services/image_picker.dart';

abstract class StorageRepo {
  Future<String?> uploadMasterHotelIconFile(SelectedImage imageFile);
  Future<String?> uploadDocumentsFile(SelectedImage imageFile);
  Future<String?> uploadTaskFile(SelectedImage imageFile);
  Future<String?> uploadActivityFile(SelectedImage imageFile);
}
