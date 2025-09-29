part of 'client_cubit.dart';

class ClientState extends Equatable {
  // Active clients pagination
  final List<List<ClientModel>> activeClients;
  final List<ClientModel> filteredActiveClients;
  final int activeCurrentPage;
  final int activeTotalPages;
  final DocumentSnapshot? activeLastFetchedDoc;

  // Lost clients pagination
  final List<List<ClientModel>> lostClients;
  final List<ClientModel> filteredLostClients;
  final int lostCurrentPage;
  final int lostTotalPages;
  final DocumentSnapshot? lostLastFetchedDoc;

  // Common state
  final bool isLoading;
  final String? message;
  final Map<String, int>? stats;
  final String searchQuery;
  final ClientTab selectedTab;

  ClientState({
    required this.activeClients,
    required this.filteredActiveClients,
    required this.activeCurrentPage,
    required this.activeTotalPages,
    this.activeLastFetchedDoc,
    required this.lostClients,
    required this.filteredLostClients,
    required this.lostCurrentPage,
    required this.lostTotalPages,
    this.lostLastFetchedDoc,
    required this.isLoading,
    this.message,
    this.stats,
    required this.searchQuery,
    required this.selectedTab,
  });

  // Initial state
  factory ClientState.initial() {
    return ClientState(
      activeClients: [],
      filteredActiveClients: [],
      activeCurrentPage: 1,
      activeTotalPages: 1,
      activeLastFetchedDoc: null,
      lostClients: [],
      filteredLostClients: [],
      lostCurrentPage: 1,
      lostTotalPages: 1,
      lostLastFetchedDoc: null,
      isLoading: false,
      message: null,
      stats: null,
      searchQuery: '',
      selectedTab: ClientTab.active,
    );
  }
  // Copy with method to update state
  ClientState copyWith({
    List<List<ClientModel>>? activeClients,
    List<ClientModel>? filteredActiveClients,
    int? activeCurrentPage,
    int? activeTotalPages,
    DocumentSnapshot? activeLastFetchedDoc,
    List<List<ClientModel>>? lostClients,
    List<ClientModel>? filteredLostClients,
    int? lostCurrentPage,
    int? lostTotalPages,
    DocumentSnapshot? lostLastFetchedDoc,
    bool? isLoading,
    String? message,
    Map<String, int>? stats,
    String? searchQuery,
    ClientTab? selectedTab,
  }) {
    return ClientState(
      activeClients: activeClients ?? this.activeClients,
      filteredActiveClients:
          filteredActiveClients ?? this.filteredActiveClients,
      activeCurrentPage: activeCurrentPage ?? this.activeCurrentPage,
      activeTotalPages: activeTotalPages ?? this.activeTotalPages,
      activeLastFetchedDoc: activeLastFetchedDoc ?? this.activeLastFetchedDoc,
      lostClients: lostClients ?? this.lostClients,
      filteredLostClients: filteredLostClients ?? this.filteredLostClients,
      lostCurrentPage: lostCurrentPage ?? this.lostCurrentPage,
      lostTotalPages: lostTotalPages ?? this.lostTotalPages,
      lostLastFetchedDoc: lostLastFetchedDoc ?? this.lostLastFetchedDoc,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      stats: stats ?? this.stats,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  List<Object?> get props => [
    activeClients,
    filteredActiveClients,
    activeCurrentPage,
    activeTotalPages,
    lostClients,
    filteredLostClients,
    lostCurrentPage,
    lostTotalPages,
    isLoading,
    message,
    stats,
    searchQuery,
    selectedTab,
  ];
}
