import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String id;
  final String clientId;
  final String clientName;
  final String email;
  final String? hotelId;
  final String? hotelName;
  final String purchaseModelId;
  final String planName;
  final double amount;
  final TransactionStatus status;
  final PaymentMethod paymentMethod;
  final bool isPaid;
  final DateTime? paidAt;
  final DateTime createdAt;
  final String transactionId;
  final String? failureReason;
  final String? refundId;
  final double? refundAmount;

  const TransactionEntity({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.email,
    this.hotelId,
    this.hotelName,
    required this.purchaseModelId,
    required this.planName,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.isPaid,
    this.paidAt,
    required this.createdAt,
    required this.transactionId,
    this.failureReason,
    this.refundId,
    this.refundAmount,
  });

  @override
  List<Object?> get props => [
        id,
        clientId,
        clientName,
        email,
        hotelId,
        hotelName,
        purchaseModelId,
        planName,
        amount,
        status,
        paymentMethod,
        isPaid,
        paidAt,
        createdAt,
        transactionId,
        failureReason,
        refundId,
        refundAmount,
      ];

  TransactionEntity copyWith({
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
    return TransactionEntity(
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

enum TransactionStatus {
  pending,
  completed,
  failed,
  refunded,
  cancelled,
}

extension TransactionStatusExtension on TransactionStatus {
  String get displayName {
    switch (this) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.refunded:
        return 'Refunded';
      case TransactionStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get value {
    switch (this) {
      case TransactionStatus.pending:
        return 'pending';
      case TransactionStatus.completed:
        return 'completed';
      case TransactionStatus.failed:
        return 'failed';
      case TransactionStatus.refunded:
        return 'refunded';
      case TransactionStatus.cancelled:
        return 'cancelled';
    }
  }

  static TransactionStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return TransactionStatus.pending;
      case 'completed':
        return TransactionStatus.completed;
      case 'failed':
        return TransactionStatus.failed;
      case 'refunded':
        return TransactionStatus.refunded;
      case 'cancelled':
        return TransactionStatus.cancelled;
      default:
        return TransactionStatus.pending;
    }
  }
}

enum PaymentMethod {
  creditCard,
  debitCard,
  paypal,
  bankTransfer,
  upi,
  wallet,
}

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.paypal:
        return 'PayPal';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.wallet:
        return 'Wallet';
    }
  }

  String get value {
    switch (this) {
      case PaymentMethod.creditCard:
        return 'credit_card';
      case PaymentMethod.debitCard:
        return 'debit_card';
      case PaymentMethod.paypal:
        return 'paypal';
      case PaymentMethod.bankTransfer:
        return 'bank_transfer';
      case PaymentMethod.upi:
        return 'upi';
      case PaymentMethod.wallet:
        return 'wallet';
    }
  }

  static PaymentMethod fromString(String value) {
    switch (value.toLowerCase()) {
      case 'credit_card':
        return PaymentMethod.creditCard;
      case 'debit_card':
        return PaymentMethod.debitCard;
      case 'paypal':
        return PaymentMethod.paypal;
      case 'bank_transfer':
        return PaymentMethod.bankTransfer;
      case 'upi':
        return PaymentMethod.upi;
      case 'wallet':
        return PaymentMethod.wallet;
      default:
        return PaymentMethod.creditCard;
    }
  }
}
