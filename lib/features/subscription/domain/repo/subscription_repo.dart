import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';

abstract class SubscriptionRepo {
  // Stream methods
  Stream<List<SubscriptionPlanModel>> getSubscriptionPlansStream();

  // CRUD operations
  Future<void> createSubscriptionPlan(SubscriptionPlanModel plan);
  Future<void> updateSubscriptionPlan(SubscriptionPlanModel plan);
  Future<void> deleteSubscriptionPlan(String planId);

  // Analytics
  // Future<Map<String, dynamic>> getSubscriptionAnalytics();

  // Search and filter
  Future<List<SubscriptionPlanModel>> searchPlans(String query);
  Future<List<SubscriptionPlanModel>> filterByStatus(bool isActive);
}
