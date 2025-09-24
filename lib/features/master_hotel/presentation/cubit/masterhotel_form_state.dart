part of 'masterhotel_form_cubit.dart';



class MasterhotelFormState extends Equatable{
  final bool isLoading;
  final String? message;
  final String? selectedPropertyType;

  const MasterhotelFormState({
    required this.isLoading,
    this.message,
    this.selectedPropertyType,
  });

  // Initial state
  factory MasterhotelFormState.initial() {
    return const MasterhotelFormState(
      isLoading: false,
      message: null,
      selectedPropertyType: null,
    );
  }

  // Copy with method to update state
  MasterhotelFormState copyWith({
    bool? isLoading,
    String? message,
    String? selectedPropertyType,
  }) {
    return MasterhotelFormState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      selectedPropertyType: selectedPropertyType ?? this.selectedPropertyType,
    );
  }

  @override
  List<Object?> get props => [isLoading, message, selectedPropertyType];
}
