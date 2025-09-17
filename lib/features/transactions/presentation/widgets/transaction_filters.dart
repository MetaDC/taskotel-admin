import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/features/super_admin/domain/entities/transaction_entity.dart';

class TransactionFilters extends StatelessWidget {
  final String searchQuery;
  final TransactionStatus? selectedStatus;
  final PaymentMethod? selectedPaymentMethod;
  final DateTimeRange? selectedDateRange;
  final Function(String) onSearchChanged;
  final Function(TransactionStatus?) onStatusChanged;
  final Function(PaymentMethod?) onPaymentMethodChanged;
  final Function(DateTimeRange?) onDateRangeChanged;

  const TransactionFilters({
    super.key,
    required this.searchQuery,
    required this.selectedStatus,
    required this.selectedPaymentMethod,
    required this.selectedDateRange,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.onPaymentMethodChanged,
    required this.onDateRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText:
                        'Search by client name, email, hotel, or transaction ID...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 130,
                child: DropdownButtonFormField<TransactionStatus?>(
                  value: selectedStatus,
                  onChanged: onStatusChanged,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<TransactionStatus?>(
                      value: null,
                      child: Text('All Status'),
                    ),
                    ...TransactionStatus.values.map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.displayName),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 160,
                child: DropdownButtonFormField<PaymentMethod?>(
                  value: selectedPaymentMethod,
                  onChanged: onPaymentMethodChanged,
                  decoration: InputDecoration(
                    labelText: 'Payment Method',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<PaymentMethod?>(
                      value: null,
                      child: Text('All Methods'),
                    ),
                    ...PaymentMethod.values.map(
                      (method) => DropdownMenuItem(
                        value: method,
                        child: Text(method.displayName),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectDateRange(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.date_range, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          selectedDateRange != null
                              ? '${_formatDate(selectedDateRange!.start)} - ${_formatDate(selectedDateRange!.end)}'
                              : 'Select date range',
                          style: TextStyle(
                            color: selectedDateRange != null
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  onStatusChanged(null);
                  onPaymentMethodChanged(null);
                  onDateRangeChanged(null);
                  onSearchChanged('');
                },
                icon: const Icon(Icons.clear, size: 18),
                label: const Text('Clear Filters'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.grey[700],
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement advanced filters
                },
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('Advanced'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return const Icon(Icons.check_circle, size: 16, color: Colors.green);
      case TransactionStatus.pending:
        return const Icon(Icons.pending, size: 16, color: Colors.orange);
      case TransactionStatus.failed:
        return const Icon(Icons.error, size: 16, color: Colors.red);
      case TransactionStatus.refunded:
        return const Icon(Icons.undo, size: 16, color: Colors.blue);
      case TransactionStatus.cancelled:
        return const Icon(Icons.cancel, size: 16, color: Colors.grey);
    }
  }

  Widget _buildPaymentMethodIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.creditCard:
        return const Icon(Icons.credit_card, size: 16, color: Colors.blue);
      case PaymentMethod.debitCard:
        return const Icon(Icons.credit_card, size: 16, color: Colors.green);
      case PaymentMethod.paypal:
        return const Icon(
          Icons.account_balance_wallet,
          size: 16,
          color: Colors.indigo,
        );
      case PaymentMethod.bankTransfer:
        return const Icon(
          Icons.account_balance,
          size: 16,
          color: Colors.purple,
        );
      case PaymentMethod.upi:
        return const Icon(Icons.qr_code, size: 16, color: Colors.orange);
      case PaymentMethod.wallet:
        return const Icon(Icons.wallet, size: 16, color: Colors.teal);
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: selectedDateRange,
    );
    if (picked != null) {
      onDateRangeChanged(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
