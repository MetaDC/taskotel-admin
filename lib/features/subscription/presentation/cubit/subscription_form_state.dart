// lib/presentation/cubits/subscription_form/subscription_form_state.dart
part of 'subscription_form_cubit.dart';

class SubscriptionFormState extends Equatable {
  final SubscriptionPlanModel? planToEdit;
  final List<String> features;
  final bool isActive;
  final bool forGeneral;
  final bool isEditMode;
  final bool isSubmitting;
  final bool isSubmitted;
  final String? validationMessage;
  final String? submitError;
  final String? successMessage;

  const SubscriptionFormState({
    this.planToEdit,
    required this.features,
    required this.isActive,
    required this.forGeneral,
    required this.isEditMode,
    required this.isSubmitting,
    required this.isSubmitted,
    this.validationMessage,
    this.submitError,
    this.successMessage,
  });

  factory SubscriptionFormState.initial() {
    return const SubscriptionFormState(
      features: [],
      isActive: true,
      forGeneral: true,
      isEditMode: false,
      isSubmitting: false,
      isSubmitted: false,
    );
  }

  SubscriptionFormState copyWith({
    SubscriptionPlanModel? planToEdit,
    List<String>? features,
    bool? isActive,
    bool? forGeneral,
    bool? isEditMode,
    bool? isSubmitting,
    bool? isSubmitted,
    String? validationMessage,
    String? submitError,
    String? successMessage,
  }) {
    return SubscriptionFormState(
      planToEdit: planToEdit ?? this.planToEdit,
      features: features ?? this.features,
      isActive: isActive ?? this.isActive,
      forGeneral: forGeneral ?? this.forGeneral,
      isEditMode: isEditMode ?? this.isEditMode,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      validationMessage: validationMessage,
      submitError: submitError,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
    planToEdit,
    features,
    isActive,
    forGeneral,
    isEditMode,
    isSubmitting,
    isSubmitted,
    validationMessage,
    submitError,
    successMessage,
  ];
}
