import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';
import 'package:taskoteladmin/features/subscription/domain/repo/subscription_repo.dart';

part 'susbcription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepo subscriptionRepo;
  StreamSubscription<List<SubscriptionPlanModel>>? _subscriptionStream;

  SubscriptionCubit({required this.subscriptionRepo})
    : super(SubscriptionState.initial());

  @override
  Future<void> close() {
    _subscriptionStream?.cancel();
    return super.close();
  }

  // Load subscription plans stream
  Future<void> loadSubscriptionPlans() async {
    emit(state.copyWith(isLoading: true));
    _subscriptionStream?.cancel();

    try {
      _subscriptionStream = subscriptionRepo
          .getSubscriptionPlansStream()
          .listen(
            (plans) {
              emit(
                state.copyWith(
                  subscriptionPlans: plans,
                  filteredPlans: _applyFilters(plans),
                  isLoading: false,
                ),
              );
            },
            onError: (error) {
              emit(
                state.copyWith(
                  isLoading: false,
                  message: 'Failed to load subscription plans: $error',
                ),
              );
            },
          );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          message: 'Failed to load subscription plans: $e',
        ),
      );
    }
  }

  // Create subscription plan
  Future<void> createSubscriptionPlan(SubscriptionPlanModel plan) async {
    try {
      emit(state.copyWith(isLoading: true));
      await subscriptionRepo.createSubscriptionPlan(plan);
      emit(
        state.copyWith(
          isLoading: false,
          message: 'Subscription plan created successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          message: 'Failed to create subscription plan: $e',
        ),
      );
    }
  }

  // Update subscription plan
  Future<void> updateSubscriptionPlan(SubscriptionPlanModel plan) async {
    try {
      emit(state.copyWith(isLoading: true));
      await subscriptionRepo.updateSubscriptionPlan(plan);
      emit(
        state.copyWith(
          isLoading: false,
          message: 'Subscription plan updated successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          message: 'Failed to update subscription plan: $e',
        ),
      );
    }
  }

  // Delete subscription plan
  Future<void> deleteSubscriptionPlan(String planId) async {
    try {
      emit(state.copyWith(isLoading: true));
      await subscriptionRepo.deleteSubscriptionPlan(planId);
      emit(
        state.copyWith(
          isLoading: false,
          message: 'Subscription plan deleted successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          message: 'Failed to delete subscription plan: $e',
        ),
      );
    }
  }

  // Load analytics
  Future<void> loadAnalytics() async {
    try {
      final analytics = await subscriptionRepo.getSubscriptionAnalytics();
      emit(state.copyWith(analytics: analytics));
    } catch (e) {
      emit(state.copyWith(message: 'Failed to load analytics: $e'));
    }
  }

  // Search plans
  void searchPlans(String query) {
    emit(state.copyWith(searchQuery: query));
    final filteredPlans = _applyFilters(state.subscriptionPlans);
    emit(state.copyWith(filteredPlans: filteredPlans));
  }

  // Filter by status
  void filterByStatus(bool? isActive) {
    emit(state.copyWith(statusFilter: isActive));
    final filteredPlans = _applyFilters(state.subscriptionPlans);
    emit(state.copyWith(filteredPlans: filteredPlans));
  }

  // Clear message
  void clearMessage() {
    emit(state.copyWith(message: null));
  }

  // Apply filters helper method
  List<SubscriptionPlanModel> _applyFilters(List<SubscriptionPlanModel> plans) {
    var filtered = plans;

    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (plan) =>
                plan.title.toLowerCase().contains(
                  state.searchQuery.toLowerCase(),
                ) ||
                plan.desc.toLowerCase().contains(
                  state.searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    // Apply status filter
    if (state.statusFilter != null) {
      filtered = filtered
          .where((plan) => plan.isActive == state.statusFilter)
          .toList();
    }

    return filtered;
  }
}
