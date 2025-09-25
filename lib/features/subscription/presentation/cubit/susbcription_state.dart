part of 'susbcription_cubit.dart';

class SubscriptionState extends Equatable {
  final bool isLoading;
  final List<SubscriptionPlanModel> subscriptionPlans;
  final List<SubscriptionPlanModel> filteredPlans;
  final Map<String, dynamic>? analytics;
  final String? message;
  final String searchQuery;
  final bool? statusFilter; // null = all, true = active, false = inactive

  const SubscriptionState({
    required this.isLoading,
    required this.subscriptionPlans,
    required this.filteredPlans,
    this.analytics,
    this.message,
    required this.searchQuery,
    this.statusFilter,
  });

  factory SubscriptionState.initial() {
    return const SubscriptionState(
      isLoading: false,
      subscriptionPlans: [],
      filteredPlans: [],
      analytics: null,
      message: null,
      searchQuery: '',
      statusFilter: null,
    );
  }

  SubscriptionState copyWith({
    bool? isLoading,
    List<SubscriptionPlanModel>? subscriptionPlans,
    List<SubscriptionPlanModel>? filteredPlans,
    Map<String, dynamic>? analytics,
    String? message,
    String? searchQuery,
    bool? statusFilter,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      subscriptionPlans: subscriptionPlans ?? this.subscriptionPlans,
      filteredPlans: filteredPlans ?? this.filteredPlans,
      analytics: analytics ?? this.analytics,
      message: message ?? this.message,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    subscriptionPlans,
    filteredPlans,
    analytics,
    message,
    searchQuery,
    statusFilter,
  ];
}
