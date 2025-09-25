part of 'mastertask_cubit.dart';

class MasterTaskState extends Equatable {
  final bool isLoading;
  final List<MasterTaskModel> allTasks;
  final Map<String, List<MasterTaskModel>> tasksByRole;
  final List<MasterTaskModel> filteredTasks;
  final Map<String, dynamic>? analytics;
  final String? message;
  final String searchQuery;
  final String selectedRole;
  final String currentHotelId;
  final String selectedDepartment;

  const MasterTaskState({
    required this.isLoading,
    required this.allTasks,
    required this.tasksByRole,
    required this.filteredTasks,
    this.analytics,
    this.message,
    required this.searchQuery,
    required this.selectedRole,
    required this.currentHotelId,
    required this.selectedDepartment,
  });

  factory MasterTaskState.initial() {
    return const MasterTaskState(
      isLoading: false,
      allTasks: [],
      tasksByRole: {},
      filteredTasks: [],
      analytics: null,
      message: null,
      searchQuery: '',
      selectedRole: 'rm', // Regional Manager
      currentHotelId: '',
      selectedDepartment: 'All Departments',
    );
  }

  MasterTaskState copyWith({
    bool? isLoading,
    List<MasterTaskModel>? allTasks,
    Map<String, List<MasterTaskModel>>? tasksByRole,
    List<MasterTaskModel>? filteredTasks,
    Map<String, dynamic>? analytics,
    String? message,
    String? searchQuery,
    String? selectedRole,
    String? currentHotelId,
    String? selectedDepartment,
  }) {
    return MasterTaskState(
      isLoading: isLoading ?? this.isLoading,
      allTasks: allTasks ?? this.allTasks,
      tasksByRole: tasksByRole ?? this.tasksByRole,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      analytics: analytics ?? this.analytics,
      message: message ?? this.message,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedRole: selectedRole ?? this.selectedRole,
      currentHotelId: currentHotelId ?? this.currentHotelId,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    allTasks,
    tasksByRole,
    filteredTasks,
    analytics,
    message,
    searchQuery,
    selectedRole,
    currentHotelId,
    selectedDepartment,
  ];
}
