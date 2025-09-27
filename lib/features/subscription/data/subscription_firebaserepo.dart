import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';
import 'package:taskoteladmin/features/subscription/domain/repo/subscription_repo.dart';

class SubscriptionFirebaserepo extends SubscriptionRepo {
  final subscriptionCollectionRef = FBFireStore.subscriptions;

  @override
  Stream<List<SubscriptionPlanModel>> getSubscriptionPlansStream() {
    return subscriptionCollectionRef.snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => SubscriptionPlanModel.fromDocSnap(doc))
          .toList();
    });
  }

  @override
  Future<void> createSubscriptionPlan(SubscriptionPlanModel plan) async {
    final planData = plan.toJson();

    await subscriptionCollectionRef.add(planData);
  }

  @override
  Future<void> updateSubscriptionPlan(SubscriptionPlanModel plan) async {
    final planData = plan.toJson();

    await subscriptionCollectionRef.doc(plan.docId).update(planData);
  }

  @override
  Future<void> deleteSubscriptionPlan(String planId) async {
    print("deleting plan:-${planId}");
    await subscriptionCollectionRef.doc(planId).delete();
  }

  @override
  Future<Map<String, dynamic>> getSubscriptionAnalytics() async {
    try {
      final querySnapshot = await subscriptionCollectionRef.get();
      final plans = querySnapshot.docs
          .map((doc) => SubscriptionPlanModel.fromDocSnap(doc))
          .toList();

      int totalPlans = plans.length;
      int activePlans = plans.where((plan) => plan.isActive).length;
      int totalSubscribers = plans.fold(
        0,
        (total, plan) => total + plan.totalSubScribers,
      );
      double totalRevenue = plans.fold(
        0.0,
        (total, plan) => total + plan.totalRevenue,
      );

      // Find most popular plan
      String mostPopular = 'N/A';
      if (plans.isNotEmpty) {
        final popularPlan = plans.reduce(
          (a, b) => a.totalSubScribers > b.totalSubScribers ? a : b,
        );
        mostPopular = popularPlan.title;
      }

      return {
        'totalPlans': totalPlans,
        'activePlans': activePlans,
        'totalSubscribers': totalSubscribers,
        'totalRevenue': totalRevenue,
        'mostPopular': mostPopular,
        'plans': plans,
      };
    } catch (e) {
      throw Exception('Failed to get analytics: $e');
    }
  }

  @override
  Future<List<SubscriptionPlanModel>> searchPlans(String query) async {
    try {
      final querySnapshot = await subscriptionCollectionRef.get();
      final plans = querySnapshot.docs
          .map((doc) => SubscriptionPlanModel.fromDocSnap(doc))
          .toList();

      return plans
          .where(
            (plan) =>
                plan.title.toLowerCase().contains(query.toLowerCase()) ||
                plan.desc.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to search plans: $e');
    }
  }

  @override
  Future<List<SubscriptionPlanModel>> filterByStatus(bool isActive) async {
    try {
      final querySnapshot = await subscriptionCollectionRef
          .where('isActive', isEqualTo: isActive)
          .get();

      return querySnapshot.docs
          .map((doc) => SubscriptionPlanModel.fromDocSnap(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to filter plans: $e');
    }
  }
}
