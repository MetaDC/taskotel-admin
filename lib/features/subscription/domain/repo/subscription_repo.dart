import 'package:taskoteladmin/features/subscription/domain/model/client_plan_model.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_purchase_model.dart';

abstract class SubscriptionRepo {
  // Stream methods
  Stream<List<SubscriptionPlanModel>> getSubscriptionPlansStream();

  // CRUD operations
  Future<void> createSubscriptionPlan(SubscriptionPlanModel plan);
  Future<void> updateSubscriptionPlan(SubscriptionPlanModel plan);
  Future<void> deleteSubscriptionPlan(String planId);

  // Subscription Purchase operations
  Future<String> createSubscriptionPurchase(SubscriptionPurchaseModel purchase);
  Future<void> updateSubscriptionPurchase(SubscriptionPurchaseModel purchase);
  Future<List<SubscriptionPurchaseModel>> getHotelSubscriptionPurchases(
    String hotelId,
  );

  // Hotel subscription assignment
  Future<String> assignSubscriptionToHotel({
    required String hotelId,
    required String hotelName,
    required String clientId,
    required String email,
    required SubscriptionPlanModel subscriptionPlan,
    required String billingCycle, // 'monthly' or 'yearly'
    required String paymentMethod,
  });

  // Client subscription assignment
  Future<void> assignSubscriptionToClient(ClientPlanModel clientPlan);

  // Analytics
  // Future<Map<String, dynamic>> getSubscriptionAnalytics();

  // Search and filter
  Future<List<SubscriptionPlanModel>> searchPlans(String query);
  Future<List<SubscriptionPlanModel>> filterByStatus(bool isActive);
}
