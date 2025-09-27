// part of 'mastertask_form_cubit.dart';

// class MasterTaskFormState extends Equatable {
//   // Form fields
//   final String title;
//   final String description;
//   final int duration;
//   final String place;
//   final String department;
//   final String dayOrDate;
//   final String selectedFrequency;
//   final String assignedRole;
//   final bool isActive;

//   // Form state
//   final bool isFormValid;
//   final bool isSubmitting;
//   final bool isProcessing;
//   final String? errorMessage;
//   final String? successMessage;

//   // Mode flags
//   final bool isEditMode;
//   final bool isImportMode;

//   // Data
//   final String hotelId;
//   final MasterTaskModel? taskToEdit;
//   final List<String> departmentOptions;
//   final List<String> frequencyOptions;

//   // Import specific fields
//   final File? selectedFile;
//   final List<Map<String, dynamic>> previewData;

//   const MasterTaskFormState({
//     required this.title,
//     required this.description,
//     required this.duration,
//     required this.place,
//     required this.department,
//     required this.dayOrDate,
//     required this.selectedFrequency,
//     required this.assignedRole,
//     required this.isActive,
//     required this.isFormValid,
//     required this.isSubmitting,
//     required this.isProcessing,
//     this.errorMessage,
//     this.successMessage,
//     required this.isEditMode,
//     required this.isImportMode,
//     required this.hotelId,
//     this.taskToEdit,
//     required this.departmentOptions,
//     required this.frequencyOptions,
//     this.selectedFile,
//     required this.previewData,
//   });

//   factory MasterTaskFormState.initial() {
//     return const MasterTaskFormState(
//       title: '',
//       description: '',
//       duration: 30,
//       place: '',
//       department: 'General',
//       dayOrDate: '',
//       selectedFrequency: 'Daily',
//       assignedRole: 'rm',
//       isActive: true,
//       isFormValid: false,
//       isSubmitting: false,
//       isProcessing: false,
//       errorMessage: null,
//       successMessage: null,
//       isEditMode: false,
//       isImportMode: false,
//       hotelId: '',
//       taskToEdit: null,
//       departmentOptions: ['General'],
//       frequencyOptions: ['Daily', 'Weekly', 'Monthly', 'Yearly'],
//       selectedFile: null,
//       previewData: [],
//     );
//   }

//   MasterTaskFormState copyWith({
//     String? title,
//     String? description,
//     int? duration,
//     String? place,
//     String? department,
//     String? dayOrDate,
//     String? selectedFrequency,
//     String? assignedRole,
//     bool? isActive,
//     bool? isFormValid,
//     bool? isSubmitting,
//     bool? isProcessing,
//     String? errorMessage,
//     String? successMessage,
//     bool? isEditMode,
//     bool? isImportMode,
//     String? hotelId,
//     MasterTaskModel? taskToEdit,
//     List<String>? departmentOptions,
//     List<String>? frequencyOptions,
//     File? selectedFile,
//     List<Map<String, dynamic>>? previewData,
//   }) {
//     return MasterTaskFormState(
//       title: title ?? this.title,
//       description: description ?? this.description,
//       duration: duration ?? this.duration,
//       place: place ?? this.place,
//       department: department ?? this.department,
//       dayOrDate: dayOrDate ?? this.dayOrDate,
//       selectedFrequency: selectedFrequency ?? this.selectedFrequency,
//       assignedRole: assignedRole ?? this.assignedRole,
//       isActive: isActive ?? this.isActive,
//       isFormValid: isFormValid ?? this.isFormValid,
//       isSubmitting: isSubmitting ?? this.isSubmitting,
//       isProcessing: isProcessing ?? this.isProcessing,
//       errorMessage: errorMessage,
//       successMessage: successMessage,
//       isEditMode: isEditMode ?? this.isEditMode,
//       isImportMode: isImportMode ?? this.isImportMode,
//       hotelId: hotelId ?? this.hotelId,
//       taskToEdit: taskToEdit ?? this.taskToEdit,
//       departmentOptions: departmentOptions ?? this.departmentOptions,
//       frequencyOptions: frequencyOptions ?? this.frequencyOptions,
//       selectedFile: selectedFile ?? this.selectedFile,
//       previewData: previewData ?? this.previewData,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     title,
//     description,
//     duration,
//     place,
//     department,
//     dayOrDate,
//     selectedFrequency,
//     assignedRole,
//     isActive,
//     isFormValid,
//     isSubmitting,
//     isProcessing,
//     errorMessage,
//     successMessage,
//     isEditMode,
//     isImportMode,
//     hotelId,
//     taskToEdit,
//     departmentOptions,
//     frequencyOptions,
//     selectedFile,
//     previewData,
//   ];
// }
