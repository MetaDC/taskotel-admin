import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';

class SubscriptionPurchaseModel {
  final String docId;
  final String hotelId;
  final String hotelName;
  final String email;
  final String membershipId;
  final String membershipName;
  final double amount;
  final String status; // success, failed, refunded
  final String paymentMethod; // card, UPI, etc.
  final bool isPaid;
  final DateTime? paidAt;
  final DateTime createdAt;
  final DateTime expiredAt;
  final String transactionId;
  final SubscriptionPlanModel subscriptionModel;

  SubscriptionPurchaseModel({
    required this.docId,
    required this.hotelId,
    required this.hotelName,
    required this.email,
    required this.membershipId,
    required this.membershipName,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.isPaid,
    required this.paidAt,
    required this.createdAt,
    required this.expiredAt,
    required this.transactionId,
    required this.subscriptionModel,
  });

  /// fromSnap (DocumentSnapshot)
  factory SubscriptionPurchaseModel.fromSnap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubscriptionPurchaseModel(
      docId: doc.id,
      hotelId: data['hotelId'] ?? '',
      hotelName: data['hotelName'] ?? '',
      email: data['email'] ?? '',
      membershipId: data['membershipId'] ?? '',
      membershipName: data['membershipName'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      paymentMethod: data['paymentMethod'] ?? '',
      isPaid: data['isPaid'] ?? false,
      paidAt: data['paidAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['paidAt'])
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
      expiredAt: DateTime.fromMillisecondsSinceEpoch(data['expiredAt']),
      transactionId: data['transactionId'] ?? '',
      subscriptionModel: SubscriptionPlanModel.fromJson(
        (data['subscriptionModel']),
        'Need to change',
      ),
    );
  }

  /// fromDocSnap (QueryDocumentSnapshot)
  factory SubscriptionPurchaseModel.fromDocSnap(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return SubscriptionPurchaseModel(
      docId: doc.id,
      hotelId: data['hotelId'] ?? '',
      hotelName: data['hotelName'] ?? '',
      email: data['email'] ?? '',
      membershipId: data['membershipId'] ?? '',
      membershipName: data['membershipName'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      paymentMethod: data['paymentMethod'] ?? '',
      isPaid: data['isPaid'] ?? false,
      paidAt: data['paidAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['paidAt'])
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
      expiredAt: DateTime.fromMillisecondsSinceEpoch(data['expiredAt']),
      transactionId: data['transactionId'] ?? '',
      subscriptionModel: SubscriptionPlanModel.fromJson(
        (data['subscriptionModel']),
        "Need to change",
      ),
    );
  }

  /// toMap
  Map<String, dynamic> toMap() {
    return {
      'hotelId': hotelId,
      'hotelName': hotelName,
      'email': email,
      'membershipId': membershipId,
      'membershipName': membershipName,
      'amount': amount,
      'status': status,
      'paymentMethod': paymentMethod,
      'isPaid': isPaid,
      'paidAt': paidAt?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'expiredAt': expiredAt.millisecondsSinceEpoch,
      'transactionId': transactionId,
      'subscriptionModel': subscriptionModel.toMap(),
    };
  }

  /// copyWith
  SubscriptionPurchaseModel copyWith({
    String? docId,
    String? hotelId,
    String? hotelName,
    String? email,
    String? membershipId,
    String? membershipName,
    double? amount,
    String? status,
    String? paymentMethod,
    bool? isPaid,
    DateTime? paidAt,
    DateTime? createdAt,
    DateTime? expiredAt,
    String? transactionId,
    SubscriptionPlanModel? subscriptionModel,
  }) {
    return SubscriptionPurchaseModel(
      docId: docId ?? this.docId,
      hotelId: hotelId ?? this.hotelId,
      hotelName: hotelName ?? this.hotelName,
      email: email ?? this.email,
      membershipId: membershipId ?? this.membershipId,
      membershipName: membershipName ?? this.membershipName,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPaid: isPaid ?? this.isPaid,
      paidAt: paidAt ?? this.paidAt,
      createdAt: createdAt ?? this.createdAt,
      expiredAt: expiredAt ?? this.expiredAt,
      transactionId: transactionId ?? this.transactionId,
      subscriptionModel: subscriptionModel ?? this.subscriptionModel,
    );
  }
}
