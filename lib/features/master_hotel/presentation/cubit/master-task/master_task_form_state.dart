part of 'master_task_form_cubit.dart';

class MasterTaskFormState extends Equatable {
  final String? selectedCategory;
  final PlatformFile? selectedFile;
  final bool isDownloadingTemplate;
  final bool isCreating;
  final bool isSuccess;

  const MasterTaskFormState({
    this.selectedCategory,
    this.selectedFile,
    required this.isDownloadingTemplate,
    required this.isCreating,
    required this.isSuccess,
  });
  factory MasterTaskFormState.initial() {
    return const MasterTaskFormState(
      selectedCategory: null,
      selectedFile: null,
      isDownloadingTemplate: false,
      isCreating: false,
      isSuccess: false,
    );
  }
  MasterTaskFormState copyWith({
    String? selectedCategory,
    PlatformFile? selectedFile,
    bool? isDownloadingTemplate,
    bool? isCreating,
    bool? isSuccess,
  }) {
    return MasterTaskFormState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedFile: selectedFile ?? this.selectedFile,
      isDownloadingTemplate:
          isDownloadingTemplate ?? this.isDownloadingTemplate,
      isCreating: isCreating ?? this.isCreating,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object> get props => [
    selectedCategory!,
    selectedFile!,
    isDownloadingTemplate,
    isCreating,
    isSuccess,
  ];
}
