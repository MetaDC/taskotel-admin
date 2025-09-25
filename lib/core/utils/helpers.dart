import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:taskoteladmin/core/services/image_picker.dart';
import 'package:taskoteladmin/core/utils/const.dart';

/// Return color based on hotel type
Color statusColor(String status) {
  return hotelTypeColors[status] ?? Colors.transparent;
}

Future<dynamic> showConfirmDeletDialog(
  BuildContext context,
  Function onBtnTap,
  String title,
  String message,
  String btnText,
  // ProjectModel project,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Return false if cancelled
            },
            child: const Text('Cancel'),
          ),
          // Confirm button
          TextButton(
            onPressed: () {
              onBtnTap();
              Navigator.pop(context);
            },
            child: Text(btnText),
          ),
        ],
      );
    },
  );
}

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

extension MetaWid on DateTime {
  String goodDate() {
    try {
      return DateFormat.yMMMM().format(this);
    } catch (e) {
      return toString().split(" ").first;
    }
  }

  String goodDayDate() {
    try {
      return DateFormat.yMMMd().format(this);
    } catch (e) {
      return toString().split(" ").first;
    }
  }

  String convertToDDMMYY() {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(this);
  }

  String goodTime() {
    try {
      return DateFormat('hh:mm a').format(this);
    } catch (e) {
      return toString().split(" ").first;
    }
  }

  String convertToDDMMYYYYSlashes() {
    try {
      return DateFormat('dd/MM/yyyy').format(this);
    } catch (e) {
      return toString().split(" ").first;
    }
  }

  // NEW: Combines date and time
  String goodDayDateTime() {
    try {
      return DateFormat('MMMM d, yyyy • hh:mm a').format(this);
      // Example: August 12, 2025 • 03:45 PM
    } catch (e) {
      return toString();
    }
  }
}
