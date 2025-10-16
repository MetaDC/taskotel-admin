import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
import 'package:taskoteladmin/features/clients/domain/entity/question_model.dart';
import 'package:taskoteladmin/features/master_hotel/data/masterhotel_firebaserepo.dart';
import 'package:excel/excel.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';
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

    final updatedQuestions = List<QuestionModel>.from(state.questions)
      ..add(
        QuestionModel(
          questionId: UniqueKey().toString(),
          question: questionText,
          type: 'text',
          options: null,
          answer: null,
        ),
      );

    questionController.clear();
    emit(state.copyWith(questions: updatedQuestions, validationMessage: null));
  }

  void removeQuestion(int index) {
    final updatedQuestions = List<QuestionModel>.from(state.questions)
      ..removeAt(index);
    emit(state.copyWith(questions: updatedQuestions));
  }

  // Download template
  Future<void> downloadTemplate() async {
    emit(state.copyWith(isDownloadingTemplate: true));

    try {
      exportEmptyTemplateToExcel();
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

  //createNewTasks
  void createNewTasks(bool value) {
    emit(state.copyWith(isCreateNewTasks: value));
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
        questions: state.questions
            .map((e) => QuestionModel.fromMap(e.toMap()))
            .toList(),
        fromMasterHotel: null,
        isActive: state.isActive,
      );

      if (state.isEditMode && taskToEdit != null) {
        await masterHotelRepo.updateTaskForHotel(taskToEdit.docId, task);
      } else {
        await masterHotelRepo.createTaskForHotel(task);
        // Update master hotel task count for new tasks
        await _updateMasterHotelTaskCount(masterHotelId);
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

      // Step 1: Pre-check for duplicates if isCreateNewTasks is true
      if (state.isCreateNewTasks) {
        for (var task in importTaskList) {
          // Check for existing task with same taskId AND assignedRole
          List<CommonTaskModel> existingTasks = await masterHotelRepo
              .getTaskForExcel(masterHotelId, task.taskId);

          // Filter by assignedRole to check if this specific role already has this task
          List<CommonTaskModel> roleSpecificTasks = existingTasks
              .where((t) => t.assignedRole == task.assignedRole)
              .toList();

          if (roleSpecificTasks.isNotEmpty) {
            throw Exception(
              'Task ID ${task.taskId} already exists for role ${task.assignedRole}. Import aborted.',
            );
          }
        }

        // All task IDs are unique for the selected role — safe to create
        for (var task in importTaskList) {
          await masterHotelRepo.createTaskForHotel(task);
        }
      } else {
        // isCreateNewTasks == false — create or update for specific role
        for (var task in importTaskList) {
          List<CommonTaskModel> existingTasks = await masterHotelRepo
              .getTaskForExcel(masterHotelId, task.taskId);

          // Filter to find task for the specific role
          List<CommonTaskModel> roleSpecificTasks = existingTasks
              .where((t) => t.assignedRole == task.assignedRole)
              .toList();

          if (roleSpecificTasks.isNotEmpty) {
            // Update only the task for this specific role
            await masterHotelRepo.updateTaskForHotel(
              roleSpecificTasks.first.docId,
              task,
            );
          } else {
            // Create new task for this role (even if taskId exists for other roles)
            await masterHotelRepo.createTaskForHotel(task);
          }
        }
      }

      // Update master hotel task count
      await _updateMasterHotelTaskCount(masterHotelId);

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

  // Helper method to update master hotel task count
  Future<void> _updateMasterHotelTaskCount(String masterHotelId) async {
    try {
      // Get all tasks for this hotel
      final allTasksSnapshot = await FBFireStore.tasks
          .where('hotelId', isEqualTo: masterHotelId)
          .get();

      final totalTasks = allTasksSnapshot.docs.length;

      // Update the master hotel document
      await masterHotelRepo.updateMasterHotelTaskCount(
        masterHotelId,
        totalTasks,
      );
    } catch (e) {
      print('Error updating master hotel task count: $e');
    }
  }

  // Helper method for web download using package:web
  // Helper method for web download using package:web
  void _downloadFileWeb(List<int> bytes, String fileName) {
    if (kIsWeb) {
      // Convert List<int> to Uint8List first
      final uint8List = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);

      final blob = web.Blob(
        [uint8List.toJS].toJS,
        web.BlobPropertyBag(
          type:
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        ),
      );

      final url = web.URL.createObjectURL(blob);
      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = url;
      anchor.download = fileName;
      anchor.click();

      web.URL.revokeObjectURL(url);
    }
  }

  // Template with examples
  Future<void> exportTemplateToExcel() async {
    try {
      final excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];

      final headers = [
        'Task ID',
        'Title',
        'Description',
        'Duration',
        'Place',
        'Department ID',
        'Frequency',
        'Day or Date',
      ];
      sheet.appendRow(headers.map((e) => TextCellValue(e)).toList());

      final exampleRows = [
        [
          'TASK001',
          'Clean Reception Area',
          'Sweep and mop the reception floor, dust furniture',
          '30',
          'Reception',
          'DEPT001',
          'Daily',
          'Monday',
        ],
        [
          'TASK002',
          'Check Fire Extinguishers',
          'Inspect all fire extinguishers for expiry and damage',
          '45',
          'All Floors',
          'DEPT002',
          'Weekly',
          '2024-01-15',
        ],
        [
          'TASK003',
          'Inventory Check',
          'Count and record all cleaning supplies',
          '60',
          'Storage Room',
          'DEPT001',
          'Monthly',
          '1st of Month',
        ],
      ];

      for (var row in exampleRows) {
        sheet.appendRow(row.map((e) => TextCellValue(e)).toList());
      }

      // Style headers
      for (var i = 0; i < headers.length; i++) {
        var cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
        );
        cell.cellStyle = CellStyle(bold: true, fontSize: 12);
      }

      print("📊 Template created with ${sheet.maxRows} rows");

      final List<int>? fileBytes = excel.encode();
      if (fileBytes == null) {
        throw Exception("Failed to encode Excel file");
      }

      if (kIsWeb) {
        _downloadFileWeb(fileBytes, 'tasks_template.xlsx');
        print("✅ Template downloaded");
      } else {
        if (Platform.isAndroid) {
          var status = await Permission.storage.request();
          if (!status.isGranted) {
            throw Exception("Storage permission not granted");
          }
        }

        final directory = await getExternalStorageDirectory();
        final filePath = '${directory!.path}/tasks_template.xlsx';
        final file = File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);

        print("✅ Template saved: $filePath");
      }
    } catch (e) {
      print("❌ Error exporting template: $e");
      rethrow;
    }
  }

  // Empty template (headers only)
  Future<void> exportEmptyTemplateToExcel() async {
    try {
      final excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];

      final headers = [
        'Task ID',
        'Title',
        'Description',
        'Duration',
        'Place',
        'Department ID',
        'Frequency',
        'Day or Date',
      ];
      sheet.appendRow(headers.map((e) => TextCellValue(e)).toList());

      // Style headers
      for (var i = 0; i < headers.length; i++) {
        var cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
        );
        cell.cellStyle = CellStyle(bold: true, fontSize: 12);
      }

      print("📊 Empty template created");

      final List<int>? fileBytes = excel.encode();
      if (fileBytes == null) {
        throw Exception("Failed to encode Excel file");
      }

      if (kIsWeb) {
        _downloadFileWeb(fileBytes, 'tasks_template_empty.xlsx');
        print("✅ Empty template downloaded");
      } else {
        if (Platform.isAndroid) {
          var status = await Permission.storage.request();
          if (!status.isGranted) {
            throw Exception("Storage permission not granted");
          }
        }

        final directory = await getExternalStorageDirectory();
        final filePath = '${directory!.path}/tasks_template_empty.xlsx';
        final file = File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);

        print("✅ Empty template saved: $filePath");
      }
    } catch (e) {
      print("❌ Error exporting empty template: $e");
      rethrow;
    }
  }
}
