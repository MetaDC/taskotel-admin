// ClientDetailState
part of 'client_detail_cubit.dart';

class ClientDetailState {
  final ClientModel? client;
  final List<HotelModel> hotels;
  final HotelModel? hotelDetail;
  final bool isLoading;
  final bool isLoadingTasks;
  final String? message;
  final RoleTab selectedTab;
  final List<CommonTaskModel> allTasks; // Keep all tasks here
  final String searchQuery;
  final ClientDetailAnalytics? clientAnalytics;
  final HotelDetailAnalytics? hotelAnalytics;

  const ClientDetailState({
    required this.client,
    required this.hotels,
    required this.hotelDetail,
    required this.isLoading,
    required this.isLoadingTasks,
    this.message,
    required this.selectedTab,
    required this.allTasks,
    required this.searchQuery,
    this.clientAnalytics,
    this.hotelAnalytics,
  });

  factory ClientDetailState.initial() {
    return const ClientDetailState(
      client: null,
      hotelDetail: null,
      hotels: [],
      isLoading: false,
      isLoadingTasks: false,
      message: null,
      selectedTab: RoleTab.regionalManager,
      allTasks: [],
      searchQuery: '',
      clientAnalytics: null,
      hotelAnalytics: null,
    );
  }

  ClientDetailState copyWith({
    ClientModel? client,
    List<HotelModel>? hotels,
    HotelModel? hotelDetail,
    bool? isLoading,
    bool? isLoadingTasks,
    String? message,
    RoleTab? selectedTab,
    List<CommonTaskModel>? allTasks,
    String? searchQuery,
    ClientDetailAnalytics? clientAnalytics,
    HotelDetailAnalytics? hotelAnalytics,
  }) {
    return ClientDetailState(
      client: client ?? this.client,
      hotels: hotels ?? this.hotels,
      hotelDetail: hotelDetail ?? this.hotelDetail,
      isLoading: isLoading ?? this.isLoading,
      isLoadingTasks: isLoadingTasks ?? this.isLoadingTasks,
      message: message ?? this.message,
      selectedTab: selectedTab ?? this.selectedTab,
      allTasks: allTasks ?? this.allTasks,
      searchQuery: searchQuery ?? this.searchQuery,
      clientAnalytics: clientAnalytics ?? this.clientAnalytics,
      hotelAnalytics: hotelAnalytics ?? this.hotelAnalytics,
    );
  }

  // Get tasks for current role
  List<CommonTaskModel> get currentRoleTasks {
    List<CommonTaskModel> roleTasks;
    switch (selectedTab) {
      case RoleTab.regionalManager:
        roleTasks = allTasks
            .where((task) => task.assignedRole == "rm")
            .toList();
        break;
      case RoleTab.generalManager:
        roleTasks = allTasks
            .where((task) => task.assignedRole == "gm")
            .toList();
        break;
      case RoleTab.departmentManager:
        roleTasks = allTasks
            .where((task) => task.assignedRole == "dm")
            .toList();
        break;
      case RoleTab.operators:
        roleTasks = allTasks
            .where((task) => task.assignedRole == "staff")
            .toList();
        break;
    }

    return roleTasks;
  }

  // Filtered tasks based on current role and search query
  List<CommonTaskModel> get filteredTasks {
    final roleTasks = currentRoleTasks;

    if (searchQuery.isEmpty) return roleTasks;

    final filtered = roleTasks.where((task) {
      return task.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          task.desc.toLowerCase().contains(searchQuery.toLowerCase()) ||
          task.docId.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return filtered;
  }

  // Get tab display name
  String getTabDisplayName(RoleTab tab) {
    switch (tab) {
      case RoleTab.regionalManager:
        return "Regional Manager";
      case RoleTab.generalManager:
        return "General Manager";
      case RoleTab.departmentManager:
        return "Department Manager";
      case RoleTab.operators:
        return "Operators";
    }
  }
}
