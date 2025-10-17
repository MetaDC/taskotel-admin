part of 'client_transaction_cubit.dart';

class ClientTransactionState extends Equatable {
  final List<TransactionModel> transactions;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final int totalPages;
  final int totalTransactions;
  final String searchQuery;
  final String statusFilter;
  final String clientId;
  final int pageSize;

  const ClientTransactionState({
    required this.transactions,
    required this.isLoading,
    this.errorMessage,
    required this.currentPage,
    required this.totalPages,
    required this.totalTransactions,
    required this.searchQuery,
    required this.statusFilter,
    required this.clientId,
    required this.pageSize,
  });

  factory ClientTransactionState.initial() {
    return const ClientTransactionState(
      transactions: [],
      isLoading: false,
      errorMessage: null,
      currentPage: 1,
      totalPages: 1,
      totalTransactions: 0,
      searchQuery: '',
      statusFilter: 'all',
      clientId: '',
      pageSize: 10,
    );
  }

  ClientTransactionState copyWith({
    List<TransactionModel>? transactions,
    bool? isLoading,
    String? errorMessage,
    int? currentPage,
    int? totalPages,
    int? totalTransactions,
    String? searchQuery,
    String? statusFilter,
    String? clientId,
    int? pageSize,
  }) {
    return ClientTransactionState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      clientId: clientId ?? this.clientId,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  @override
  List<Object?> get props => [
        transactions,
        isLoading,
        errorMessage,
        currentPage,
        totalPages,
        totalTransactions,
        searchQuery,
        statusFilter,
        clientId,
        pageSize,
      ];
}
