import 'package:flutter/cupertino.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/core/services/image_picker.dart';
import 'package:taskoteladmin/features/stroage/domain/storage_repo.dart';

import '../../../core/utils/helpers.dart';

class FirebaseStorageRepo extends StorageRepo {
  Future<String?> uploadMasterHotelIconFile(SelectedImage imageFile) async {
    try {
      final imageRef = FBStorage.masterHotel.child(
        '${DateTime.now().millisecondsSinceEpoch}.${imageFile.extension}',
      );
      final masterHotelLogo = await imageRef.putData(
        imageFile.uInt8List,
        metaDataGenerator(imageFile),
      );
      return await masterHotelLogo.ref.getDownloadURL();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> uploadProjectImg(SelectedImage imageFile) async {
    try {
      final imageRef = FBStorage.project.child(
        '${DateTime.now().millisecondsSinceEpoch}.${imageFile.extension}',
      );
      final task = await imageRef.putData(
        imageFile.uInt8List,
        metaDataGenerator(imageFile),
      );
      return await task.ref.getDownloadURL();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> uploadDocumentsFile(SelectedImage imageFile) async {
    try {
      final imageRef = FBStorage.documents.child(
        '${DateTime.now().millisecondsSinceEpoch}.${imageFile.extension}',
      );
      final task = await imageRef.putData(
        imageFile.uInt8List,
        metaDataGenerator(imageFile),
      );
      return await task.ref.getDownloadURL();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> uploadTaskFile(SelectedImage imageFile) async {
    try {
      final imageRef = FBStorage.tasks.child(
        '${DateTime.now().millisecondsSinceEpoch}.${imageFile.extension}',
      );
      final task = await imageRef.putData(
        imageFile.uInt8List,
        metaDataGenerator(imageFile),
      );
      return await task.ref.getDownloadURL();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> uploadActivityFile(SelectedImage imageFile) async {
    try {
      final imageRef = FBStorage.activity.child(
        '${DateTime.now().millisecondsSinceEpoch}.${imageFile.extension}',
      );
      final task = await imageRef.putData(
        imageFile.uInt8List,
        metaDataGenerator(imageFile),
      );
      return await task.ref.getDownloadURL();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
