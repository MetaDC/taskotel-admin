import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:taskoteladmin/core/services/image_picker.dart';

SettableMetadata metaDataGenerator(SelectedImage imageFile) {
  try {
    // Determine file type based on extension
    final extension = imageFile.extension?.toLowerCase() ?? '';
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];

    if (extension == 'pdf') {
      return SettableMetadata(
        contentDisposition: 'inline',
        contentType: 'application/pdf',
      );
    } else if (imageExtensions.contains(extension)) {
      return SettableMetadata(
        contentDisposition: 'inline',
        contentType: 'image/$extension',
      );
    } else {
      return SettableMetadata();
    }
  } on Exception catch (e) {
    debugPrint(e.toString());
    return SettableMetadata();
  }
}
