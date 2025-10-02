part of 'masterhotel_task_cubit.dart';

class MasterhotelTaskState {
  final MasterHotelModel? hotelDetail;
  final bool isLoading;
  final bool isLoadingTasks;
  final String? message;
  final String selectedTab;
  final List<CommonTaskModel> allTasks;
  final List<CommonTaskModel> filteredTasks; // Keep all tasks here
  final String searchQuery;

  const MasterhotelTaskState({
    required this.hotelDetail,
    required this.isLoading,
    required this.isLoadingTasks,
    this.message,
    required this.selectedTab,
    required this.allTasks,
    required this.searchQuery,
    required this.filteredTasks,
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
      filteredTasks: [],
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
    List<CommonTaskModel>? filteredTasks,
  }) {
    return MasterhotelTaskState(
      hotelDetail: hotelDetail ?? this.hotelDetail,
      isLoading: isLoading ?? this.isLoading,
      isLoadingTasks: isLoadingTasks ?? this.isLoadingTasks,
      message: message ?? this.message,
      selectedTab: selectedTab ?? this.selectedTab,
      allTasks: allTasks ?? this.allTasks,
      searchQuery: searchQuery ?? this.searchQuery,
      filteredTasks: filteredTasks ?? this.filteredTasks,
    );
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
}
