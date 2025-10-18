import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_purchase_model.dart';
import 'package:taskoteladmin/features/subscription/domain/repo/subscription_repo.dart';
import 'package:taskoteladmin/features/transactions/domain/entity/transactions_model.dart';

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
    await subscriptionCollectionRef.doc(planId).delete();
  }

  // @override
  // Future<Map<String, dynamic>> getSubscriptionAnalytics() async {
  //   try {
  //     final querySnapshot = await subscriptionCollectionRef.get();
  //     final plans = querySnapshot.docs
  //         .map((doc) => SubscriptionPlanModel.fromDocSnap(doc))
  //         .toList();

  //     int totalPlans = plans.length;
  //     int activePlans = plans.where((plan) => plan.isActive).length;
  //     int totalSubscribers = plans.fold(
  //       0,
  //       (total, plan) => total + plan.totalSubScribers,
  //     );
  //     double totalRevenue = plans.fold(
  //       0.0,
  //       (total, plan) => total + plan.totalRevenue,
  //     );

  //     // Find most popular plan
  //     String mostPopular = 'N/A';
  //     if (plans.isNotEmpty) {
  //       final popularPlan = plans.reduce(
  //         (a, b) => a.totalSubScribers > b.totalSubScribers ? a : b,
  //       );
  //       mostPopular = popularPlan.title;
  //     }

  //     return {
  //       'totalPlans': totalPlans,
  //       'activePlans': activePlans,
  //       'totalSubscribers': totalSubscribers,
  //       'totalRevenue': totalRevenue,
  //       'mostPopular': mostPopular,
  //       'plans': plans,
  //     };
  //   } catch (e) {
  //     throw Exception('Failed to get analytics: $e');
  //   }
  // }

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

  // Subscription Purchase operations
  @override
  Future<String> createSubscriptionPurchase(
    SubscriptionPurchaseModel purchase,
  ) async {
    try {
      final purchaseData = purchase.toMap();
      final docRef = await FBFireStore.subscriptionPurchases.add(purchaseData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create subscription purchase: $e');
    }
  }

  @override
  Future<void> updateSubscriptionPurchase(
    SubscriptionPurchaseModel purchase,
  ) async {
    try {
      final purchaseData = purchase.toMap();
      await FBFireStore.subscriptionPurchases
          .doc(purchase.docId)
          .update(purchaseData);
    } catch (e) {
      throw Exception('Failed to update subscription purchase: $e');
    }
  }

  @override
  Future<List<SubscriptionPurchaseModel>> getHotelSubscriptionPurchases(
    String hotelId,
  ) async {
    try {
      final querySnapshot = await FBFireStore.subscriptionPurchases
          .where('hotelId', isEqualTo: hotelId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => SubscriptionPurchaseModel.fromDocSnap(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get hotel subscription purchases: $e');
    }
  }

  @override
  Future<String> assignSubscriptionToHotel({
    required String hotelId,
    required String hotelName,
    required String clientId,
    required String email,
    required SubscriptionPlanModel subscriptionPlan,
    required String billingCycle,
    required String paymentMethod,
  }) async {
    try {
      final now = DateTime.now();
      final amount = subscriptionPlan.price[billingCycle] ?? 0.0;

      // Calculate expiry date based on billing cycle
      final expiryDate = billingCycle == 'yearly'
          ? now.add(const Duration(days: 365))
          : now.add(const Duration(days: 30));

      // Generate unique transaction ID
      final transactionId =
          'txn_${now.millisecondsSinceEpoch}_${hotelId.substring(0, 8)}';

      // Create subscription purchase
      final subscriptionPurchase = SubscriptionPurchaseModel(
        docId: '',
        hotelId: hotelId,
        hotelName: hotelName,
        email: email,
        membershipId: subscriptionPlan.docId,
        membershipName: subscriptionPlan.title,
        amount: amount,
        status: 'success', // Auto-assign as successful
        paymentMethod: paymentMethod,
        isPaid: true,
        paidAt: now,
        createdAt: now,
        expiredAt: expiryDate,
        transactionId: transactionId,
        subscriptionModel: subscriptionPlan,
      );

      // Create subscription purchase record
      final purchaseId = await createSubscriptionPurchase(subscriptionPurchase);

      // // Create transaction record
      // final transaction = TransactionModel(
      //   docId: '',
      //   clientId: clientId,
      //   hotelId: hotelId,
      //   clientName: '', // Will be filled by the calling function
      //   hotelName: hotelName,
      //   email: email,
      //   purchaseModelId: purchaseId,
      //   planName: subscriptionPlan.title,
      //   amount: amount,
      //   status: 'success',
      //   paymentMethod: paymentMethod,
      //   isPaid: true,
      //   paidAt: now,
      //   createdAt: now,
      //   transactionId: transactionId,
      //   subscriptionModel: subscriptionPlan,
      // );

      // // Add transaction to Firestore
      // await FBFireStore.transactions.add(transaction.toMap());

      // Update hotel with subscription details
      await FBFireStore.hotels.doc(hotelId).update({
        'subscriptionPurchaseId': purchaseId,
        'subscriptionName': subscriptionPlan.title,
        'subscriptionStart': now.millisecondsSinceEpoch,
        'subscriptionEnd': expiryDate.millisecondsSinceEpoch,
        'updatedAt': now.millisecondsSinceEpoch,
      });

      return purchaseId;
    } catch (e) {
      throw Exception('Failed to assign subscription to hotel: $e');
    }
  }
}
