import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class SelectedImage {
  final String name;
  final String? extension;
  final Uint8List uInt8List;

  SelectedImage({
    required this.name,
    required this.uInt8List,
    required this.extension,
  });

  Object? get length => null;
}

class ImagePickerService {
  Future<SelectedImage?> pickFile(
    BuildContext context, {
    required bool useCompressor,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true, // Required to get the bytes
        type: FileType.any, // Allow all file types
      );

      if (result != null && result.files.isNotEmpty) {
        final pickedFile = result.files.first;
        final fileBytes = pickedFile.bytes;
        final extension = pickedFile.extension?.toLowerCase();

        if (fileBytes == null || extension == null) return null;

        // Only compress if it's an image and compression is requested
        final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
        final shouldCompress =
            useCompressor && imageExtensions.contains(extension);

        final finalBytes =
            shouldCompress ? await imageCompressor(fileBytes) : fileBytes;

        final res = SelectedImage(
          name: pickedFile.name,
          uInt8List: finalBytes,
          extension: extension,
        );
        return res;
      }
      return null;
    } catch (e) {
      debugPrint('Error picking file: $e');
      return null;
    }
  }

  Future<SelectedImage?> pickImageNewCamera(
    BuildContext context, {
    required bool useCompressor,
  }) async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      final croppedImage = image;
      if (croppedImage != null) {
        final nameSplits = image!.name.split(".");
        final finalBytes =
            useCompressor
                ? await imageCompressor(await croppedImage.readAsBytes())
                : await croppedImage.readAsBytes();
        return SelectedImage(
          name: nameSplits.first,
          extension: nameSplits.length > 1 ? nameSplits.last : "",
          uInt8List: finalBytes,
        );
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      // showAppSnack(e.toString());
      Clipboard.setData(ClipboardData(text: e.toString()));
      return null;
    }
  }

  Future<List<SelectedImage>> pickImageAndCompress({
    required bool useCompressor,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result != null) {
        final imgs = <SelectedImage>[];
        for (var e in result.files) {
          final finalBytes =
              useCompressor ? await imageCompressor(e.bytes!) : e.bytes!;
          imgs.add(
            SelectedImage(
              name: e.name,
              extension: e.extension!,
              uInt8List: finalBytes,
            ),
          );
        }
        return imgs;
      }
      return [];
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<SelectedImage>> pickImageAndCrop(
    BuildContext context, {
    required bool useCompressor,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result != null) {
        final imgs = <SelectedImage>[];
        for (var e in result.files) {
          final finalBytes =
              useCompressor ? await imageCompressor(e.bytes!) : e.bytes!;
          imgs.add(
            SelectedImage(
              name: e.name,
              extension: e.extension!,
              uInt8List: finalBytes,
            ),
          );
        }
        return imgs;
      }
      return [];
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<SelectedImage?> pickImageNew(
    BuildContext context, {
    required bool useCompressor,
  }) async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        final nameSplits = image.name.split(".");

        final finalBytes =
            useCompressor
                ? await imageCompressor(await image.readAsBytes())
                : await image.readAsBytes();
        return SelectedImage(
          name: nameSplits.first,
          extension: nameSplits.length > 1 ? nameSplits.last : "",
          uInt8List: finalBytes,
        );
      }

      return null;
    } catch (e) {
      debugPrint(e.toString());
      // showAppSnack(e.toString());
      Clipboard.setData(ClipboardData(text: e.toString()));
      return null;
    }
  }
}

Future<Uint8List> imageCompressor(Uint8List list) async {
  var result = await FlutterImageCompress.compressWithList(
    list,
    minHeight: 1920,
    minWidth: 1080,
    quality: 70,
  );
  return result;
}
