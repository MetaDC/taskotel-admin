import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';

import 'package:taskoteladmin/features/transactions/domain/entity/transactions_model.dart';

Future<void> seedDummyTransactions() async {
  final firestore = FirebaseFirestore.instance;
  final collectionRef = firestore.collection('transactions');
  final batch = firestore.batch();

  final random = Random();
  final statuses = ["success", "failed", "refunded"];
  final methods = ["Card", "UPI", "NetBanking"];

  DateTime randomDate(int daysAgo) {
    final now = DateTime.now();
    return now.subtract(Duration(days: daysAgo));
  }

  for (int i = 1; i <= 30; i++) {
    // Decide when this transaction happened
    int daysAgo;
    if (i <= 10) {
      daysAgo = 0; // today
    } else if (i <= 20) {
      daysAgo = random.nextInt(7); // last week
    } else if (i <= 25) {
      daysAgo = 15 + random.nextInt(10); // last month
    } else {
      daysAgo = 90 + random.nextInt(20); // 3–4 months ago
    }

    final createdAt = randomDate(daysAgo);
    final status = statuses[random.nextInt(statuses.length)];
    final paymentMethod = methods[random.nextInt(methods.length)];
    final isPaid = status == "success";

    final subscriptionPlan = SubscriptionPlanModel(
      docId: "sub_${i}",
      title: i % 2 == 0 ? "Premium Plan" : "Basic Plan",
      desc: i % 2 == 0 ? "Premium access" : "Basic access",
      minRooms: i % 2 == 0 ? 10 : 1,
      maxRooms: i % 2 == 0 ? 100 : 20,
      price: {
        "monthly": i % 2 == 0 ? 499.99 : 199.99,
        "yearly": i % 2 == 0 ? 4999.99 : 1999.99,
      },
      features: i % 2 == 0 ? ["Feature A", "Feature B"] : ["Feature X"],
      isActive: true,
      totalSubScribers: 100,
      totalRevenue: 50000,
      forGeneral: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final transaction = TransactionModel(
      docId: "", // Firestore will generate
      clientId: "client_$i",
      hotelId: "hotel_$i",
      clientName: "Client $i",
      hotelName: "Hotel $i",
      email: "client$i@example.com",
      purchaseModelId: "purchase_$i",
      planName: subscriptionPlan.title,
      amount: subscriptionPlan.price['monthly']!,
      status: status,
      paymentMethod: paymentMethod,
      isPaid: isPaid,
      paidAt: isPaid ? createdAt : null,
      createdAt: createdAt,
      transactionId: "TXN${1000 + i}",
      subscriptionModel: subscriptionPlan,
    );

    final docRef = collectionRef.doc();
    batch.set(docRef, transaction.toMap());
  }

  await batch.commit();
  print("✅ 30 dummy transactions added to Firestore!");
}
