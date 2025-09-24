part of 'masterhotel_form_cubit.dart';

class MasterhotelFormState extends Equatable {
  final bool isLoading;
  final String? message;
  final String? selectedPropertyType;
  final SelectedImage? selectedFile;
  final String? dbFile;

  const MasterhotelFormState({
    required this.isLoading,
    this.message,
    this.selectedPropertyType,
    this.dbFile,
    this.selectedFile,
  });

  // Initial state
  factory MasterhotelFormState.initial() {
    return const MasterhotelFormState(
      isLoading: false,
      message: null,
      selectedPropertyType: null,
      selectedFile: null,
      dbFile: null,
    );
  }

  // Copy with method to update state
  MasterhotelFormState copyWith({
    bool? isLoading,
    String? message,
    String? selectedPropertyType,
    dynamic selectedFile,
    dynamic dbFile,
  }) {
    return MasterhotelFormState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      selectedPropertyType: selectedPropertyType ?? this.selectedPropertyType,
      dbFile: dbFile is bool ? null : (dbFile ?? this.dbFile),
      selectedFile: selectedFile is bool
          ? null
          : (selectedFile ?? this.selectedFile),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    message,
    selectedPropertyType,
    selectedFile, // Add selectedFile to props
    dbFile, // Add dbFile to props
  ];
}
