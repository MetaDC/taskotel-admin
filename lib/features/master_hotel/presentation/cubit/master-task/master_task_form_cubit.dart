import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
import 'package:taskoteladmin/features/master_hotel/data/masterhotel_firebaserepo.dart';
import 'package:excel/excel.dart';

part 'master_task_form_state.dart';

class MasterTaskFormCubit extends Cubit<MasterTaskFormState> {
  final MasterHotelFirebaseRepo masterHotelRepo;

  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers as cubit variables
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController dayOrDateController = TextEditingController();
  final TextEditingController questionController = TextEditingController();

  MasterTaskFormCubit({required this.masterHotelRepo})
    : super(MasterTaskFormState.initial());

  @override
  Future<void> close() {
    titleController.dispose();
    descController.dispose();
    durationController.dispose();
    placeController.dispose();
    dayOrDateController.dispose();
    questionController.dispose();
    return super.close();
  }

  // Initialize form for editing
  void initializeForm(CommonTaskModel? taskToEdit) {
    if (taskToEdit != null) {
      titleController.text = taskToEdit.title;
      descController.text = taskToEdit.desc;
      durationController.text = taskToEdit.duration;
      placeController.text = taskToEdit.place;
      dayOrDateController.text = taskToEdit.dayOrDate;

      emit(
        state.copyWith(
          selectedCategory: taskToEdit.assignedRole,
          selectedFrequency: taskToEdit.frequency,
          selectedDepartment: taskToEdit.assignedDepartmentId,
          selectedServiceType: taskToEdit.serviceType,
          questions: taskToEdit.questions,
          isActive: taskToEdit.isActive,
          isEditMode: true,
        ),
      );
    } else {
      clearForm();
    }
  }

  // Clear form
  void clearForm() {
    titleController.clear();
    descController.clear();
    durationController.clear();
    placeController.clear();
    dayOrDateController.clear();
    questionController.clear();

    emit(MasterTaskFormState.initial());
  }

  // Select user category
  void selectUserCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }

  // Select frequency
  void selectFrequency(String frequency) {
    emit(state.copyWith(selectedFrequency: frequency));
  }

  // Select department
  void selectDepartment(String? department) {
    emit(state.copyWith(selectedDepartment: department));
  }

  // Select service type
  void selectServiceType(String? serviceType) {
    emit(state.copyWith(selectedServiceType: serviceType));
  }

  // Update active status
  void updateActiveStatus(bool isActive) {
    emit(state.copyWith(isActive: isActive));
  }

  // File operations
  void selectFile(PlatformFile file) {
    emit(state.copyWith(selectedFile: file));
  }

  void clearFile() {
    emit(state.copyWith(selectedFile: null));
  }

  // Question operations
  void addQuestion() {
    final questionText = questionController.text.trim();
    if (questionText.isEmpty) {
      emit(state.copyWith(validationMessage: 'Please enter a question'));
      return;
    }

    final question = {
      'question': questionText,
      'type': 'text', // or whatever type you need
      'required': true,
    };

    final updatedQuestions = List<Map<String, dynamic>>.from(state.questions)
      ..add(question);

    questionController.clear();
    emit(state.copyWith(questions: updatedQuestions, validationMessage: null));
  }

  void removeQuestion(int index) {
    final updatedQuestions = List<Map<String, dynamic>>.from(state.questions)
      ..removeAt(index);
    emit(state.copyWith(questions: updatedQuestions));
  }

  // Download template
  Future<void> downloadTemplate() async {
    emit(state.copyWith(isDownloadingTemplate: true));

    try {
      // Implement actual template download logic here
      // For example, create Excel file and download
      await Future.delayed(Duration(seconds: 1));

      emit(state.copyWith(isDownloadingTemplate: false, errorMessage: null));
    } catch (e) {
      emit(
        state.copyWith(
          isDownloadingTemplate: false,
          errorMessage: 'Failed to download template: ${e.toString()}',
        ),
      );
    }
  }

  // Validate form
  bool validateForm() {
    if (!formKey.currentState!.validate()) {
      emit(
        state.copyWith(validationMessage: 'Please fill all required fields'),
      );
      return false;
    }

    if (state.selectedCategory == null) {
      emit(state.copyWith(validationMessage: 'Please select a user category'));
      return false;
    }

    if (state.selectedFrequency == null) {
      emit(state.copyWith(validationMessage: 'Please select a frequency'));
      return false;
    }

    emit(state.copyWith(validationMessage: null));
    return true;
  }

  // Submit form (manual creation)
  Future<void> submitForm(
    BuildContext context,
    String masterHotelId,
    CommonTaskModel? taskToEdit,
  ) async {
    if (!validateForm()) return;

    emit(state.copyWith(isCreating: true, errorMessage: null));

    try {
      final task = CommonTaskModel(
        docId: taskToEdit?.docId ?? '',
        taskId: taskToEdit?.taskId ?? '',
        title: titleController.text.trim(),
        desc: descController.text.trim(),
        createdAt: taskToEdit?.createdAt ?? DateTime.now(),
        createdByDocId:
            taskToEdit?.createdByDocId ?? FBAuth.auth.currentUser!.uid,
        createdByName: taskToEdit?.createdByName ?? 'Super Admin',
        updatedAt: DateTime.now(),
        updatedBy: FBAuth.auth.currentUser!.uid,
        updatedByName: 'Super Admin',
        hotelId: masterHotelId,
        assignedRole: state.selectedCategory!,
        assignedDepartmentId: state.selectedDepartment,
        serviceType: state.selectedServiceType,
        frequency: state.selectedFrequency!,
        dayOrDate: dayOrDateController.text.trim(),
        duration: durationController.text.trim(),
        place: placeController.text.trim(),
        questions: state.questions,
        fromMasterHotel: null,
        isActive: state.isActive,
      );

      if (state.isEditMode && taskToEdit != null) {
        await masterHotelRepo.updateTaskForHotel(taskToEdit.docId, task);
      } else {
        await masterHotelRepo.createTaskForHotel(task);
      }

      emit(state.copyWith(isCreating: false, isSuccess: true));

      // Navigate back or show success message
      if (context.mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      emit(
        state.copyWith(
          isCreating: false,
          errorMessage:
              'Failed to ${state.isEditMode ? "update" : "create"} task: ${e.toString()}',
        ),
      );
    }
  }

  // Create master tasks from Excel
  Future<void> createMasterTasksFromExcel(
    BuildContext context,
    String masterHotelId,
  ) async {
    if (state.selectedCategory == null) {
      emit(state.copyWith(errorMessage: 'Please select a user category first'));
      return;
    }

    if (state.selectedFile == null) {
      emit(state.copyWith(errorMessage: 'Please select an Excel file'));
      return;
    }

    emit(state.copyWith(isCreating: true, errorMessage: null));

    try {
      List<CommonTaskModel> importTaskList = [];
      final bytes = state.selectedFile!.bytes;

      if (bytes == null) {
        throw Exception('Failed to read file bytes');
      }

      final excelFile = excel.Excel.decodeBytes(bytes);

      for (var sheet in excelFile.tables.keys) {
        final table = excelFile.tables[sheet]!;

        // Skip header row, start from row 1
        for (var rowIndex = 1; rowIndex < table.maxRows; rowIndex++) {
          final row = table.rows[rowIndex];

          // Skip empty rows
          if (row.isEmpty || row[0]?.value == null) continue;

          final toAddTask = CommonTaskModel(
            docId: '',
            taskId: row[0]!.value.toString(),
            title: row[1]!.value.toString(),
            desc: row[2]!.value.toString(),
            createdAt: DateTime.now(),
            createdByDocId: FBAuth.auth.currentUser!.uid,
            createdByName: 'Super Admin',
            updatedAt: DateTime.now(),
            updatedBy: FBAuth.auth.currentUser!.uid,
            updatedByName: 'Super Admin',
            hotelId: masterHotelId,
            assignedRole: state.selectedCategory!,
            frequency: row[6]!.value.toString(),
            dayOrDate: row[7]!.value.toString(),
            duration: row[3]!.value.toString(),
            place: row[4]!.value.toString(),
            questions: [],
            fromMasterHotel: null,
            isActive: true,
          );

          importTaskList.add(toAddTask);
        }
      }
      if (importTaskList.isEmpty) {
        throw Exception('No valid tasks found in the Excel file');
      }

      // Create tasks in Firestore
      for (var task in importTaskList) {
        List<CommonTaskModel> res = await masterHotelRepo.getTaskForExcel(
          masterHotelId,
          task.taskId,
        );
        print(res);
        if (res.isNotEmpty) {
          await masterHotelRepo.updateTaskForHotel(res.first.docId, task);
        } else {
          await masterHotelRepo.createTaskForHotel(task);
        }

        // await masterHotelRepo.createTaskForHotel(task);
      }

      emit(state.copyWith(isCreating: false, isSuccess: true));

      // Navigate back or show success message
      if (context.mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      emit(
        state.copyWith(
          isCreating: false,
          errorMessage: 'Failed to import tasks: ${e.toString()}',
        ),
      );
    }
  }

  // Future<void> exportTasksToExcel(List<CommonTaskModel> tasks) async {
  //   try {
  //     // Request storage permission if needed
  //     if (Platform.isAndroid) {
  //       var status = await Permission.storage.request();
  //       if (!status.isGranted) {
  //         throw Exception("Storage permission not granted");
  //       }
  //     }

  //     final excel = Excel.createExcel(); // Automatically creates a Sheet1
  //     final Sheet sheet = excel['Tasks'];

  //     // Write headers
  //     sheet.appendRow([
  //       'taskId',
  //       'title',
  //       'description',
  //       'duration',
  //       'place',
  //       'departmentId',
  //       'frequency',
  //       'dayOrDate',
  //     ]);

  //     // Write task rows
  //     for (var task in tasks) {
  //       sheet.appendRow([
  //         task.taskId,
  //         task.title,
  //         task.desc,
  //         task.duration,
  //         task.place,
  //         task.assignedDepartmentId ?? '', // Handle null safely
  //         task.frequency,
  //         task.dayOrDate,
  //       ]);
  //     }

  //     // Save to local file
  //     final List<int>? fileBytes = excel.encode();
  //     if (fileBytes == null) {
  //       throw Exception("Failed to encode Excel file");
  //     }

  //     final directory = await getExternalStorageDirectory(); // Android-safe
  //     final filePath = '${directory!.path}/exported_tasks.xlsx';
  //     final file = File(filePath)
  //       ..createSync(recursive: true)
  //       ..writeAsBytesSync(fileBytes);

  //     print("✅ Excel file saved: $filePath");
  //   } catch (e) {
  //     print("❌ Error exporting tasks: $e");
  //   }
  // }
}
