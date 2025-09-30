import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/transactions/domain/entity/transactions_model.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  StreamSubscription? _realtimeSubscription;

  TransactionCubit() : super(TransactionState.initial());

  @override
  Future<void> close() {
    _realtimeSubscription?.cancel();
    return super.close();
  }

  // Initialize with real-time updates for first page
  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Fetch analytics
      await _fetchAnalytics();

      // Start real-time listener for first page
      _startRealtimeListener();

      // Calculate total pages
      await _calculateTotalPages();
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to initialize: ${e.toString()}',
        ),
      );
    }
  }

  // Start real-time listener for the first page only
  void _startRealtimeListener() {
    _realtimeSubscription?.cancel();

    Query query = _buildBaseQuery();
    query = query.limit(state.pageSize);

    _realtimeSubscription = query.snapshots().listen(
      (snapshot) {
        if (state.currentPage == 1 && state.searchQuery.isEmpty) {
          final transactions = snapshot.docs
              .map(
                (doc) => TransactionModel.fromDocSnap(
                  doc as QueryDocumentSnapshot<Map<String, dynamic>>,
                ),
              )
              .toList();

          emit(
            state.copyWith(
              currentPageTransactions: transactions,
              isLoading: false,
              lastDocument: snapshot.docs.isNotEmpty
                  ? snapshot.docs.last
                  : null,
              firstDocument: snapshot.docs.isNotEmpty
                  ? snapshot.docs.first
                  : null,
            ),
          );
        }
      },
      onError: (error) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Real-time update failed: ${error.toString()}',
          ),
        );
      },
    );
  }

  // Build base query with filters
  Query _buildBaseQuery() {
    Query query = FBFireStore.transactions.orderBy(
      'createdAt',
      descending: true,
    );

    // Apply date filters
    final now = DateTime.now();
    DateTime? startDate;
    DateTime? endDate;

    switch (state.selectedFilter) {
      case TransactionFilter.today:
        startDate = DateTime(now.year, now.month, now.day);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case TransactionFilter.weekly:
        startDate = now.subtract(const Duration(days: 7));
        endDate = now;
        break;
      case TransactionFilter.monthly:
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      case TransactionFilter.custom:
        startDate = state.customStartDate;
        endDate = state.customEndDate;
        break;
      case TransactionFilter.all:
        // No date filter
        break;
    }

    if (startDate != null && endDate != null) {
      query = query
          .where(
            'createdAt',
            isGreaterThanOrEqualTo: startDate.millisecondsSinceEpoch,
          )
          .where(
            'createdAt',
            isLessThanOrEqualTo: endDate.millisecondsSinceEpoch,
          );
    }

    return query;
  }

  // Calculate total pages based on filter
  Future<void> _calculateTotalPages() async {
    try {
      final query = _buildBaseQuery();
      final countSnapshot = await query.count().get();
      final totalCount = countSnapshot.count ?? 0;
      final totalPages = (totalCount / state.pageSize).ceil();

      emit(state.copyWith(totalPages: totalPages > 0 ? totalPages : 1));
    } catch (e) {
      // If count fails, default to 1 page
      emit(state.copyWith(totalPages: 1));
    }
  }

  // Fetch specific page
  Future<void> fetchPage(int page) async {
    if (page < 1 || page > state.totalPages) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      Query query = _buildBaseQuery();

      // For page 1, use real-time listener
      if (page == 1) {
        _startRealtimeListener();
        return;
      }

      // For other pages, cancel real-time and fetch manually
      _realtimeSubscription?.cancel();

      // Navigate to the requested page
      if (page > state.currentPage) {
        // Going forward
        if (state.lastDocument != null) {
          query = query.startAfterDocument(state.lastDocument!);
        }
      } else if (page < state.currentPage) {
        // Going backward
        if (state.firstDocument != null) {
          query = query
              .endBeforeDocument(state.firstDocument!)
              .limitToLast(state.pageSize);
        }
      }

      query = query.limit(state.pageSize);
      final snapshot = await query.get();

      final transactions = snapshot.docs
          .map(
            (doc) => TransactionModel.fromDocSnap(
              doc as QueryDocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();

      emit(
        state.copyWith(
          currentPageTransactions: transactions,
          currentPage: page,
          isLoading: false,
          lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
          firstDocument: snapshot.docs.isNotEmpty ? snapshot.docs.first : null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to fetch page: ${e.toString()}',
        ),
      );
    }
  }

  // Next page
  Future<void> nextPage() async {
    if (state.currentPage < state.totalPages) {
      await fetchPage(state.currentPage + 1);
    }
  }

  // Previous page
  Future<void> previousPage() async {
    if (state.currentPage > 1) {
      await fetchPage(state.currentPage - 1);
    }
  }

  // Change filter
  Future<void> changeFilter(
    TransactionFilter filter, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(
      state.copyWith(
        selectedFilter: filter,
        customStartDate: startDate,
        customEndDate: endDate,
        currentPage: 1,
      ),
    );

    await _calculateTotalPages();
    await fetchPage(1);
  }

  // Toggle search within filter switch
  void toggleSearchWithinFilter(bool value) {
    emit(state.copyWith(searchWithinFilter: value));
    if (state.searchQuery.isNotEmpty) {
      searchTransactions(state.searchQuery);
    }
  }

  // Search transactions
  Future<void> searchTransactions(String query) async {
    emit(
      state.copyWith(searchQuery: query, isSearching: true, errorMessage: null),
    );

    if (query.isEmpty) {
      emit(state.copyWith(searchResults: [], isSearching: false));
      // Resume real-time updates for page 1
      if (state.currentPage == 1) {
        _startRealtimeListener();
      }
      return;
    }

    try {
      // Cancel real-time updates during search
      _realtimeSubscription?.cancel();

      Query searchQuery;

      if (state.searchWithinFilter) {
        // Search within current filter
        searchQuery = _buildBaseQuery();
      } else {
        // Search all transactions
        searchQuery = FBFireStore.transactions.orderBy(
          'createdAt',
          descending: true,
        );
      }

      // Fetch all matching documents (Firestore doesn't support text search natively)
      // In production, consider using Algolia or ElasticSearch for better search
      final snapshot = await searchQuery.limit(100).get();

      final allTransactions = snapshot.docs
          .map(
            (doc) => TransactionModel.fromDocSnap(
              doc as QueryDocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();

      // Filter locally by search query
      final searchLower = query.toLowerCase();
      final results = allTransactions.where((transaction) {
        return transaction.transactionId.toLowerCase().contains(searchLower) ||
            transaction.clientName.toLowerCase().contains(searchLower) ||
            transaction.hotelName.toLowerCase().contains(searchLower) ||
            transaction.email.toLowerCase().contains(searchLower) ||
            transaction.amount.toString().contains(searchLower);
      }).toList();

      emit(state.copyWith(searchResults: results, isSearching: false));
    } catch (e) {
      emit(
        state.copyWith(
          isSearching: false,
          errorMessage: 'Search failed: ${e.toString()}',
        ),
      );
    }
  }

  // Fetch analytics
  Future<void> _fetchAnalytics() async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);

      // Fetch all transactions for analytics
      final snapshot = await FBFireStore.transactions.get();

      final allTransactions = snapshot.docs
          .map((doc) => TransactionModel.fromDocSnap(doc))
          .toList();

      final totalRevenue = allTransactions
          .where((t) => t.isPaid)
          .fold<double>(0, (total, t) => total + t.amount);

      final successfulTransactions = allTransactions
          .where((t) => t.status == 'success')
          .length;

      final pendingPayments = allTransactions.where((t) => !t.isPaid).length;

      final thisMonthTransactions = allTransactions
          .where((t) => t.createdAt.isAfter(startOfMonth))
          .length;

      emit(
        state.copyWith(
          analytics: {
            'totalRevenue': totalRevenue,
            'successfulTransactions': successfulTransactions,
            'pendingPayments': pendingPayments,
            'thisMonthTransactions': thisMonthTransactions,
          },
        ),
      );
    } catch (e) {
      // Analytics failure shouldn't block the main functionality
      emit(
        state.copyWith(
          analytics: {
            'totalRevenue': 0.0,
            'successfulTransactions': 0,
            'pendingPayments': 0,
            'thisMonthTransactions': 0,
          },
        ),
      );
    }
  }

  // Refresh analytics
  Future<void> refreshAnalytics() async {
    await _fetchAnalytics();
  }
}
