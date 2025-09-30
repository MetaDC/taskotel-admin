import 'package:taskoteladmin/features/transactions/domain/entity/transactions_model.dart';

abstract class TransactionsRepo {
  // Stream methods
  Stream<List<TransactionModel>> getTransactionsStream();

  // CRUD operations
  Future<void> createTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String transactionId);

  // Analytics
  Future<Map<String, dynamic>> getTransactionAnalytics();

  // Search and filter
  Future<List<TransactionModel>> searchTransactions(String query);
  Future<List<TransactionModel>> filterByStatus(bool isActive);
}
