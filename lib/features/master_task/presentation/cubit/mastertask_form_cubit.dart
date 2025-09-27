// import 'dart:async';
// import 'dart:io';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:excel/excel.dart' as excel;
// import 'package:taskoteladmin/features/master_task/domain/model/mastertask_model.dart';
// import 'package:taskoteladmin/features/master_task/domain/repo/mastertask_repo.dart';
// import 'package:taskoteladmin/core/utils/excel_utils.dart';

// part 'mastertask_form_state.dart';

// class MasterTaskFormCubit extends Cubit<MasterTaskFormState> {
//   final MasterTaskRepo masterTaskRepo;

//   MasterTaskFormCubit({required this.masterTaskRepo})
//     : super(MasterTaskFormState.initial());

//   // Initialize form for creating new task
//   void initializeForCreate(String hotelId, String assignedRole) {
//     final departments = _getDepartmentsByRole(assignedRole);

//     emit(
//       MasterTaskFormState.initial().copyWith(
//         hotelId: hotelId,
//         assignedRole: assignedRole,
//         isEditMode: false,
//         departmentOptions: departments,
//         department: departments.first,
//       ),
//     );
//     _validateForm();
//   }

//   // Initialize form for editing existing task
//   void initializeForEdit(MasterTaskModel task) {
//     final departments = _getDepartmentsByRole(task.assignedRole);

//     emit(
//       state.copyWith(
//         hotelId: task.hotelId,
//         taskToEdit: task,
//         isEditMode: true,
//         // Populate form fields
//         title: task.title,
//         description: task.desc,
//         duration: task.duration,
//         place: task.place ?? '',
//         department: task.departmentId,
//         dayOrDate: task.dayOrDate ?? '',
//         selectedFrequency: task.frequency,
//         assignedRole: task.assignedRole,
//         isActive: task.isActive,
//         departmentOptions: departments,
//       ),
//     );
//     _validateForm();
//   }

//   // Initialize for import mode
//   void initializeForImport(String hotelId, String userCategory) {
//     emit(
//       state.copyWith(
//         hotelId: hotelId,
//         assignedRole: userCategory,
//         isImportMode: true,
//         isEditMode: false,
//         departmentOptions: _getDepartmentsByRole(userCategory),
//       ),
//     );
//   }

//   // Get departments based on role
//   List<String> _getDepartmentsByRole(String role) {
//     if (role == 'dm') {
//       // Department Manager specific departments
//       return [
//         'Housekeeping',
//         'Front Office',
//         'Food & Beverage',
//         'Maintenance',
//         'Security',
//         'Management',
//         'Guest Services',
//         'HR',
//         'Finance',
//         'Kitchen',
//         'Laundry',
//         'Spa & Wellness',
//       ];
//     } else {
//       // Other roles - general departments
//       return ['General', 'Operations', 'Management', 'Administration'];
//     }
//   }

//   // Update form field values
//   void updateTitle(String title) {
//     emit(state.copyWith(title: title));
//     _validateForm();
//   }

//   void updateDescription(String description) {
//     emit(state.copyWith(description: description));
//     _validateForm();
//   }

//   void updateDuration(int duration) {
//     emit(state.copyWith(duration: duration));
//     _validateForm();
//   }

//   void updatePlace(String place) {
//     emit(state.copyWith(place: place));
//   }

//   void updateDayOrDate(String dayOrDate) {
//     emit(state.copyWith(dayOrDate: dayOrDate));
//   }

//   void updateFrequency(String frequency) {
//     emit(state.copyWith(selectedFrequency: frequency));
//   }

//   void updateAssignedRole(String role) {
//     final newDepartments = _getDepartmentsByRole(role);
//     emit(
//       state.copyWith(
//         assignedRole: role,
//         departmentOptions: newDepartments,
//         department:
//             newDepartments.first, // Reset to first department of new role
//       ),
//     );
//     _validateForm();
//   }

//   void updateDepartment(String department) {
//     emit(state.copyWith(department: department));
//     _validateForm();
//   }

//   void updateActiveStatus(bool isActive) {
//     emit(state.copyWith(isActive: isActive));
//   }

//   // Validate form
//   void _validateForm() {
//     final isValid =
//         state.title.trim().isNotEmpty &&
//         state.description.trim().isNotEmpty &&
//         state.duration > 0 &&
//         state.department.isNotEmpty;

//     emit(state.copyWith(isFormValid: isValid));
//   }

//   // Create or update task
//   Future<void> saveTask() async {
//     if (!state.isFormValid) return;

//     emit(state.copyWith(isSubmitting: true, errorMessage: null));

//     try {
//       final now = DateTime.now();
//       final task = MasterTaskModel(
//         docId: state.taskToEdit?.docId ?? '',
//         title: state.title.trim(),
//         desc: state.description.trim(),
//         createdAt: state.taskToEdit?.createdAt ?? now,
//         createdByDocId: 'admin', // TODO: Get from auth
//         createdByName: 'Admin',
//         updatedAt: now,
//         updatedBy: 'admin',
//         updatedByName: 'Admin',
//         duration: state.duration,
//         place: state.place.trim().isEmpty ? null : state.place.trim(),
//         questions: [], // TODO: Add questions functionality
//         departmentId: state.department,
//         hotelId: state.hotelId,
//         assignedRole: state.assignedRole,
//         frequency: state.selectedFrequency,
//         dayOrDate: state.dayOrDate.trim().isEmpty
//             ? null
//             : state.dayOrDate.trim(),
//         isActive: state.isActive,
//         startedAt: null,
//         endedAt: null,
//         serviceType: null,
//       );

//       if (state.isEditMode) {
//         await masterTaskRepo.updateTask(task);
//         emit(
//           state.copyWith(
//             isSubmitting: false,
//             successMessage: 'Task updated successfully',
//           ),
//         );
//       } else {
//         await masterTaskRepo.createTask(task);
//         emit(
//           state.copyWith(
//             isSubmitting: false,
//             successMessage: 'Task created successfully',
//           ),
//         );
//       }
//     } catch (e) {
//       emit(
//         state.copyWith(
//           isSubmitting: false,
//           errorMessage: 'Failed to save task: $e',
//         ),
//       );
//     }
//   }

//   // Download Excel template
//   Future<void> downloadTemplate() async {
//     try {
//       emit(state.copyWith(errorMessage: null));
//       await ExcelUtils.downloadTemplate();
//       emit(state.copyWith(successMessage: 'Template downloaded successfully'));
//     } catch (e) {
//       emit(state.copyWith(errorMessage: 'Failed to download template: $e'));
//     }
//   }

//   // Pick Excel file for import
//   Future<void> pickExcelFile() async {
//     try {
//       emit(state.copyWith(errorMessage: null, successMessage: null));

//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['xlsx', 'xls'],
//       );

//       if (result != null) {
//         emit(
//           state.copyWith(
//             selectedFile: File(result.files.single.path!),
//             previewData: [], // Clear previous preview
//           ),
//         );
//         await _processExcelFile();
//       }
//     } catch (e) {
//       emit(state.copyWith(errorMessage: 'Error picking file: $e'));
//     }
//   }

//   // Process Excel file and generate preview
//   Future<void> _processExcelFile() async {
//     if (state.selectedFile == null) return;

//     emit(state.copyWith(isProcessing: true, errorMessage: null));

//     try {
//       var bytes = state.selectedFile!.readAsBytesSync();
//       var excelFile = excel.Excel.decodeBytes(bytes);

//       List<Map<String, dynamic>> tasks = [];

//       for (var table in excelFile.tables.keys) {
//         var sheet = excelFile.tables[table]!;

//         // Skip header row (assuming first row is header)
//         for (int i = 1; i < sheet.maxRows; i++) {
//           var row = sheet.rows[i];
//           if (row == null || row.isEmpty) continue;

//           // Skip rows that don't have minimum required data
//           if (row.length < 3) continue;

//           // Get cell values based on your Excel structure:
//           // A: title, B: Description, C: duration, D: place, E: department, F: frequency, G: dayOrDate
//           String title = _getCellValue(row, 0); // Column A
//           String description = _getCellValue(row, 1); // Column B
//           String durationStr = _getCellValue(row, 2); // Column C
//           String place = _getCellValue(row, 3); // Column D
//           String department = _getCellValue(row, 4); // Column E
//           String frequency = _getCellValue(row, 5); // Column F
//           String dayOrDate = _getCellValue(row, 6); // Column G

//           // Validate required fields
//           if (title.isEmpty || description.isEmpty) {
//             continue; // Skip rows with missing required data
//           }

//           // Parse duration
//           int duration = int.tryParse(durationStr) ?? 30;
//           if (duration <= 0) duration = 30;

//           // Set default frequency if empty or invalid
//           if (frequency.isEmpty ||
//               !state.frequencyOptions.contains(frequency)) {
//             frequency = 'Daily'; // Default frequency
//           }

//           // Set default department if empty or validate against role
//           if (department.isEmpty) {
//             department = _getDepartmentsByRole(state.assignedRole).first;
//           } else {
//             // Validate and adjust department based on selected role
//             final validDepartments = _getDepartmentsByRole(state.assignedRole);
//             if (!validDepartments.contains(department)) {
//               department = validDepartments.first;
//             }
//           }

//           Map<String, dynamic> taskData = {
//             'title': title,
//             'description': description,
//             'duration': duration,
//             'frequency': frequency,
//             'departmentId': department,
//           };

//           // Add optional fields only if they have values
//           if (place.isNotEmpty) {
//             taskData['place'] = place;
//           }

//           if (dayOrDate.isNotEmpty) {
//             taskData['dayOrDate'] = dayOrDate;
//           }

//           tasks.add(taskData);
//         }
//       }

//       emit(state.copyWith(previewData: tasks, isProcessing: false));

//       if (tasks.isEmpty) {
//         emit(
//           state.copyWith(
//             errorMessage:
//                 'No valid tasks found in the Excel file. Please ensure your file has data with at least Title and Description columns.',
//           ),
//         );
//       }
//     } catch (e) {
//       emit(
//         state.copyWith(
//           errorMessage: 'Error processing Excel file: ${e.toString()}',
//           isProcessing: false,
//         ),
//       );
//     }
//   }

//   // Helper method to safely get cell value
//   String _getCellValue(List<excel.Data?> row, int columnIndex) {
//     try {
//       if (columnIndex >= row.length) return '';

//       final cell = row[columnIndex];
//       if (cell == null) return '';

//       final cellValue = cell.value;
//       if (cellValue == null) return '';

//       return cellValue.toString().trim();
//     } catch (e) {
//       return '';
//     }
//   }

//   // Import tasks from Excel
//   Future<void> importTasks() async {
//     if (state.previewData.isEmpty) return;

//     emit(state.copyWith(isSubmitting: true, errorMessage: null));

//     try {
//       await masterTaskRepo.importTasksFromExcel(
//         state.previewData,
//         state.hotelId,
//         state.assignedRole,
//       );
//       emit(
//         state.copyWith(
//           isSubmitting: false,
//           successMessage: 'Tasks imported successfully',
//         ),
//       );
//     } catch (e) {
//       emit(
//         state.copyWith(
//           isSubmitting: false,
//           errorMessage: 'Failed to import tasks: $e',
//         ),
//       );
//     }
//   }

//   // Clear selected file and preview
//   void clearSelectedFile() {
//     emit(
//       state.copyWith(selectedFile: null, previewData: [], errorMessage: null),
//     );
//   }

//   // Update import role (for import modal)
//   void updateImportRole(String role) {
//     emit(
//       state.copyWith(
//         assignedRole: role,
//         departmentOptions: _getDepartmentsByRole(role),
//         // Clear preview when role changes
//         previewData: [],
//         selectedFile: null,
//       ),
//     );
//   }

//   // Get form validation errors
//   Map<String, String> getValidationErrors() {
//     Map<String, String> errors = {};

//     if (state.title.trim().isEmpty) {
//       errors['title'] = 'Task title is required';
//     }

//     if (state.description.trim().isEmpty) {
//       errors['description'] = 'Description is required';
//     }

//     if (state.duration <= 0) {
//       errors['duration'] = 'Duration must be greater than 0';
//     }

//     if (state.department.isEmpty) {
//       errors['department'] = 'Department is required';
//     }

//     return errors;
//   }

//   // Check if specific field has error
//   bool hasFieldError(String field) {
//     return getValidationErrors().containsKey(field);
//   }

//   // Get error message for specific field
//   String? getFieldError(String field) {
//     return getValidationErrors()[field];
//   }

//   // Clear messages
//   void clearMessages() {
//     emit(state.copyWith(errorMessage: null, successMessage: null));
//   }

//   // Reset form to initial state
//   void resetForm() {
//     emit(MasterTaskFormState.initial());
//   }

//   // Get preview statistics
//   Map<String, dynamic> getPreviewStats() {
//     if (state.previewData.isEmpty) return {};

//     final departmentCount = <String, int>{};
//     final frequencyCount = <String, int>{};
//     int totalDuration = 0;

//     for (final task in state.previewData) {
//       // Count departments
//       final dept = task['departmentId'] ?? 'Unknown';
//       departmentCount[dept] = (departmentCount[dept] ?? 0) + 1;

//       // Count frequencies
//       final freq = task['frequency'] ?? 'Unknown';
//       frequencyCount[freq] = (frequencyCount[freq] ?? 0) + 1;

//       // Sum durations
//       totalDuration += (task['duration'] as int?) ?? 0;
//     }

//     return {
//       'totalTasks': state.previewData.length,
//       'departmentCount': departmentCount,
//       'frequencyCount': frequencyCount,
//       'totalDuration': totalDuration,
//       'averageDuration': state.previewData.isNotEmpty
//           ? (totalDuration / state.previewData.length).round()
//           : 0,
//     };
//   }

//   // Validate import data before importing
//   bool validateImportData() {
//     if (state.previewData.isEmpty) return false;

//     for (final task in state.previewData) {
//       if ((task['title'] ?? '').toString().trim().isEmpty) return false;
//       if ((task['description'] ?? '').toString().trim().isEmpty) return false;
//       if ((task['duration'] as int?) == null ||
//           (task['duration'] as int? ?? 0) <= 0)
//         return false;
//     }

//     return true;
//   }

//   // Get department options for current role
//   List<String> getCurrentDepartmentOptions() {
//     return state.departmentOptions;
//   }

//   // Check if current role is Department Manager
//   bool isDepartmentManager() {
//     return state.assignedRole == 'dm';
//   }

//   // Get frequency options
//   List<String> getFrequencyOptions() {
//     return state.frequencyOptions;
//   }
// }
