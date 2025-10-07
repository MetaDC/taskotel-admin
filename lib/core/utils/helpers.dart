import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskoteladmin/core/services/image_picker.dart';
import 'package:taskoteladmin/core/utils/const.dart';

/// Return color based on hotel type
Color statusColor(String status) {
  return hotelTypeColors[status] ?? Colors.transparent;
}

Future<void> showConfirmDeletDialog<T extends Cubit<S>, S>({
  required BuildContext context,
  required VoidCallback onBtnTap,
  required String title,
  required String message,
  required String btnText,
  required bool Function(S) isLoadingSelector, // 👈 selector for loading state
  String Function(S)?
  successMessageSelector, // 👈 optional success message selector
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return BlocConsumer<T, S>(
        listener: (context, state) {
          // Check if operation completed successfully
          if (!isLoadingSelector(state) && successMessageSelector != null) {
            final successMessage = successMessageSelector(state);
            if (successMessage.isNotEmpty) {
              // Close dialog on success
              Navigator.of(dialogContext).pop();

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(successMessage),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          }
        },
        builder: (context, state) {
          final isLoading = isLoadingSelector(state);

          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: isLoading
                    ? null
                    : () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        onBtnTap();
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(btnText, style: const TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
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



// Client Task Helper Function 

