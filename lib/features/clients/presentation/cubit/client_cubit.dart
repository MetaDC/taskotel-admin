import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/clients/domain/entity/%20analytics_models.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/domain/repo/client_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/features/clients/presentation/page/clients_page.dart';

part 'client_state.dart';

class ClientCubit extends Cubit<ClientState> {
  final ClientRepo clientRepo;
  static const int _pageSize = 10;

  ClientCubit({required this.clientRepo}) : super(ClientState.initial());
  final searchController = TextEditingController();
  Timer? debounce;

  // Fetch active clients page
  Future<void> fetchActiveClientsPage() async {
    try {
      int pageZeroIndex = state.activeCurrentPage - 1;

      // Check if we already have this page
      if (pageZeroIndex < state.activeClients.length &&
          state.activeClients[pageZeroIndex].isNotEmpty) {
        return;
      }

      Query query = FBFireStore.clients
          .where('status', whereIn: ['active', 'trial'])
          .orderBy('lastPaymentExpiry', descending: true)
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

        // Update total pages based on whether we have more data
        int newTotalPages = state.activeTotalPages;
        if (snap.docs.length == _pageSize) {
          // If we got a full page, there might be more pages
          newTotalPages = state.activeCurrentPage + 1;
        } else {
          // If we got less than a full page, this is the last page
          newTotalPages = state.activeCurrentPage;
        }

        emit(
          state.copyWith(
            activeClients: updatedActiveClients,
            activeLastFetchedDoc: newActiveLastFetchedDoc,
            activeTotalPages: newTotalPages,
          ),
        );
        // print(
        //   "Active clients fetched: ${state.activeClients.length} -- ${state.activeClients[pageZeroIndex]}",
        // );
      } else {
        // No more data, current page is the last page
        emit(state.copyWith(activeTotalPages: state.activeCurrentPage - 1));
      }
    } on Exception catch (e) {
      print('Error fetching active clients page: $e');
    }
  }

  // Fetch lost clients page
  Future<void> fetchLostClientsPage() async {
    try {
      int pageZeroIndex = state.lostCurrentPage - 1;

      // Check if we already have this page
      if (pageZeroIndex < state.lostClients.length &&
          state.lostClients[pageZeroIndex].isNotEmpty) {
        return;
      }

      Query query = FBFireStore.clients
          .where('status', whereIn: ['churned', 'inactive', 'suspended'])
          .orderBy('lastPaymentExpiry', descending: true)
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

        // Update total pages based on whether we have more data
        int newTotalPages = state.lostTotalPages;
        if (snap.docs.length == _pageSize) {
          // If we got a full page, there might be more pages
          newTotalPages = state.lostCurrentPage + 1;
        } else {
          // If we got less than a full page, this is the last page
          newTotalPages = state.lostCurrentPage;
        }

        emit(
          state.copyWith(
            lostClients: updatedLostClients,
            lostLastFetchedDoc: newLostLastFetchedDoc,
            lostTotalPages: newTotalPages,
          ),
        );
      } else {
        // No more data, current page is the last page
        emit(state.copyWith(lostTotalPages: state.lostCurrentPage - 1));
      }
    } on Exception catch (e) {
      print('Error fetching lost clients page: $e');
    }
  }

  // Initialize active clients pagination
  Future<void> initializeActiveClientsPagination() async {
    // Don't re-initialize if we already have data and we're on the active tab
    if (state.activeClients.isNotEmpty &&
        state.selectedTab == ClientTab.active) {
      // Just update the filtered clients to show the current page
      final currentPageIndex = state.activeCurrentPage - 1;
      if (currentPageIndex < state.activeClients.length) {
        emit(
          state.copyWith(
            filteredActiveClients: state.activeClients[currentPageIndex],
            isLoading: false,
          ),
        );
      }
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        activeClients: [],
        filteredActiveClients: [],
        activeLastFetchedDoc: null,
        activeCurrentPage: 1,
        activeTotalPages: 1, // Start with 1, will update as we paginate
        message: null, // Clear any previous error messages
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
    // Don't re-initialize if we already have data and we're on the lost tab
    if (state.lostClients.isNotEmpty && state.selectedTab == ClientTab.lost) {
      // Just update the filtered clients to show the current page
      final currentPageIndex = state.lostCurrentPage - 1;
      if (currentPageIndex < state.lostClients.length) {
        emit(
          state.copyWith(
            filteredLostClients: state.lostClients[currentPageIndex],
            isLoading: false,
          ),
        );
      }
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        lostClients: [],
        filteredLostClients: [],
        lostLastFetchedDoc: null,
        lostCurrentPage: 1,
        lostTotalPages: 1, // Start with 1, will update as we paginate
        message: null, // Clear any previous error messages
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
    if (debounce?.isActive ?? false) debounce?.cancel();
    emit(state.copyWith(searchQuery: query));
    // Filter active clients

    debounce = Timer(const Duration(milliseconds: 500), () {
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
    });
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

      //remove

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

  //update clinet list on delete
  void removeClientFromList(String clientId) {
    // Remove from active clients if it belongs there
    final updatedActiveClients = List<List<ClientModel>>.from(
      state.activeClients,
    );
    for (int i = 0; i < updatedActiveClients.length; i++) {
      final pageClients = List<ClientModel>.from(updatedActiveClients[i]);
      pageClients.removeWhere((c) => c.docId == clientId);
      updatedActiveClients[i] = pageClients;
    }

    // Remove from lost clients if it belongs there
    final updatedLostClients = List<List<ClientModel>>.from(state.lostClients);
    for (int i = 0; i < updatedLostClients.length; i++) {
      final pageClients = List<ClientModel>.from(updatedLostClients[i]);
      pageClients.removeWhere((c) => c.docId == clientId);
      updatedLostClients[i] = pageClients;
    }

    emit(
      state.copyWith(
        activeClients: updatedActiveClients,
        lostClients: updatedLostClients,
      ),
    );
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

  // Tab management methods - FIXED VERSION
  void switchTab(ClientTab tab) {
    if (state.selectedTab != tab) {
      // Only update the selected tab and clear error messages
      // Don't clear the cached data or reset pagination
      searchController.clear();
      emit(
        state.copyWith(
          selectedTab: tab,
          message: null, // Clear any error messages
          searchQuery: '', // Clear search when switching tabs
        ),
      );

      // Update the filtered lists based on current page for the selected tab
      if (tab == ClientTab.active && state.activeClients.isNotEmpty) {
        final currentPageIndex = state.activeCurrentPage - 1;
        if (currentPageIndex < state.activeClients.length) {
          emit(
            state.copyWith(
              filteredActiveClients: state.activeClients[currentPageIndex],
            ),
          );
        }
      } else if (tab == ClientTab.lost && state.lostClients.isNotEmpty) {
        final currentPageIndex = state.lostCurrentPage - 1;
        if (currentPageIndex < state.lostClients.length) {
          emit(
            state.copyWith(
              filteredLostClients: state.lostClients[currentPageIndex],
            ),
          );
        }
      }
    }
  }

  // Helper methods to check if data needs to be loaded
  bool get shouldLoadActiveClients {
    return state.activeClients.isEmpty && state.selectedTab == ClientTab.active;
  }

  bool get shouldLoadLostClients {
    return state.lostClients.isEmpty && state.selectedTab == ClientTab.lost;
  }

  // Method to refresh current tab data (useful for pull-to-refresh)
  Future<void> refreshCurrentTab() async {
    if (state.selectedTab == ClientTab.active) {
      emit(
        state.copyWith(
          activeClients: [],
          activeLastFetchedDoc: null,
          activeCurrentPage: 1,
        ),
      );
      await initializeActiveClientsPagination();
    } else {
      emit(
        state.copyWith(
          lostClients: [],
          lostLastFetchedDoc: null,
          lostCurrentPage: 1,
        ),
      );
      await initializeLostClientsPagination();
    }
  }

  // Optional: Get total count only when needed (e.g., for analytics)
  Future<int> getTotalActiveClientsCount() async {
    try {
      final userCountSnap = await FBFireStore.clients
          .where('status', whereIn: ['active', 'trial'])
          .count()
          .get();
      return userCountSnap.count ?? 0;
    } catch (e) {
      print('Error getting total active clients count: $e');
      return 0;
    }
  }

  // Optional: Get total count only when needed (e.g., for analytics)
  Future<int> getTotalLostClientsCount() async {
    try {
      final userCountSnap = await FBFireStore.clients
          .where('status', whereIn: ['churned', 'inactive', 'suspended'])
          .count()
          .get();
      return userCountSnap.count ?? 0;
    } catch (e) {
      print('Error getting total lost clients count: $e');
      return 0;
    }
  }

  Future<int> getTotalHotelsCount() async {
    try {
      final hotelCountSnap = await FBFireStore.hotels.count().get();
      return hotelCountSnap.count ?? 0;
    } catch (e) {
      print('Error getting total hotels count: $e');
      return 0;
    }
  }

  //delete client
  void deleteClient(String clientId) async {
    emit(state.copyWith(isLoading: true, message: null));
    await clientRepo.deleteClient(clientId);
    removeClientFromList(clientId);
    emit(state.copyWith(isLoading: false, message: "Client Deleted"));
  }

  void getClientsAnalytics() async {
    final activeClients = await getTotalActiveClientsCount();
    final lostClients = await getTotalLostClientsCount();
    final totalHotels = await getTotalHotelsCount();
    // final totalRevenue = await getTotalRevenue();

    final analytics = ClientListAnalytics(
      totalClients: activeClients + lostClients,
      activeClients: activeClients,
      totalHotels: totalHotels,
      totalRevenue: 0.0,
      lostClients: lostClients,
    );

    emit(state.copyWith(stats: analytics));
  }
}
