part of 'master_task_form_cubit.dart';

class MasterTaskFormState {
  final String? selectedCategory;
  PlatformFile? selectedFile;
  final bool isDownloadingTemplate;
  final bool isCreating;
  final bool isSuccess;
  final String? errorMessage;
  final String? validationMessage;

  // Only state values that trigger UI updates
  final String? selectedFrequency;
  final String? selectedDepartment;
  final String? selectedServiceType;
  final List<Map<String, dynamic>> questions;
  final bool isActive;
  final bool isEditMode;

  MasterTaskFormState({
    this.selectedCategory,
    this.selectedFile,
    this.isDownloadingTemplate = false,
    this.isCreating = false,
    this.isSuccess = false,
    this.errorMessage,
    this.validationMessage,
    this.selectedFrequency,
    this.selectedDepartment,
    this.selectedServiceType,
    this.questions = const [],
    this.isActive = true,
    this.isEditMode = false,
  });

  factory MasterTaskFormState.initial() {
    return MasterTaskFormState();
  }

  MasterTaskFormState copyWith({
    String? selectedCategory,
    PlatformFile? selectedFile,
    bool? isDownloadingTemplate,
    bool? isCreating,
    bool? isSuccess,
    String? errorMessage,
    String? validationMessage,
    String? selectedFrequency,
    String? selectedDepartment,
    String? selectedServiceType,
    List<Map<String, dynamic>>? questions,
    bool? isActive,
    bool? isEditMode,
  }) {
    return MasterTaskFormState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedFile: selectedFile ?? this.selectedFile,
      isDownloadingTemplate:
          isDownloadingTemplate ?? this.isDownloadingTemplate,
      isCreating: isCreating ?? this.isCreating,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      validationMessage: validationMessage,
      selectedFrequency: selectedFrequency ?? this.selectedFrequency,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      selectedServiceType: selectedServiceType ?? this.selectedServiceType,
      questions: questions ?? this.questions,
      isActive: isActive ?? this.isActive,
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }
}
