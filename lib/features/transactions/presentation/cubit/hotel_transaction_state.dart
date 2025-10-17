part of 'hotel_transaction_cubit.dart';

class HotelTransactionState extends Equatable {
  final List<TransactionModel> transactions;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final int totalPages;
  final int totalTransactions;
  final String searchQuery;
  final String statusFilter;
  final String hotelId;
  final int pageSize;

  const HotelTransactionState({
    required this.transactions,
    required this.isLoading,
    this.errorMessage,
    required this.currentPage,
    required this.totalPages,
    required this.totalTransactions,
    required this.searchQuery,
    required this.statusFilter,
    required this.hotelId,
    required this.pageSize,
  });

  factory HotelTransactionState.initial() {
    return const HotelTransactionState(
      transactions: [],
      isLoading: false,
      errorMessage: null,
      currentPage: 1,
      totalPages: 1,
      totalTransactions: 0,
      searchQuery: '',
      statusFilter: 'all',
      hotelId: '',
      pageSize: 10,
    );
  }

  HotelTransactionState copyWith({
    List<TransactionModel>? transactions,
    bool? isLoading,
    String? errorMessage,
    int? currentPage,
    int? totalPages,
    int? totalTransactions,
    String? searchQuery,
    String? statusFilter,
    String? hotelId,
    int? pageSize,
  }) {
    return HotelTransactionState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      hotelId: hotelId ?? this.hotelId,
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
        hotelId,
        pageSize,
      ];
}
