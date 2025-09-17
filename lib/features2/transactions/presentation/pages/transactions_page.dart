import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features2/super_admin/domain/entities/transaction_entity.dart';
import 'package:taskoteladmin/features2/transactions/presentation/widgets/transactions_table.dart';
import 'package:taskoteladmin/features2/transactions/presentation/widgets/transaction_filters.dart';
import 'package:taskoteladmin/features2/transactions/presentation/widgets/financial_analytics_cards.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  bool _isLoading = true;
  List<TransactionEntity> _transactions = [];
  String _searchQuery = '';
  TransactionStatus? _selectedStatus;
  PaymentMethod? _selectedPaymentMethod;
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    // TODO: Replace with actual repository call
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() {
        _transactions = _getMockTransactions();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: ResponsiveWid(
        mobile: _buildMobileLayout(),
        desktop: _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          FinancialAnalyticsCards(transactions: _transactions),
          const SizedBox(height: 24),
          TransactionFilters(
            searchQuery: _searchQuery,
            selectedStatus: _selectedStatus,
            selectedPaymentMethod: _selectedPaymentMethod,
            selectedDateRange: _selectedDateRange,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
              _applyFilters();
            },
            onStatusChanged: (status) {
              setState(() {
                _selectedStatus = status;
              });
              _applyFilters();
            },
            onPaymentMethodChanged: (method) {
              setState(() {
                _selectedPaymentMethod = method;
              });
              _applyFilters();
            },
            onDateRangeChanged: (range) {
              setState(() {
                _selectedDateRange = range;
              });
              _applyFilters();
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
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
              child: TransactionsTable(
                transactions: _transactions,
                isLoading: _isLoading,
                onTransactionTap: _onTransactionTap,
                onRefundTransaction: _onRefundTransaction,
                onExportCSV: _onExportCSV,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          FinancialAnalyticsCards(transactions: _transactions),
          const SizedBox(height: 16),
          TransactionFilters(
            searchQuery: _searchQuery,
            selectedStatus: _selectedStatus,
            selectedPaymentMethod: _selectedPaymentMethod,
            selectedDateRange: _selectedDateRange,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
              _applyFilters();
            },
            onStatusChanged: (status) {
              setState(() {
                _selectedStatus = status;
              });
              _applyFilters();
            },
            onPaymentMethodChanged: (method) {
              setState(() {
                _selectedPaymentMethod = method;
              });
              _applyFilters();
            },
            onDateRangeChanged: (range) {
              setState(() {
                _selectedDateRange = range;
              });
              _applyFilters();
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
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
              child: TransactionsTable(
                transactions: _transactions,
                isLoading: _isLoading,
                onTransactionTap: _onTransactionTap,
                onRefundTransaction: _onRefundTransaction,
                onExportCSV: _onExportCSV,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transactions & Financial Analytics',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Track payments, refunds, and financial performance across all clients.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _onExportCSV,
              icon: const Icon(Icons.download, color: Colors.white),
              label: const Text(
                'Export CSV',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _showFinancialReport,
              icon: const Icon(Icons.analytics, color: Colors.white),
              label: const Text(
                'Financial Report',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _applyFilters() {
    // TODO: Implement filtering logic
    _loadTransactions();
  }

  void _onTransactionTap(TransactionEntity transaction) {
    context.go('/transactions/${transaction.id}');
  }

  void _onRefundTransaction(TransactionEntity transaction) {
    // TODO: Implement refund functionality
    print('Refund transaction: ${transaction.id}');
  }

  void _onExportCSV() {
    // TODO: Implement CSV export functionality
    print('Export CSV');
  }

  void _showFinancialReport() {
    // TODO: Implement financial report functionality
    print('Show financial report');
  }

  // Mock data for demonstration
  List<TransactionEntity> _getMockTransactions() {
    return [
      TransactionEntity(
        id: '1',
        clientId: 'client1',
        clientName: 'John Smith',
        email: 'john@grandhotel.com',
        hotelId: 'hotel1',
        hotelName: 'Grand Hotel Downtown',
        purchaseModelId: 'plan1',
        planName: 'Professional',
        amount: 49.0,
        status: TransactionStatus.completed,
        paymentMethod: PaymentMethod.creditCard,
        isPaid: true,
        paidAt: DateTime.now().subtract(const Duration(hours: 2)),
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        transactionId: 'txn_1234567890',
      ),
      TransactionEntity(
        id: '2',
        clientId: 'client2',
        clientName: 'Sarah Johnson',
        email: 'sarah@luxuryresorts.com',
        hotelId: 'hotel2',
        hotelName: 'Luxury Resort & Spa',
        purchaseModelId: 'plan2',
        planName: 'Enterprise',
        amount: 99.0,
        status: TransactionStatus.pending,
        paymentMethod: PaymentMethod.paypal,
        isPaid: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        transactionId: 'txn_0987654321',
      ),
      TransactionEntity(
        id: '3',
        clientId: 'client3',
        clientName: 'Michael Brown',
        email: 'michael@cityhotels.com',
        hotelId: 'hotel3',
        hotelName: 'City Hotel Chain',
        purchaseModelId: 'plan1',
        planName: 'Professional',
        amount: 49.0,
        status: TransactionStatus.failed,
        paymentMethod: PaymentMethod.creditCard,
        isPaid: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        transactionId: 'txn_1122334455',
        failureReason: 'Insufficient funds',
      ),
      TransactionEntity(
        id: '4',
        clientId: 'client4',
        clientName: 'Emily Davis',
        email: 'emily@boutiquehotels.com',
        hotelId: 'hotel4',
        hotelName: 'Boutique Hotel Collection',
        purchaseModelId: 'plan3',
        planName: 'Starter',
        amount: 29.0,
        status: TransactionStatus.refunded,
        paymentMethod: PaymentMethod.debitCard,
        isPaid: false,
        paidAt: DateTime.now().subtract(const Duration(days: 5)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        transactionId: 'txn_5566778899',
        refundId: 'ref_1234567890',
        refundAmount: 29.0,
      ),
    ];
  }
}
