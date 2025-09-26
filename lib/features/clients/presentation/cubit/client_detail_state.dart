part of 'client_detail_cubit.dart';

class ClientDetailState extends Equatable {
  final ClientModel? client;
  final List<HotelModel> hotels;
  final HotelModel? hotelDetail;
  final bool isLoading;
  final bool isLoadingTasks;
  final String? message;
  final RoleTab selectedTab;
  final List<TaskModel2> tasks;
  final String searchQuery;

  const ClientDetailState({
    required this.client,
    required this.hotels,
    required this.hotelDetail,
    required this.isLoading,
    required this.isLoadingTasks,
    this.message,
    required this.selectedTab,
    required this.tasks,
    required this.searchQuery,
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
      tasks: [],
      searchQuery: '',
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
    List<TaskModel2>? tasks,
    String? searchQuery,
  }) {
    return ClientDetailState(
      client: client ?? this.client,
      hotels: hotels ?? this.hotels,
      hotelDetail: hotelDetail ?? this.hotelDetail,
      isLoading: isLoading ?? this.isLoading,
      isLoadingTasks: isLoadingTasks ?? this.isLoadingTasks,
      message: message ?? this.message,
      selectedTab: selectedTab ?? this.selectedTab,
      tasks: tasks ?? this.tasks,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  // Filtered tasks based on search query
  List<TaskModel2> get filteredTasks {
    if (searchQuery.isEmpty) return tasks;

    return tasks.where((task) {
      return task.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
          task.id.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
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

  @override
  List<Object?> get props => [
    client,
    hotels,
    hotelDetail,
    isLoading,
    isLoadingTasks,
    message,
    selectedTab,
    tasks,
    searchQuery,
  ];
}
