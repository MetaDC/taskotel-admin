part of 'client_form_cubit.dart';

class ClientFormState extends Equatable {
  final String message;
  final bool isLoading;
  final String selectedStatus;

  const ClientFormState({
    required this.message,
    required this.isLoading,
    required this.selectedStatus,
  });

  factory ClientFormState.initial() {
    return const ClientFormState(
      message: '',
      isLoading: false,
      selectedStatus: 'active',
    );
  }

  ClientFormState copyWith({
    String? message,
    bool? isLoading,
    String? selectedStatus,
  }) {
    return ClientFormState(
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }

  @override
  List<Object?> get props => [message, isLoading, selectedStatus];
}
