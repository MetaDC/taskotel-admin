part of 'client_cubit.dart';

class ClientState extends Equatable {
  final List<List<ClientModel>> clients;
  final List<ClientModel> filteredClients;
  final Map<String, int>? stats;
  final int currentPage;
  final int totalPages;
  final bool isLoading;
  final String? message;
  DocumentSnapshot? lastFetchedDoc;

  ClientState({
    required this.lastFetchedDoc,
    required this.clients,
    required this.filteredClients,
    required this.currentPage,
    required this.totalPages,
    required this.isLoading,
    this.message,
    this.stats,
  });

  // Initial state
  factory ClientState.initial() {
    return ClientState(
      lastFetchedDoc: null,
      filteredClients: [],
      isLoading: false,
      clients: [],
      currentPage: 1,
      totalPages: 1,
      message: null,
      stats: null,
    );
  }
  // Copy with method to update state
  ClientState copyWith({
    bool? isLoading,
    String? message,
    List<List<ClientModel>>? clients,
    Map<String, int>? stats,
    int? currentPage,
    int? totalPages,
    List<ClientModel>? filteredClients,
    DocumentSnapshot? lastFetchedDoc,
  }) {
    return ClientState(
      lastFetchedDoc: lastFetchedDoc ?? this.lastFetchedDoc,
      filteredClients: filteredClients ?? this.filteredClients,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      clients: clients ?? this.clients,
      stats: stats ?? this.stats,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object?> get props => [
    filteredClients,
    isLoading,
    message,
    clients,
    stats,
    currentPage,
    totalPages,
  ];
}
