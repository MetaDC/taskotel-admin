import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';

class TransactionModel {
  final String docId;
  final String clientId;
  final String hotelId;
  final String clientName;
  final String hotelName;
  final String email;
  final String purchaseModelId;
  final String planName;
  final double amount;
  final String status; // success, failed, refunded
  final String paymentMethod; // card, UPI, etc.
  final bool isPaid;
  final DateTime? paidAt;
  final DateTime createdAt;
  final String transactionId;
  final SubscriptionPlanModel subscriptionModel;

  TransactionModel({
    required this.docId,
    required this.clientId,
    required this.hotelId,
    required this.clientName,
    required this.hotelName,
    required this.email,
    required this.purchaseModelId,
    required this.planName,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.isPaid,
    required this.paidAt,
    required this.createdAt,
    required this.transactionId,
    required this.subscriptionModel,
  });

  /// fromSnap (DocumentSnapshot)
  factory TransactionModel.fromSnap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      docId: doc.id,
      clientId: data['clientId'] ?? '',
      hotelId: data['hotelId'] ?? '',
      clientName: data['clientName'] ?? '',
      hotelName: data['hotelName'] ?? '',
      email: data['email'] ?? '',
      purchaseModelId: data['purchaseModelId'] ?? '',
      planName: data['planName'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      paymentMethod: data['paymentMethod'] ?? '',
      isPaid: data['isPaid'] ?? false,
      paidAt: data['paidAt'] != null
          ? (data['paidAt'] is Timestamp
                ? (data['paidAt'] as Timestamp).toDate()
                : DateTime.fromMillisecondsSinceEpoch(data['paidAt']))
          : null,
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
      transactionId: data['transactionId'] ?? '',
      subscriptionModel: SubscriptionPlanModel.fromJson(
        (data['subscriptionModel']) as Map<String, dynamic>,
        doc.id,
      ),
    );
  }

  /// fromDocSnap (QueryDocumentSnapshot)
  factory TransactionModel.fromDocSnap(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return TransactionModel(
      docId: doc.id,
      clientId: data['clientId'] ?? '',
      hotelId: data['hotelId'] ?? '',
      clientName: data['clientName'] ?? '',
      hotelName: data['hotelName'] ?? '',
      email: data['email'] ?? '',
      purchaseModelId: data['purchaseModelId'] ?? '',
      planName: data['planName'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      paymentMethod: data['paymentMethod'] ?? '',
      isPaid: data['isPaid'] ?? false,
      paidAt: data['paidAt'] != null
          ? (data['paidAt'] is Timestamp
                ? (data['paidAt'] as Timestamp).toDate()
                : DateTime.fromMillisecondsSinceEpoch(data['paidAt']))
          : null,
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
      transactionId: data['transactionId'] ?? '',
      subscriptionModel: SubscriptionPlanModel.fromJson(
        (data['subscriptionModel']) as Map<String, dynamic>,
        doc.id,
      ),
    );
  }

  /// toMap
  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'hotelId': hotelId,
      'clientName': clientName,
      'hotelName': hotelName,
      'email': email,
      'purchaseModelId': purchaseModelId,
      'planName': planName,
      'amount': amount,
      'status': status,
      'paymentMethod': paymentMethod,
      'isPaid': isPaid,
      'paidAt': paidAt?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'transactionId': transactionId,
      'subscriptionModel': subscriptionModel.toMap(),
    };
  }

  /// copyWith
  TransactionModel copyWith({
    String? docId,
    String? clientId,
    String? hotelId,
    String? clientName,
    String? hotelName,
    String? email,
    String? purchaseModelId,
    String? planName,
    double? amount,
    String? status,
    String? paymentMethod,
    bool? isPaid,
    DateTime? paidAt,
    DateTime? createdAt,
    String? transactionId,
    SubscriptionPlanModel? subscriptionModel,
  }) {
    return TransactionModel(
      docId: docId ?? this.docId,
      clientId: clientId ?? this.clientId,
      hotelName: hotelName ?? this.hotelName,
      hotelId: hotelId ?? this.hotelId,
      clientName: clientName ?? this.clientName,
      email: email ?? this.email,
      purchaseModelId: purchaseModelId ?? this.purchaseModelId,
      planName: planName ?? this.planName,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPaid: isPaid ?? this.isPaid,
      paidAt: paidAt ?? this.paidAt,
      createdAt: createdAt ?? this.createdAt,
      transactionId: transactionId ?? this.transactionId,
      subscriptionModel: subscriptionModel ?? this.subscriptionModel,
    );
  }
}
