part of 'masterhotel_form_cubit.dart';

class MasterhotelFormState {
  final bool isLoading;
  final String? message;
  final String? selectedPropertyType;
  final SelectedImage? selectedFile;
  final String? dbFile;
  final String? dbFileExt;
  final String? dbFileName;

  const MasterhotelFormState({
    required this.isLoading,
    this.message,
    this.selectedPropertyType,
    this.dbFile,
    this.selectedFile,
    this.dbFileExt,
    this.dbFileName,
  });

  // Initial state
  factory MasterhotelFormState.initial() {
    return const MasterhotelFormState(
      isLoading: false,
      message: null,
      selectedPropertyType: null,
      selectedFile: null,
      dbFile: null,
      dbFileExt: null,
      dbFileName: '',
    );
  }

  // Copy with method to update state
  MasterhotelFormState copyWith({
    bool? isLoading,
    String? message,
    String? selectedPropertyType,
    dynamic selectedFile,
    dynamic dbFile,
    String? dbFileExt,
    String? dbFileName,
  }) {
    return MasterhotelFormState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      selectedPropertyType: selectedPropertyType ?? this.selectedPropertyType,
      dbFile: dbFile is bool ? null : (dbFile ?? this.dbFile),
      selectedFile: selectedFile is bool
          ? null
          : (selectedFile ?? this.selectedFile),
      dbFileExt: dbFileExt ?? this.dbFileExt,
      dbFileName: dbFileName ?? this.dbFileName,
    );
  }
}
