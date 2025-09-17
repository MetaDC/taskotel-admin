import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/features2/super_admin/domain/entities/transaction_entity.dart';
import 'package:intl/intl.dart';

class TransactionsTable extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final bool isLoading;
  final Function(TransactionEntity) onTransactionTap;
  final Function(TransactionEntity) onRefundTransaction;
  final Function() onExportCSV;

  const TransactionsTable({
    super.key,
    required this.transactions,
    required this.isLoading,
    required this.onTransactionTap,
    required this.onRefundTransaction,
    required this.onExportCSV,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (transactions.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildTableHeader(),
        Expanded(
          child: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return _buildTableRow(context, transactions[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Transactions will appear here once clients make payments',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            flex: 3,
            child: Text(
              'Client & Transaction',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Text(
              'Hotel & Plan',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              'Amount',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              'Status',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              'Payment Method',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              'Date',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 100), // Actions column
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, TransactionEntity transaction) {
    return InkWell(
      onTap: () => onTransactionTap(transaction),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.clientName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction.email,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'ID: ${transaction.transactionId}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.hotelName ?? 'No Hotel',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      transaction.planName,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${transaction.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  if (transaction.refundAmount != null) ...[
                    Text(
                      'Refunded: \$${transaction.refundAmount!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.red[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: _buildStatusChip(transaction.status),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  _buildPaymentMethodIcon(transaction.paymentMethod),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      transaction.paymentMethod.displayName,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMM dd, yyyy').format(transaction.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    DateFormat('HH:mm').format(transaction.createdAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (transaction.status == TransactionStatus.completed) ...[
                    IconButton(
                      onPressed: () => onRefundTransaction(transaction),
                      icon: const Icon(Icons.undo, size: 18),
                      tooltip: 'Refund',
                      color: Colors.orange,
                    ),
                  ],
                  IconButton(
                    onPressed: () => onTransactionTap(transaction),
                    icon: const Icon(Icons.visibility, size: 18),
                    tooltip: 'View Details',
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(TransactionStatus status) {
    Color color;
    IconData icon;
    
    switch (status) {
      case TransactionStatus.completed:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case TransactionStatus.pending:
        color = Colors.orange;
        icon = Icons.pending;
        break;
      case TransactionStatus.failed:
        color = Colors.red;
        icon = Icons.error;
        break;
      case TransactionStatus.refunded:
        color = Colors.blue;
        icon = Icons.undo;
        break;
      case TransactionStatus.cancelled:
        color = Colors.grey;
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.creditCard:
        return const Icon(Icons.credit_card, size: 16, color: Colors.blue);
      case PaymentMethod.debitCard:
        return const Icon(Icons.credit_card, size: 16, color: Colors.green);
      case PaymentMethod.paypal:
        return const Icon(Icons.account_balance_wallet, size: 16, color: Colors.indigo);
      case PaymentMethod.bankTransfer:
        return const Icon(Icons.account_balance, size: 16, color: Colors.purple);
      case PaymentMethod.upi:
        return const Icon(Icons.qr_code, size: 16, color: Colors.orange);
      case PaymentMethod.wallet:
        return const Icon(Icons.wallet, size: 16, color: Colors.teal);
    }
  }
}
