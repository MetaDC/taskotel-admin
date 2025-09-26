part of 'mastertask_cubit.dart';

class MasterTaskState extends Equatable {
  final bool isLoading;
  final String currentHotelId;
  final String selectedRole;
  final String selectedDepartment;
  final String searchQuery;
  final List<MasterTaskModel> allTasks;
  final Map<String, List<MasterTaskModel>> tasksByRole;
  final List<MasterTaskModel> filteredTasks;
  final String? message;
  final Map<String, dynamic>? analytics;

  const MasterTaskState({
    required this.isLoading,
    required this.currentHotelId,
    required this.selectedRole,
    required this.selectedDepartment,
    required this.searchQuery,
    required this.allTasks,
    required this.tasksByRole,
    required this.filteredTasks,
    this.message,
    this.analytics,
  });

  factory MasterTaskState.initial() {
    return const MasterTaskState(
      isLoading: false,
      currentHotelId: '',
      selectedRole: 'rm', // Default to Regional Manager
      selectedDepartment: 'All Departments',
      searchQuery: '',
      allTasks: [],
      tasksByRole: {},
      filteredTasks: [],
      message: null,
      analytics: null,
    );
  }

  MasterTaskState copyWith({
    bool? isLoading,
    String? currentHotelId,
    String? selectedRole,
    String? selectedDepartment,
    String? searchQuery,
    List<MasterTaskModel>? allTasks,
    Map<String, List<MasterTaskModel>>? tasksByRole,
    List<MasterTaskModel>? filteredTasks,
    String? message,
    Map<String, dynamic>? analytics,
  }) {
    return MasterTaskState(
      isLoading: isLoading ?? this.isLoading,
      currentHotelId: currentHotelId ?? this.currentHotelId,
      selectedRole: selectedRole ?? this.selectedRole,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      searchQuery: searchQuery ?? this.searchQuery,
      allTasks: allTasks ?? this.allTasks,
      tasksByRole: tasksByRole ?? this.tasksByRole,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      message: message,
      analytics: analytics ?? this.analytics,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    currentHotelId,
    selectedRole,
    selectedDepartment,
    searchQuery,
    allTasks,
    tasksByRole,
    filteredTasks,
    message,
    analytics,
  ];
}
