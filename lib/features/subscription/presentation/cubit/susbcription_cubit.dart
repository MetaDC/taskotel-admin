import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';
import 'package:taskoteladmin/features/subscription/domain/repo/subscription_repo.dart';

part 'susbcription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepo subscriptionRepo;
  StreamSubscription<List<SubscriptionPlanModel>>? _subscriptionStream;
  Timer? _messageClearTimer;

  SubscriptionCubit({required this.subscriptionRepo})
    : super(SubscriptionState.initial());

  @override
  Future<void> close() {
    _subscriptionStream?.cancel();
    _messageClearTimer?.cancel();
    return super.close();
  }

  // Load subscription plans stream
  Future<void> loadSubscriptionPlans() async {
    emit(state.copyWith(isLoading: true, message: ""));
    _subscriptionStream?.cancel();

    try {
      _subscriptionStream = subscriptionRepo
          .getSubscriptionPlansStream()
          .listen(
            (plans) {
              plans.sort(
                (a, b) =>
                    a.price['monthly']?.compareTo(b.price['monthly'] ?? 0) ?? 0,
              );
              emit(
                state.copyWith(
                  subscriptionPlans: plans,
                  filteredPlans: _applyFilters(plans),
                  isLoading: false,
                ),
              );
              // Auto-calculate analytics whenever plans update
              _calculateAnalytics();
            },
            onError: (error) {
              _emitWithMessage(
                state.copyWith(isLoading: false),
                'Failed to load subscription plans: $error',
              );
            },
          );
    } catch (e) {
      _emitWithMessage(
        state.copyWith(isLoading: false),
        'Failed to load subscription plans: $e',
      );
    }
  }

  // Create subscription plan
  Future<void> createSubscriptionPlan(SubscriptionPlanModel plan) async {
    try {
      emit(state.copyWith(isLoading: true, message: null));
      await subscriptionRepo.createSubscriptionPlan(plan);
      _emitWithMessage(
        state.copyWith(isLoading: false),
        'Subscription plan created successfully',
      );
    } catch (e) {
      _emitWithMessage(
        state.copyWith(isLoading: false),
        'Failed to create subscription plan: $e',
      );
    }
  }

  // Update subscription plan
  Future<void> updateSubscriptionPlan(SubscriptionPlanModel plan) async {
    try {
      emit(state.copyWith(isLoading: true, message: null));
      await subscriptionRepo.updateSubscriptionPlan(plan);
      _emitWithMessage(
        state.copyWith(isLoading: false),
        'Subscription plan updated successfully',
      );
    } catch (e) {
      _emitWithMessage(
        state.copyWith(isLoading: false),
        'Failed to update subscription plan: $e',
      );
    }
  }

  // Delete subscription plan
  Future<void> deleteSubscriptionPlan(String planId) async {
    try {
      emit(state.copyWith(isLoading: true, message: null));
      await subscriptionRepo.deleteSubscriptionPlan(planId);
      _emitWithMessage(
        state.copyWith(isLoading: false),
        'Subscription plan deleted successfully',
      );
    } catch (e) {
      _emitWithMessage(
        state.copyWith(isLoading: false),
        'Failed to delete subscription plan: $e',
      );
    }
  }

  // Load analytics (now calls _calculateAnalytics)
  Future<void> loadAnalytics() async {
    try {
      _calculateAnalytics();
    } catch (e) {
      _emitWithMessage(state, 'Failed to load analytics: $e');
    }
  }

  // Calculate analytics from subscription plans
  void _calculateAnalytics() {
    final plans = state.subscriptionPlans;

    if (plans.isEmpty) {
      emit(
        state.copyWith(
          analytics: {
            'totalPlans': 0,
            'totalSubscribers': 0,
            'totalRevenue': 0.0,
            'mostPopular': 'N/A',
          },
        ),
      );
      return;
    }

    // Total Plans
    final totalPlans = plans.length;

    // Total Active Subscribers (sum of all subscribers across all plans)
    final totalSubscribers = plans.fold<int>(
      0,
      (sum, plan) => sum + plan.totalSubScribers,
    );

    // Total Monthly Revenue (sum of all revenue)
    final totalRevenue = plans.fold<double>(
      0.0,
      (sum, plan) => sum + plan.totalRevenue,
    );

    // Most Popular Plan (plan with highest subscriber count)
    String mostPopular = 'N/A';
    if (plans.isNotEmpty) {
      final popularPlan = plans.reduce(
        (current, next) =>
            next.totalSubScribers > current.totalSubScribers ? next : current,
      );
      mostPopular = popularPlan.title;
    }

    // Emit updated analytics
    emit(
      state.copyWith(
        analytics: {
          'totalPlans': totalPlans,
          'totalSubscribers': totalSubscribers,
          'totalRevenue': totalRevenue,
          'mostPopular': mostPopular,
        },
      ),
    );
  }

  // Search plans
  void searchPlans(String query) {
    emit(state.copyWith(searchQuery: query, message: null));
    final filteredPlans = _applyFilters(state.subscriptionPlans);
    emit(state.copyWith(filteredPlans: filteredPlans));
  }

  // Filter by status
  void filterByStatus(bool? isActive) {
    emit(state.copyWith(statusFilter: isActive, message: null));
    final filteredPlans = _applyFilters(state.subscriptionPlans);
    emit(state.copyWith(filteredPlans: filteredPlans));
  }

  // Clear message immediately
  void clearMessage() {
    if (state.message != null) {
      emit(state.copyWith(message: null));
    }
    _messageClearTimer?.cancel();
  }

  // Private helper method to emit with auto-clearing message
  void _emitWithMessage(SubscriptionState newState, String message) {
    // Cancel any existing timer
    _messageClearTimer?.cancel();

    // Emit state with message
    emit(newState.copyWith(message: message));

    // Set timer to clear message after 100ms to prevent multiple shows
    _messageClearTimer = Timer(const Duration(milliseconds: 100), () {
      if (state.message == message) {
        emit(state.copyWith(message: null));
      }
    });
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
