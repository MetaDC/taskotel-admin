import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as excel;
import 'package:taskoteladmin/features/master_task/domain/model/mastertask_model.dart';
import 'package:taskoteladmin/features/master_task/domain/repo/mastertask_repo.dart';
import 'package:taskoteladmin/core/utils/excel_utils.dart';

part 'mastertask_form_state.dart';

class MasterTaskFormCubit extends Cubit<MasterTaskFormState> {
  final MasterTaskRepo masterTaskRepo;

  MasterTaskFormCubit({required this.masterTaskRepo})
    : super(MasterTaskFormState.initial());

  // Initialize form for creating new task
  void initializeForCreate(String hotelId, String assignedRole) {
    emit(
      MasterTaskFormState.initial().copyWith(
        hotelId: hotelId,
        assignedRole: assignedRole,
        isEditMode: false,
      ),
    );
    _updateDepartmentOptions();
  }

  // Initialize form for editing existing task
  void initializeForEdit(MasterTaskModel task) {
    emit(
      state.copyWith(
        hotelId: task.hotelId,
        taskToEdit: task,
        isEditMode: true,
        // Populate form fields
        title: task.title,
        description: task.desc,
        duration: task.duration,
        place: task.place ?? '',
        department: task.departmentId,
        dayOrDate: task.dayOrDate ?? '',
        selectedFrequency: task.frequency,
        assignedRole: task.assignedRole,
        isActive: task.isActive,
        isFormValid: true,
      ),
    );
    _updateDepartmentOptions();
  }

  // Update form field values
  void updateTitle(String title) {
    emit(state.copyWith(title: title));
    _validateForm();
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
    _validateForm();
  }

  void updateDuration(int duration) {
    emit(state.copyWith(duration: duration));
    _validateForm();
  }

  void updatePlace(String place) {
    emit(state.copyWith(place: place));
  }

  void updateDayOrDate(String dayOrDate) {
    emit(state.copyWith(dayOrDate: dayOrDate));
  }

  void updateFrequency(String frequency) {
    emit(state.copyWith(selectedFrequency: frequency));
  }

  void updateAssignedRole(String role) {
    emit(state.copyWith(assignedRole: role));
    _updateDepartmentOptions();
    _validateForm();
  }

  void updateDepartment(String department) {
    emit(state.copyWith(department: department));
    _validateForm();
  }

  void updateActiveStatus(bool isActive) {
    emit(state.copyWith(isActive: isActive));
  }

  // Update department options based on selected role
  void _updateDepartmentOptions() {
    List<String> departments;

    if (state.assignedRole == 'dm') {
      // For Department Manager, show specific departments
      departments = [
        'Housekeeping',
        'Front Office',
        'Food & Beverage',
        'Maintenance',
        'Security',
        'Guest Services',
        'Kitchen',
        'Laundry',
        'Spa & Wellness',
      ];
    } else {
      // For other roles (rm, gm, operator), show general options
      departments = ['General', 'Operations', 'Management', 'Administration'];
    }

    emit(
      state.copyWith(
        departmentOptions: departments,
        department: departments.first, // Set default to first option
      ),
    );
  }

  // Validate form
  void _validateForm() {
    final isValid =
        state.title.isNotEmpty &&
        state.description.isNotEmpty &&
        state.duration > 0 &&
        state.department.isNotEmpty;

    emit(state.copyWith(isFormValid: isValid));
  }

  // Create or update task
  Future<void> saveTask() async {
    if (!state.isFormValid) return;

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final now = DateTime.now();
      final task = MasterTaskModel(
        docId: state.taskToEdit?.docId ?? '',
        title: state.title,
        desc: state.description,
        createdAt: state.taskToEdit?.createdAt ?? now,
        createdByDocId: 'admin', // TODO: Get from auth
        createdByName: 'Admin',
        updatedAt: now,
        updatedBy: 'admin',
        updatedByName: 'Admin',
        duration: state.duration,
        place: state.place.isEmpty ? null : state.place,
        questions: [], // TODO: Add questions functionality
        departmentId: state.department,
        hotelId: state.hotelId,
        assignedRole: state.assignedRole,
        frequency: state.selectedFrequency,
        dayOrDate: state.dayOrDate.isEmpty ? null : state.dayOrDate,
        isActive: state.isActive,
        startedAt: null,
        endedAt: null,
        serviceType: null,
      );

      if (state.isEditMode) {
        await masterTaskRepo.updateTask(task);
        emit(
          state.copyWith(
            isSubmitting: false,
            successMessage: 'Task updated successfully',
          ),
        );
      } else {
        await masterTaskRepo.createTask(task);
        emit(
          state.copyWith(
            isSubmitting: false,
            successMessage: 'Task created successfully',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to save task: $e',
        ),
      );
    }
  }

  // Import Excel functionality
  void initializeImport(String hotelId, String userCategory) {
    emit(
      state.copyWith(
        hotelId: hotelId,
        assignedRole: userCategory,
        isImportMode: true,
      ),
    );
  }

  Future<void> downloadTemplate() async {
    try {
      await ExcelUtils.downloadTemplate();
      emit(state.copyWith(successMessage: 'Template downloaded successfully'));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to download template: $e'));
    }
  }

  Future<void> pickExcelFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        emit(
          state.copyWith(
            selectedFile: File(result.files.single.path!),
            errorMessage: null,
          ),
        );
        await _processExcelFile();
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Error picking file: $e'));
    }
  }

  Future<void> _processExcelFile() async {
    if (state.selectedFile == null) return;

    emit(state.copyWith(isProcessing: true, errorMessage: null));

    try {
      var bytes = state.selectedFile!.readAsBytesSync();
      var excelFile = excel.Excel.decodeBytes(bytes);

      List<Map<String, dynamic>> tasks = [];

      for (var table in excelFile.tables.keys) {
        var sheet = excelFile.tables[table]!;

        // Skip header row (assuming first row is header)
        for (int i = 1; i < sheet.maxRows; i++) {
          var row = sheet.rows[i];
          if (row.isEmpty) continue;

          // Expected columns: Title, Description, Duration, Frequency, Department, Place, Day/Date
          tasks.add({
            'title': row[0]?.value?.toString() ?? '',
            'description': row[1]?.value?.toString() ?? '',
            'duration': int.tryParse(row[2]?.value?.toString() ?? '30') ?? 30,
            'frequency': row[3]?.value?.toString() ?? 'Daily',
            'departmentId': row[4]?.value?.toString() ?? 'General',
            'place': row[5]?.value?.toString(),
            'dayOrDate': row[6]?.value?.toString(),
          });
        }
      }

      emit(state.copyWith(previewData: tasks, isProcessing: false));

      if (tasks.isEmpty) {
        emit(
          state.copyWith(
            errorMessage: 'No valid tasks found in the Excel file',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Error processing Excel file: $e',
          isProcessing: false,
        ),
      );
    }
  }

  Future<void> importTasks() async {
    if (state.previewData.isEmpty) return;

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      await masterTaskRepo.importTasksFromExcel(
        state.previewData,
        state.hotelId,
        state.assignedRole,
      );
      emit(
        state.copyWith(
          isSubmitting: false,
          successMessage: 'Tasks imported successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to import tasks: $e',
        ),
      );
    }
  }

  // Clear messages
  void clearMessages() {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }

  // Reset form
  void resetForm() {
    emit(MasterTaskFormState.initial());
  }
}
