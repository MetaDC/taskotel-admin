// ==================== STATE FILE ====================
// Path: features/subscription/presentation/cubit/assign_plan_state.dart

import 'package:equatable/equatable.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';

class AssignPlanState extends Equatable {
  final bool isLoading;
  final bool isAssigning;
  final List<SubscriptionPlanModel> subscriptionPlans;
  final List<SubscriptionPlanModel> activePlans;

  // Form fields
  final String? selectedPlanType; // "trial" | "gift"
  final SubscriptionPlanModel? selectedPlan;
  final int allowedHotels;
  final int duration; // in days (always)

  // Optional date fields (separate from duration)
  final DateTime? redeemStartAt;
  final DateTime? redeemEndAt;

  // UI state
  final String? errorMessage;
  final String? successMessage;

  const AssignPlanState({
    this.isLoading = false,
    this.isAssigning = false,
    this.subscriptionPlans = const [],
    this.activePlans = const [],
    this.selectedPlanType,
    this.selectedPlan,
    this.allowedHotels = 1,
    this.duration = 30,
    this.redeemStartAt,
    this.redeemEndAt,
    this.errorMessage,
    this.successMessage,
  });

  AssignPlanState copyWith({
    bool? isLoading,
    bool? isAssigning,
    List<SubscriptionPlanModel>? subscriptionPlans,
    List<SubscriptionPlanModel>? activePlans,
    String? selectedPlanType,
    SubscriptionPlanModel? selectedPlan,
    int? allowedHotels,
    int? duration,
    DateTime? redeemStartAt,
    DateTime? redeemEndAt,
    String? errorMessage,
    String? successMessage,
  }) {
    return AssignPlanState(
      isLoading: isLoading ?? this.isLoading,
      isAssigning: isAssigning ?? this.isAssigning,
      subscriptionPlans: subscriptionPlans ?? this.subscriptionPlans,
      activePlans: activePlans ?? this.activePlans,
      selectedPlanType: selectedPlanType ?? this.selectedPlanType,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      allowedHotels: allowedHotels ?? this.allowedHotels,
      duration: duration ?? this.duration,
      redeemStartAt: redeemStartAt ?? this.redeemStartAt,
      redeemEndAt: redeemEndAt ?? this.redeemEndAt,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  bool get canAssign =>
      selectedPlanType != null &&
      redeemStartAt != null &&
      redeemEndAt != null &&
      selectedPlan != null &&
      allowedHotels > 0 &&
      duration > 0 &&
      !isAssigning;

  @override
  List<Object?> get props => [
    isLoading,
    isAssigning,
    subscriptionPlans,
    activePlans,
    selectedPlanType,
    selectedPlan,
    allowedHotels,
    duration,
    redeemStartAt,
    redeemEndAt,
    errorMessage,
    successMessage,
  ];
}
