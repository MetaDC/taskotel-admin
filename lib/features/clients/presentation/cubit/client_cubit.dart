import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/domain/repo/client_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'client_state.dart';

class ClientCubit extends Cubit<ClientState> {
  final ClientRepo clientRepo;
  static const int _pageSize = 10;

  ClientCubit({required this.clientRepo}) : super(ClientState.initial());

  // Fetch active clients page
  Future<void> fetchActiveClientsPage() async {
    try {
      int pageZeroIndex = state.activeCurrentPage - 1;

      if (pageZeroIndex < state.activeClients.length &&
          state.activeClients[pageZeroIndex].isNotEmpty) {
        return;
      }

      Query query = FBFireStore.clients
          .where('status', whereIn: ['active', 'trial'])
          .limit(_pageSize);

      if (state.activeLastFetchedDoc != null) {
        query = query.startAfterDocument(state.activeLastFetchedDoc!);
      }

      final snap = await query.get();

      if (snap.docs.isNotEmpty) {
        final clients = snap.docs
            .map(
              (doc) => ClientModel.fromDocSnap(
                doc as QueryDocumentSnapshot<Map<String, dynamic>>,
              ),
            )
            .toList();

        final newActiveLastFetchedDoc = snap.docs.last;
        final updatedActiveClients = List<List<ClientModel>>.from(
          state.activeClients,
        );

        while (updatedActiveClients.length <= pageZeroIndex) {
          updatedActiveClients.add([]);
        }
        updatedActiveClients[pageZeroIndex] = clients;

        emit(
          state.copyWith(
            activeClients: updatedActiveClients,
            activeLastFetchedDoc: newActiveLastFetchedDoc,
          ),
        );
      }
    } on Exception catch (e) {
      print('Error fetching active clients page: $e');
    }
  }

  // Fetch lost clients page
  Future<void> fetchLostClientsPage() async {
    try {
      int pageZeroIndex = state.lostCurrentPage - 1;

      if (pageZeroIndex < state.lostClients.length &&
          state.lostClients[pageZeroIndex].isNotEmpty) {
        return;
      }

      Query query = FBFireStore.clients
          .where('status', whereIn: ['churned', 'inactive', 'suspended'])
          .limit(_pageSize);

      if (state.lostLastFetchedDoc != null) {
        query = query.startAfterDocument(state.lostLastFetchedDoc!);
      }

      final snap = await query.get();

      if (snap.docs.isNotEmpty) {
        final clients = snap.docs
            .map(
              (doc) => ClientModel.fromDocSnap(
                doc as QueryDocumentSnapshot<Map<String, dynamic>>,
              ),
            )
            .toList();

        final newLostLastFetchedDoc = snap.docs.last;
        final updatedLostClients = List<List<ClientModel>>.from(
          state.lostClients,
        );

        while (updatedLostClients.length <= pageZeroIndex) {
          updatedLostClients.add([]);
        }
        updatedLostClients[pageZeroIndex] = clients;

        emit(
          state.copyWith(
            lostClients: updatedLostClients,
            lostLastFetchedDoc: newLostLastFetchedDoc,
          ),
        );
      }
    } on Exception catch (e) {
      print('Error fetching lost clients page: $e');
    }
  }

  // Initialize active clients pagination
  Future<void> initializeActiveClientsPagination() async {
    final userCountSnap = await FBFireStore.clients
        .where('status', whereIn: ['active', 'trial'])
        .count()
        .get();
    int totalItems = userCountSnap.count ?? 0;

    emit(
      state.copyWith(
        isLoading: true,
        activeClients: [],
        filteredActiveClients: [],
        activeLastFetchedDoc: null,
        activeCurrentPage: 1,
        activeTotalPages: (totalItems / _pageSize).ceil(),
      ),
    );

    try {
      await fetchActiveClientsPage();

      emit(
        state.copyWith(
          isLoading: false,
          activeClients: state.activeClients,
          filteredActiveClients: state.activeClients.isNotEmpty
              ? state.activeClients[0]
              : [],
        ),
      );
    } catch (e) {
      print('Error fetching active clients: $e');
      emit(state.copyWith(isLoading: false, message: e.toString()));
    }
  }

  // Initialize lost clients pagination
  Future<void> initializeLostClientsPagination() async {
    final userCountSnap = await FBFireStore.clients
        .where('status', whereIn: ['churned', 'inactive', 'suspended'])
        .count()
        .get();
    int totalItems = userCountSnap.count ?? 0;

    emit(
      state.copyWith(
        isLoading: true,
        lostClients: [],
        filteredLostClients: [],
        lostLastFetchedDoc: null,
        lostCurrentPage: 1,
        lostTotalPages: (totalItems / _pageSize).ceil(),
      ),
    );

    try {
      await fetchLostClientsPage();

      emit(
        state.copyWith(
          isLoading: false,
          lostClients: state.lostClients,
          filteredLostClients: state.lostClients.isNotEmpty
              ? state.lostClients[0]
              : [],
        ),
      );
    } catch (e) {
      print('Error fetching lost clients: $e');
      emit(state.copyWith(isLoading: false, message: e.toString()));
    }
  }

  // Fetch next active clients page
  Future<void> fetchNextActiveClientsPage({required int page}) async {
    emit(state.copyWith(isLoading: true, activeCurrentPage: page));
    try {
      await fetchActiveClientsPage();
      emit(
        state.copyWith(
          isLoading: false,
          filteredActiveClients: state.activeClients.length >= page
              ? state.activeClients[page - 1]
              : [],
        ),
      );
    } catch (e) {
      print('Error fetching active clients page: $e');
      emit(state.copyWith(isLoading: false, message: e.toString()));
    }
  }

  // Fetch next lost clients page
  Future<void> fetchNextLostClientsPage({required int page}) async {
    emit(state.copyWith(isLoading: true, lostCurrentPage: page));
    try {
      await fetchLostClientsPage();
      emit(
        state.copyWith(
          isLoading: false,
          filteredLostClients: state.lostClients.length >= page
              ? state.lostClients[page - 1]
              : [],
        ),
      );
    } catch (e) {
      print('Error fetching lost clients page: $e');
      emit(state.copyWith(isLoading: false, message: e.toString()));
    }
  }

  // Search functionality
  void searchClients(String query) {
    emit(state.copyWith(searchQuery: query));

    // Filter active clients
    if (state.activeClients.isNotEmpty) {
      final currentActiveClients =
          state.activeClients[state.activeCurrentPage - 1];
      final filteredActive = currentActiveClients.where((client) {
        return client.name.toLowerCase().contains(query.toLowerCase()) ||
            client.email.toLowerCase().contains(query.toLowerCase());
      }).toList();

      emit(state.copyWith(filteredActiveClients: filteredActive));
    }

    // Filter lost clients
    if (state.lostClients.isNotEmpty) {
      final currentLostClients = state.lostClients[state.lostCurrentPage - 1];
      final filteredLost = currentLostClients.where((client) {
        return client.name.toLowerCase().contains(query.toLowerCase()) ||
            client.email.toLowerCase().contains(query.toLowerCase());
      }).toList();

      emit(state.copyWith(filteredLostClients: filteredLost));
    }
  }

  // Update single client in the list (for optimized updates)
  void updateClientInList(ClientModel updatedClient) {
    // Update in active clients if it belongs there
    if (updatedClient.status == 'active' || updatedClient.status == 'trial') {
      final updatedActiveClients = List<List<ClientModel>>.from(
        state.activeClients,
      );
      for (int i = 0; i < updatedActiveClients.length; i++) {
        final pageClients = List<ClientModel>.from(updatedActiveClients[i]);
        final index = pageClients.indexWhere(
          (c) => c.docId == updatedClient.docId,
        );
        if (index != -1) {
          pageClients[index] = updatedClient;
          updatedActiveClients[i] = pageClients;
          break;
        }
      }

      // Update filtered list if it's the current page
      final currentPageIndex = state.activeCurrentPage - 1;
      final updatedFilteredActive =
          currentPageIndex < updatedActiveClients.length
          ? updatedActiveClients[currentPageIndex]
          : state.filteredActiveClients;

      emit(
        state.copyWith(
          activeClients: updatedActiveClients,
          filteredActiveClients: updatedFilteredActive,
        ),
      );
    }

    // Update in lost clients if it belongs there
    if (['churned', 'inactive', 'suspended'].contains(updatedClient.status)) {
      final updatedLostClients = List<List<ClientModel>>.from(
        state.lostClients,
      );
      for (int i = 0; i < updatedLostClients.length; i++) {
        final pageClients = List<ClientModel>.from(updatedLostClients[i]);
        final index = pageClients.indexWhere(
          (c) => c.docId == updatedClient.docId,
        );
        if (index != -1) {
          pageClients[index] = updatedClient;
          updatedLostClients[i] = pageClients;
          break;
        }
      }

      // Update filtered list if it's the current page
      final currentPageIndex = state.lostCurrentPage - 1;
      final updatedFilteredLost = currentPageIndex < updatedLostClients.length
          ? updatedLostClients[currentPageIndex]
          : state.filteredLostClients;

      emit(
        state.copyWith(
          lostClients: updatedLostClients,
          filteredLostClients: updatedFilteredLost,
        ),
      );
    }
  }

  // Add new client to the list (for optimized creation)
  void addClientToList(ClientModel newClient) {
    if (newClient.status == 'active' || newClient.status == 'trial') {
      // Add to active clients
      final updatedActiveClients = List<List<ClientModel>>.from(
        state.activeClients,
      );
      if (updatedActiveClients.isNotEmpty) {
        updatedActiveClients[0] = [newClient, ...updatedActiveClients[0]];

        // Update filtered list if showing first page
        final updatedFilteredActive = state.activeCurrentPage == 1
            ? updatedActiveClients[0]
            : state.filteredActiveClients;

        emit(
          state.copyWith(
            activeClients: updatedActiveClients,
            filteredActiveClients: updatedFilteredActive,
          ),
        );
      }
    } else if ([
      'churned',
      'inactive',
      'suspended',
    ].contains(newClient.status)) {
      // Add to lost clients
      final updatedLostClients = List<List<ClientModel>>.from(
        state.lostClients,
      );
      if (updatedLostClients.isNotEmpty) {
        updatedLostClients[0] = [newClient, ...updatedLostClients[0]];

        // Update filtered list if showing first page
        final updatedFilteredLost = state.lostCurrentPage == 1
            ? updatedLostClients[0]
            : state.filteredLostClients;

        emit(
          state.copyWith(
            lostClients: updatedLostClients,
            filteredLostClients: updatedFilteredLost,
          ),
        );
      }
    }
  }
 
  // 
}
