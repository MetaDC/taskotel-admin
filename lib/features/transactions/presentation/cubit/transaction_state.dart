part of 'transaction_cubit.dart';

enum TransactionFilter { today, weekly, monthly, custom, all }

class TransactionState extends Equatable {
  final List<TransactionModel> currentPageTransactions;
  final List<TransactionModel> searchResults;
  final int currentPage;
  final int totalPages;
  final bool isLoading;
  final bool isSearching;
  final String? errorMessage;
  final TransactionFilter selectedFilter;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final String searchQuery;
  final bool searchWithinFilter; // Switch state
  final DocumentSnapshot? lastDocument;
  final DocumentSnapshot? firstDocument;
  final Map<String, dynamic>? analytics;
  final int pageSize;

  const TransactionState({
    required this.currentPageTransactions,
    required this.searchResults,
    required this.currentPage,
    required this.totalPages,
    required this.isLoading,
    required this.isSearching,
    this.errorMessage,
    required this.selectedFilter,
    this.customStartDate,
    this.customEndDate,
    required this.searchQuery,
    required this.searchWithinFilter,
    this.lastDocument,
    this.firstDocument,
    this.analytics,
    required this.pageSize,
  });

  factory TransactionState.initial() {
    return const TransactionState(
      currentPageTransactions: [],
      searchResults: [],
      currentPage: 1,
      totalPages: 1,
      isLoading: false,
      isSearching: false,
      errorMessage: null,
      selectedFilter: TransactionFilter.all,
      customStartDate: null,
      customEndDate: null,
      searchQuery: '',
      searchWithinFilter: false,
      lastDocument: null,
      firstDocument: null,
      analytics: null,
      pageSize: 15,
    );
  }

  TransactionState copyWith({
    List<TransactionModel>? currentPageTransactions,
    List<TransactionModel>? searchResults,
    int? currentPage,
    int? totalPages,
    bool? isLoading,
    bool? isSearching,
    String? errorMessage,
    TransactionFilter? selectedFilter,
    DateTime? customStartDate,
    DateTime? customEndDate,
    String? searchQuery,
    bool? searchWithinFilter,
    DocumentSnapshot? lastDocument,
    DocumentSnapshot? firstDocument,
    Map<String, dynamic>? analytics,
    int? pageSize,
  }) {
    return TransactionState(
      currentPageTransactions: currentPageTransactions ?? this.currentPageTransactions,
      searchResults: searchResults ?? this.searchResults,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      errorMessage: errorMessage,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      customStartDate: customStartDate ?? this.customStartDate,
      customEndDate: customEndDate ?? this.customEndDate,
      searchQuery: searchQuery ?? this.searchQuery,
      searchWithinFilter: searchWithinFilter ?? this.searchWithinFilter,
      lastDocument: lastDocument ?? this.lastDocument,
      firstDocument: firstDocument ?? this.firstDocument,
      analytics: analytics ?? this.analytics,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  @override
  List<Object?> get props => [
        currentPageTransactions,
        searchResults,
        currentPage,
        totalPages,
        isLoading,
        isSearching,
        errorMessage,
        selectedFilter,
        customStartDate,
        customEndDate,
        searchQuery,
        searchWithinFilter,
        lastDocument,
        firstDocument,
        analytics,
        pageSize,
      ];
}

