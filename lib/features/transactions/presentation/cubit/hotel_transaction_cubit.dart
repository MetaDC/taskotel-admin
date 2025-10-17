import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/transactions/domain/entity/transactions_model.dart';

part 'hotel_transaction_state.dart';

class HotelTransactionCubit extends Cubit<HotelTransactionState> {
  Timer? _debounceTimer;

  HotelTransactionCubit() : super(HotelTransactionState.initial());

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  // Initialize with hotel ID
  Future<void> initialize(String hotelId) async {
    emit(state.copyWith(
      hotelId: hotelId,
      isLoading: true,
      errorMessage: null,
      currentPage: 1,
    ));

    try {
      await _loadTransactions();
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load transactions: ${e.toString()}',
      ));
    }
  }

  // Load transactions for current page
  Future<void> _loadTransactions() async {
    try {
      final query = _buildQuery();
      
      // For simplicity, we'll load all transactions and paginate in memory
      // In production, consider using Firestore pagination with startAfterDocument
      final snapshot = await query.get();
      final allTransactions = snapshot.docs
          .map(
            (doc) => TransactionModel.fromDocSnap(
              doc as QueryDocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();

      // Apply pagination
      final totalTransactions = allTransactions.length;
      final totalPages = (totalTransactions / state.pageSize).ceil();
      final offset = (state.currentPage - 1) * state.pageSize;
      final pageTransactions = allTransactions
          .skip(offset)
          .take(state.pageSize)
          .toList();

      emit(
        state.copyWith(
          transactions: pageTransactions,
          isLoading: false,
          totalTransactions: totalTransactions,
          totalPages: totalPages > 0 ? totalPages : 1,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load transactions: ${e.toString()}',
        ),
      );
    }
  }

  // Build Firestore query based on current filters
  Query _buildQuery() {
    Query query = FBFireStore.transactions
        .where('hotelId', isEqualTo: state.hotelId)
        .orderBy('createdAt', descending: true);

    // Apply status filter
    if (state.statusFilter != 'all') {
      query = query.where('status', isEqualTo: state.statusFilter);
    }

    return query;
  }

  // Search transactions
  Future<void> searchTransactions(String searchQuery) async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      emit(state.copyWith(
        searchQuery: searchQuery,
        currentPage: 1,
        isLoading: true,
      ));

      try {
        if (searchQuery.isEmpty) {
          await _loadTransactions();
        } else {
          await _performSearch(searchQuery);
        }
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Search failed: ${e.toString()}',
        ));
      }
    });
  }

  // Perform search with query
  Future<void> _performSearch(String searchQuery) async {
    try {
      // Get all transactions for the hotel first
      final query = _buildQuery();
      final snapshot = await query.get();

      final allTransactions = snapshot.docs
          .map(
            (doc) => TransactionModel.fromDocSnap(
              doc as QueryDocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();

      // Filter locally by search query
      final searchLower = searchQuery.toLowerCase();
      final filteredTransactions = allTransactions.where((transaction) {
        return transaction.transactionId.toLowerCase().contains(searchLower) ||
            transaction.clientName.toLowerCase().contains(searchLower) ||
            transaction.planName.toLowerCase().contains(searchLower) ||
            transaction.paymentMethod.toLowerCase().contains(searchLower) ||
            transaction.email.toLowerCase().contains(searchLower) ||
            transaction.amount.toString().contains(searchLower);
      }).toList();

      // Apply pagination to filtered results
      final totalTransactions = filteredTransactions.length;
      final totalPages = (totalTransactions / state.pageSize).ceil();
      final offset = (state.currentPage - 1) * state.pageSize;
      final pageTransactions = filteredTransactions
          .skip(offset)
          .take(state.pageSize)
          .toList();

      emit(state.copyWith(
        transactions: pageTransactions,
        isLoading: false,
        totalTransactions: totalTransactions,
        totalPages: totalPages > 0 ? totalPages : 1,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Search failed: ${e.toString()}',
      ));
    }
  }

  // Filter by status
  Future<void> filterByStatus(String status) async {
    emit(state.copyWith(
      statusFilter: status,
      currentPage: 1,
      isLoading: true,
    ));

    try {
      if (state.searchQuery.isNotEmpty) {
        await _performSearch(state.searchQuery);
      } else {
        await _loadTransactions();
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Filter failed: ${e.toString()}',
      ));
    }
  }

  // Go to specific page
  Future<void> goToPage(int page) async {
    if (page < 1 || page > state.totalPages || page == state.currentPage) {
      return;
    }

    emit(state.copyWith(
      currentPage: page,
      isLoading: true,
    ));

    try {
      if (state.searchQuery.isNotEmpty) {
        await _performSearch(state.searchQuery);
      } else {
        await _loadTransactions();
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load page: ${e.toString()}',
      ));
    }
  }

  // Refresh transactions
  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    
    try {
      if (state.searchQuery.isNotEmpty) {
        await _performSearch(state.searchQuery);
      } else {
        await _loadTransactions();
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Refresh failed: ${e.toString()}',
      ));
    }
  }
}
