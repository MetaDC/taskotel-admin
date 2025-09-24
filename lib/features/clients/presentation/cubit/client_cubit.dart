import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/domain/repo/client_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

part 'client_state.dart';

class ClientCubit extends Cubit<ClientState> {
  final ClientRepo clientRepo;
  static const int _pageSize = 10;

  ClientCubit({required this.clientRepo}) : super(ClientState.initial());

  Future<void> fetchPage() async {
    try {
      int pageZeroIndex = state.currentPage - 1;

      if (pageZeroIndex < state.clients.length &&
          state.clients[pageZeroIndex].isNotEmpty) {
        return;
      }

      Query query = FBFireStore.clients
          .where('status', isEqualTo: 'active')
          .limit(_pageSize);

      if (state.lastFetchedDoc != null) {
        query = query.startAfterDocument(state.lastFetchedDoc!);
      }

      final snap = await query.get();

      if (snap.docs.isNotEmpty) {
        final users = snap.docs
            .map(
              (doc) => ClientModel.fromDocSnap(
                doc as QueryDocumentSnapshot<Map<String, dynamic>>,
              ),
            )
            .toList();

        state.lastFetchedDoc = snap.docs.last;

        while (state.clients.length <= pageZeroIndex) {
          state.clients.add([]);
        }
        state.clients[pageZeroIndex] = users;
      }
    } on Exception catch (e) {
      print('Error fetching page: $e');
    }
  }

  Future<void> initializePagination() async {
    final userCountSnap = await FBFireStore.clients
        .where('status', isEqualTo: 'active')
        .count()
        .get();
    int totalItems = userCountSnap.count ?? 0;

    emit(
      state.copyWith(
        isLoading: true,
        clients: [],
        filteredClients: [],
        lastFetchedDoc: null,
        currentPage: 1,
        totalPages: (totalItems / _pageSize).ceil(),
      ),
    );

    try {
      await fetchPage();

      emit(
        state.copyWith(
          isLoading: false,
          clients: state.clients,
          filteredClients: state.clients[0],
          lastFetchedDoc: state.lastFetchedDoc,
          currentPage: state.currentPage,
          totalPages: state.totalPages,
        ),
      );
    } catch (e) {
      print('Error fetching page: $e');
      emit(state.copyWith(isLoading: false, message: e.toString()));
    }
  }

  Future<void> fetchNextPage({required int page}) async {
    emit(state.copyWith(isLoading: true, currentPage: page));
    try {
      await fetchPage();
      emit(
        state.copyWith(
          isLoading: false,
          filteredClients: state.clients[page - 1],
        ),
      );
    } catch (e) {
      print('Error fetching page: $e');
      emit(state.copyWith(isLoading: false, message: e.toString()));
    }
  }
}
