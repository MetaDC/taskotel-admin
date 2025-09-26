import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hotel_model.dart';
import 'package:taskoteladmin/features/clients/domain/repo/client_repo.dart';

part 'client_detail_state.dart';

enum RoleTab { regionalManager, generalManager, departmentManager, operators }

class ClientDetailCubit extends Cubit<ClientDetailState> {
  final ClientRepo clientRepo;

  ClientDetailCubit({required this.clientRepo})
    : super(ClientDetailState.initial());

  void loadClientDetails(String clientId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final client = await clientRepo.getClient(clientId);
      final hotels = await clientRepo.getClientHotels(clientId);
      print("Client loaded: ${client.name}");
      emit(state.copyWith(client: client, hotels: hotels, isLoading: false));
      print("Client loaded: ${state.client?.docId}--${hotels.length}");
    } catch (e) {
      emit(state.copyWith(isLoading: false, message: e.toString()));
    }
  }

  void loadHotelDetails(String hotelId) async {
    print("Load Hotel Detail for ID: $hotelId");
    try {
      // Find hotel from already loaded hotels list
      final hotel = state.hotels
          .where((hotel) => hotel.docId == hotelId)
          .firstOrNull;

      if (hotel != null) {
        print("Hotel found in existing data: ${hotel.name}");
        emit(state.copyWith(hotelDetail: hotel));
      } else {
        print("Hotel not found in loaded hotels list");
        emit(state.copyWith(message: "Hotel not found"));
      }
    } catch (e) {
      print("Error loading hotel details: ${e.toString()}");
      emit(state.copyWith(message: e.toString()));
    }
  }

  // Tab management methods
  void switchTab(RoleTab tab) {
    if (state.selectedTab != tab) {
      emit(state.copyWith(selectedTab: tab, isLoadingTasks: true));
      _loadTasksForTab(tab);
    }
  }

  void _loadTasksForTab(RoleTab tab) async {
    // Simulate loading tasks for different roles
    await Future.delayed(const Duration(milliseconds: 500));

    List<TaskModel2> tasks = _getTasksForRole(tab);
    emit(state.copyWith(tasks: tasks, isLoadingTasks: false));
  }

  List<TaskModel2> _getTasksForRole(RoleTab role) {
    switch (role) {
      case RoleTab.regionalManager:
        return [
          TaskModel2(
            id: "RM001",
            title: "Monthly Revenue Review",
            description: "Review regional performance metrics and KPIs",
            frequency: "Monthly",
            priority: "High",
            estimatedTime: "2 hours",
            status: "created",
            isActive: true,
          ),
          TaskModel2(
            id: "RM002",
            title: "Staff Performance Evaluation",
            description: "Evaluate department heads performance quarterly",
            frequency: "Quarterly",
            priority: "Medium",
            estimatedTime: "3 hours",
            status: "imported",
            isActive: false,
          ),
          TaskModel2(
            id: "RM003",
            title: "Budget Planning",
            description: "Plan annual budget for the region",
            frequency: "Yearly",
            priority: "High",
            estimatedTime: "4 hours",
            status: "created",
            isActive: true,
          ),
        ];

      case RoleTab.generalManager:
        return [
          TaskModel2(
            id: "GM001",
            title: "Daily Operations Review",
            description: "Review daily hotel operations and guest feedback",
            frequency: "Daily",
            priority: "High",
            estimatedTime: "1 hour",
            status: "created",
            isActive: true,
          ),
          TaskModel2(
            id: "GM002",
            title: "Weekly Team Meeting",
            description: "Conduct weekly meeting with department heads",
            frequency: "Weekly",
            priority: "Medium",
            estimatedTime: "2 hours",
            status: "imported",
            isActive: true,
          ),
        ];

      case RoleTab.departmentManager:
        return [
          TaskModel2(
            id: "DM001",
            title: "Housekeeping Inspection",
            description: "Daily inspection of room cleaning standards",
            frequency: "Daily",
            priority: "High",
            estimatedTime: "30 minutes",
            status: "created",
            isActive: true,
          ),
          TaskModel2(
            id: "DM002",
            title: "Staff Scheduling",
            description: "Create weekly work schedules for department staff",
            frequency: "Weekly",
            priority: "Medium",
            estimatedTime: "1 hour",
            status: "imported",
            isActive: true,
          ),
        ];

      case RoleTab.operators:
        return [
          TaskModel2(
            id: "OP001",
            title: "Room Cleaning",
            description: "Clean and prepare guest rooms according to standards",
            frequency: "Daily",
            priority: "High",
            estimatedTime: "45 minutes",
            status: "created",
            isActive: true,
          ),
          TaskModel2(
            id: "OP002",
            title: "Guest Check-in",
            description: "Process guest arrivals and room assignments",
            frequency: "As needed",
            priority: "High",
            estimatedTime: "15 minutes",
            status: "imported",
            isActive: true,
          ),
        ];
    }
  }

  void searchTasks(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void toggleTaskStatus(String taskId) {
    final updatedTasks = state.tasks.map((task) {
      if (task.id == taskId) {
        return task.copyWith(isActive: !task.isActive);
      }
      return task;
    }).toList();

    emit(state.copyWith(tasks: updatedTasks));
  }

  void deleteTask(String taskId) {
    final updatedTasks = state.tasks
        .where((task) => task.id != taskId)
        .toList();
    emit(state.copyWith(tasks: updatedTasks));
  }
}

// Task model for demo purposes
class TaskModel2 extends Equatable {
  final String id;
  final String title;
  final String description;
  final String frequency;
  final String priority;
  final String estimatedTime;
  final String status;
  final bool isActive;

  const TaskModel2({
    required this.id,
    required this.title,
    required this.description,
    required this.frequency,
    required this.priority,
    required this.estimatedTime,
    required this.status,
    required this.isActive,
  });

  TaskModel2 copyWith({
    String? id,
    String? title,
    String? description,
    String? frequency,
    String? priority,
    String? estimatedTime,
    String? status,
    bool? isActive,
  }) {
    return TaskModel2(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      priority: priority ?? this.priority,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    frequency,
    priority,
    estimatedTime,
    status,
    isActive,
  ];
}
