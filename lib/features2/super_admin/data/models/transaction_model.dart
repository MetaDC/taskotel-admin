import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/features2/super_admin/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.clientId,
    required super.clientName,
    required super.email,
    super.hotelId,
    super.hotelName,
    required super.purchaseModelId,
    required super.planName,
    required super.amount,
    required super.status,
    required super.paymentMethod,
    required super.isPaid,
    super.paidAt,
    required super.createdAt,
    required super.transactionId,
    super.failureReason,
    super.refundId,
    super.refundAmount,
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      clientId: data['clientId'] ?? '',
      clientName: data['clientName'] ?? '',
      email: data['email'] ?? '',
      hotelId: data['hotelId'],
      hotelName: data['hotelName'],
      purchaseModelId: data['purchaseModelId'] ?? '',
      planName: data['planName'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      status: TransactionStatusExtension.fromString(data['status'] ?? 'pending'),
      paymentMethod: PaymentMethodExtension.fromString(
          data['paymentMethod'] ?? 'credit_card'),
      isPaid: data['isPaid'] ?? false,
      paidAt: data['paidAt'] != null
          ? (data['paidAt'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      transactionId: data['transactionId'] ?? '',
      failureReason: data['failureReason'],
      refundId: data['refundId'],
      refundAmount: data['refundAmount']?.toDouble(),
    );
  }

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      clientId: entity.clientId,
      clientName: entity.clientName,
      email: entity.email,
      hotelId: entity.hotelId,
      hotelName: entity.hotelName,
      purchaseModelId: entity.purchaseModelId,
      planName: entity.planName,
      amount: entity.amount,
      status: entity.status,
      paymentMethod: entity.paymentMethod,
      isPaid: entity.isPaid,
      paidAt: entity.paidAt,
      createdAt: entity.createdAt,
      transactionId: entity.transactionId,
      failureReason: entity.failureReason,
      refundId: entity.refundId,
      refundAmount: entity.refundAmount,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'clientId': clientId,
      'clientName': clientName,
      'email': email,
      'hotelId': hotelId,
      'hotelName': hotelName,
      'purchaseModelId': purchaseModelId,
      'planName': planName,
      'amount': amount,
      'status': status.value,
      'paymentMethod': paymentMethod.value,
      'isPaid': isPaid,
      'paidAt': paidAt != null ? Timestamp.fromDate(paidAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'transactionId': transactionId,
      'failureReason': failureReason,
      'refundId': refundId,
      'refundAmount': refundAmount,
    };
  }

  TransactionModel copyWith({
    String? id,
    String? clientId,
    String? clientName,
    String? email,
    String? hotelId,
    String? hotelName,
    String? purchaseModelId,
    String? planName,
    double? amount,
    TransactionStatus? status,
    PaymentMethod? paymentMethod,
    bool? isPaid,
    DateTime? paidAt,
    DateTime? createdAt,
    String? transactionId,
    String? failureReason,
    String? refundId,
    double? refundAmount,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      email: email ?? this.email,
      hotelId: hotelId ?? this.hotelId,
      hotelName: hotelName ?? this.hotelName,
      purchaseModelId: purchaseModelId ?? this.purchaseModelId,
      planName: planName ?? this.planName,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPaid: isPaid ?? this.isPaid,
      paidAt: paidAt ?? this.paidAt,
      createdAt: createdAt ?? this.createdAt,
      transactionId: transactionId ?? this.transactionId,
      failureReason: failureReason ?? this.failureReason,
      refundId: refundId ?? this.refundId,
      refundAmount: refundAmount ?? this.refundAmount,
    );
  }
}
