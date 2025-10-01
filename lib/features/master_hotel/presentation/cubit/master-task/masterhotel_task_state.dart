part of 'masterhotel_task_cubit.dart';

class MasterhotelTaskState extends Equatable {
  final MasterHotelModel? hotelDetail;
  final bool isLoading;
  final bool isLoadingTasks;
  final String? message;
  final String selectedTab;
  final List<CommonTaskModel> allTasks; // Keep all tasks here
  final String searchQuery;

  const MasterhotelTaskState({
    required this.hotelDetail,
    required this.isLoading,
    required this.isLoadingTasks,
    this.message,
    required this.selectedTab,
    required this.allTasks,
    required this.searchQuery,
  });

  factory MasterhotelTaskState.initial() {
    return const MasterhotelTaskState(
      hotelDetail: null,
      isLoading: false,
      isLoadingTasks: false,
      message: null,
      selectedTab: UserRoles.rm,
      allTasks: [],
      searchQuery: '',
    );
  }

  MasterhotelTaskState copyWith({
    MasterHotelModel? hotelDetail,
    bool? isLoading,
    bool? isLoadingTasks,
    String? message,
    String? selectedTab,
    List<CommonTaskModel>? allTasks,
    String? searchQuery,
  }) {
    return MasterhotelTaskState(
      hotelDetail: hotelDetail ?? this.hotelDetail,
      isLoading: isLoading ?? this.isLoading,
      isLoadingTasks: isLoadingTasks ?? this.isLoadingTasks,
      message: message ?? this.message,
      selectedTab: selectedTab ?? this.selectedTab,
      allTasks: allTasks ?? this.allTasks,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  // Get tasks for current role
  List<CommonTaskModel> get currentRoleTasks {
    List<CommonTaskModel> roleTasks = [];
    switch (selectedTab) {
      case UserRoles.rm:
        roleTasks = allTasks
            .where((task) => task.assignedRole == "rm")
            .toList();
        break;
      case UserRoles.gm:
        roleTasks = allTasks
            .where((task) => task.assignedRole == "gm")
            .toList();
        break;
      case UserRoles.dm:
        roleTasks = allTasks
            .where((task) => task.assignedRole == "dm")
            .toList();
        break;
      case UserRoles.operators:
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
  String getTabDisplayName(String tab) {
    switch (tab) {
      case UserRoles.rm:
        return "Regional Manager";
      case UserRoles.gm:
        return "General Manager";
      case UserRoles.dm:
        return "Department Manager";
      case UserRoles.operators:
        return "Operators";
    }
    return '';
  }

  @override
  List<Object?> get props => [
    hotelDetail,
    isLoading,
    isLoadingTasks,
    message,
    selectedTab,
    allTasks,
    searchQuery,
  ];
}
