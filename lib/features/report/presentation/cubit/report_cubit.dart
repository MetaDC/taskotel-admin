import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/transactions/domain/entity/transactions_model.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportState.initial());

  // Initialize and load all reports
  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      await Future.wait([
        _loadRevenueData(),
        _loadSubscriptionData(),
        _loadClientData(),
        _loadTransactionData(),
      ]);

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load reports: ${e.toString()}',
        ),
      );
    }
  }

  // Change time filter
  void changeTimeFilter(ReportTimeFilter filter) {
    emit(state.copyWith(timeFilter: filter));
    initialize();
  }

  // Change selected year
  void changeYear(int year) {
    emit(state.copyWith(selectedYear: year));
    initialize();
  }

  // Change selected month
  void changeMonth(int month) {
    emit(state.copyWith(selectedMonth: month));
    initialize();
  }

  // Load revenue data
  Future<void> _loadRevenueData() async {
    try {
      final transactionsSnapshot = await FBFireStore.transactions.get();
      final transactions = transactionsSnapshot.docs
          .map((doc) => TransactionModel.fromDocSnap(doc))
          .toList();

      // Calculate total revenue
      final totalRevenue = transactions
          .where((t) => t.isPaid && t.status == 'success')
          .fold<double>(0, (total, t) => total + t.amount);

      // Calculate revenue by month for the selected year
      final revenueByMonth = <Map<String, dynamic>>[];
      for (int month = 1; month <= 12; month++) {
        final monthTransactions = transactions.where((t) {
          return t.createdAt.year == state.selectedYear &&
              t.createdAt.month == month &&
              t.isPaid &&
              t.status == 'success';
        });

        final monthRevenue = monthTransactions.fold<double>(
          0,
          (total, t) => total + t.amount,
        );

        revenueByMonth.add({
          'month': _getMonthName(month),
          'revenue': monthRevenue,
          'monthNumber': month,
        });
      }

      emit(
        state.copyWith(
          totalRevenue: totalRevenue,
          revenueByMonth: revenueByMonth,
        ),
      );
    } catch (e) {
      // Handle error silently for individual data load
      print('Error loading revenue data: $e');
    }
  }

  // Load subscription data
  Future<void> _loadSubscriptionData() async {
    try {
      final clientsSnapshot = await FBFireStore.clients.get();
      final clients = clientsSnapshot.docs
          .map((doc) => ClientModel.fromDocSnap(doc))
          .toList();

      // Count active subscribers
      final activeSubscribers = clients
          .where(
            (c) =>
                c.status == ClientStatus.active ||
                c.status == ClientStatus.trial,
          )
          .length;

      final totalSubscribers = clients.length;

      // Calculate churn rate
      final churnedClients = clients
          .where(
            (c) =>
                c.status == ClientStatus.churned ||
                c.status == ClientStatus.inactive ||
                c.status == ClientStatus.suspended,
          )
          .length;

      final churnRate = totalSubscribers > 0
          ? (churnedClients / totalSubscribers) * 100
          : 0.0;

      // Calculate average revenue per user
      final avgRevenuePerUser = activeSubscribers > 0
          ? state.totalRevenue / activeSubscribers
          : 0.0;

      // Plan distribution - Get from transactions
      final transactionsSnapshot = await FBFireStore.transactions.get();
      final transactions = transactionsSnapshot.docs
          .map((doc) => TransactionModel.fromDocSnap(doc))
          .toList();

      final planDistribution = <String, int>{};
      final planRevenue = <String, double>{};

      // Group by plan name from transactions
      for (final transaction in transactions) {
        if (transaction.status == 'success' && transaction.isPaid) {
          final planName = transaction.planName;
          planDistribution[planName] = (planDistribution[planName] ?? 0) + 1;
          planRevenue[planName] =
              (planRevenue[planName] ?? 0) + transaction.amount;
        }
      }

      emit(
        state.copyWith(
          activeSubscribers: activeSubscribers,
          totalSubscribers: totalSubscribers,
          churnRate: churnRate,
          avgRevenuePerUser: avgRevenuePerUser,
          planDistribution: planDistribution,
          planRevenue: planRevenue,
        ),
      );
    } catch (e) {
      print('Error loading subscription data: $e');
    }
  }

  // Load client data
  Future<void> _loadClientData() async {
    try {
      final clientsSnapshot = await FBFireStore.clients.get();
      final clients = clientsSnapshot.docs
          .map((doc) => ClientModel.fromDocSnap(doc))
          .toList();

      // New clients this month
      final now = DateTime.now();
      final newClientsThisMonth = clients.where((c) {
        return c.createdAt.year == now.year && c.createdAt.month == now.month;
      }).length;

      // Churned clients this month
      final churnedClientsThisMonth = clients.where((c) {
        return (c.status == 'churned' ||
                c.status == 'inactive' ||
                c.status == 'suspended') &&
            c.updatedAt.year == now.year &&
            c.updatedAt.month == now.month;
      }).length;

      // Client acquisition by month
      final clientAcquisitionByMonth = <Map<String, dynamic>>[];
      for (int month = 1; month <= 12; month++) {
        final monthClients = clients.where((c) {
          return c.createdAt.year == state.selectedYear &&
              c.createdAt.month == month;
        }).length;

        clientAcquisitionByMonth.add({
          'month': _getMonthName(month),
          'count': monthClients,
          'monthNumber': month,
        });
      }

      // Churn vs Retention by month
      final churnVsRetention = <Map<String, dynamic>>[];
      for (int month = 1; month <= 6; month++) {
        final monthDate = DateTime(now.year, now.month - (6 - month));
        final retained = clients.where((c) {
          return (c.status == 'active' || c.status == 'trial') &&
              c.createdAt.isBefore(monthDate);
        }).length;

        final churned = clients.where((c) {
          return (c.status == 'churned' ||
                  c.status == 'inactive' ||
                  c.status == 'suspended') &&
              c.updatedAt.year == monthDate.year &&
              c.updatedAt.month == monthDate.month;
        }).length;

        churnVsRetention.add({
          'month': _getMonthName(monthDate.month),
          'retained': retained,
          'churned': churned,
        });
      }

      emit(
        state.copyWith(
          newClientsThisMonth: newClientsThisMonth,
          churnedClientsThisMonth: churnedClientsThisMonth,
          clientAcquisitionByMonth: clientAcquisitionByMonth,
          churnVsRetention: churnVsRetention,
        ),
      );
    } catch (e) {
      print('Error loading client data: $e');
    }
  }

  // Load transaction data
  Future<void> _loadTransactionData() async {
    try {
      final transactionsSnapshot = await FBFireStore.transactions.get();
      final transactions = transactionsSnapshot.docs
          .map((doc) => TransactionModel.fromDocSnap(doc))
          .toList();

      final successfulTransactions = transactions
          .where((t) => t.status == 'success')
          .length;

      final failedTransactions = transactions
          .where((t) => t.status == 'failed')
          .length;

      final pendingTransactions = transactions.where((t) => !t.isPaid).length;

      final totalTransactionAmount = transactions
          .where((t) => t.status == 'success')
          .fold<double>(0, (total, t) => total + t.amount);

      emit(
        state.copyWith(
          successfulTransactions: successfulTransactions,
          failedTransactions: failedTransactions,
          pendingTransactions: pendingTransactions,
          totalTransactionAmount: totalTransactionAmount,
        ),
      );
    } catch (e) {
      print('Error loading transaction data: $e');
    }
  }

  // Helper: Get client revenue
  Future<double> _getClientRevenue(String clientId) async {
    try {
      final transactionsSnapshot = await FBFireStore.transactions
          .where('clientId', isEqualTo: clientId)
          .get();

      final transactions = transactionsSnapshot.docs
          .map((doc) => TransactionModel.fromDocSnap(doc))
          .toList();

      return transactions
          .where((t) => t.isPaid && t.status == 'success')
          .fold<double>(0, (total, t) => total + t.amount);
    } catch (e) {
      return 0.0;
    }
  }

  // Helper: Get month name
  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  // Set error message
  void setError(String? error) {
    emit(state.copyWith(errorMessage: error, isLoading: false));
  }

  // Set export loading state
  void setExportLoading(bool loading) {
    emit(state.copyWith(isExporting: loading, exportMessage: null));
  }

  // Set export message (success or error)
  void setExportMessage(String message) {
    emit(state.copyWith(exportMessage: message));
  }

  // Clear export message
  void clearExportMessage() {
    emit(state.copyWith(exportMessage: null));
  }
}
