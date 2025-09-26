import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskoteladmin/features/master_task/domain/model/mastertask_model.dart';
import 'package:taskoteladmin/features/master_task/domain/repo/mastertask_repo.dart';

part 'mastertask_state.dart';

class MasterTaskCubit extends Cubit<MasterTaskState> {
  final MasterTaskRepo masterTaskRepo;
  StreamSubscription<List<MasterTaskModel>>? _taskStream;

  MasterTaskCubit({required this.masterTaskRepo})
    : super(MasterTaskState.initial());

  @override
  Future<void> close() {
    _taskStream?.cancel();
    return super.close();
  }

  // Load all tasks for a hotel and initialize with first role
  Future<void> loadAllTasks(String hotelId) async {
    emit(state.copyWith(isLoading: true, currentHotelId: hotelId));
    _taskStream?.cancel();

    try {
      _taskStream = masterTaskRepo
          .getAllTasksStream(hotelId)
          .listen(
            (tasks) {
              // Group tasks by role
              final tasksByRole = <String, List<MasterTaskModel>>{};

              // Initialize all roles with empty lists
              for (final role in ['rm', 'gm', 'dm', 'operator']) {
                tasksByRole[role] = [];
              }

              // Group actual tasks by role
              for (final task in tasks) {
                if (tasksByRole.containsKey(task.assignedRole)) {
                  tasksByRole[task.assignedRole]!.add(task);
                }
              }

              // Get current role tasks (default to first role 'rm')
              final currentRoleTasks = tasksByRole[state.selectedRole] ?? [];
              final filteredTasks = _applyFilters(currentRoleTasks);

              emit(
                state.copyWith(
                  allTasks: tasks,
                  tasksByRole: tasksByRole,
                  filteredTasks: filteredTasks,
                  isLoading: false,
                ),
              );
            },
            onError: (error) {
              emit(
                state.copyWith(
                  isLoading: false,
                  message: 'Failed to load tasks: $error',
                ),
              );
            },
          );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, message: 'Failed to load tasks: $e'),
      );
    }
  }

  // Create task
  Future<void> createTask(MasterTaskModel task) async {
    try {
      emit(state.copyWith(isLoading: true));
      await masterTaskRepo.createTask(task);
      emit(
        state.copyWith(isLoading: false, message: 'Task created successfully'),
      );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, message: 'Failed to create task: $e'),
      );
    }
  }

  // Update task
  Future<void> updateTask(MasterTaskModel task) async {
    try {
      emit(state.copyWith(isLoading: true));
      await masterTaskRepo.updateTask(task);
      emit(
        state.copyWith(isLoading: false, message: 'Task updated successfully'),
      );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, message: 'Failed to update task: $e'),
      );
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      emit(state.copyWith(isLoading: true));
      await masterTaskRepo.deleteTask(taskId);
      emit(
        state.copyWith(isLoading: false, message: 'Task deleted successfully'),
      );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, message: 'Failed to delete task: $e'),
      );
    }
  }

  // Toggle task status
  Future<void> toggleTaskStatus(String taskId, bool isActive) async {
    try {
      await masterTaskRepo.toggleTaskStatus(taskId, isActive);
      emit(state.copyWith(message: 'Task status updated successfully'));
    } catch (e) {
      emit(state.copyWith(message: 'Failed to update task status: $e'));
    }
  }

  // Import tasks from Excel
  Future<void> importTasksFromExcel(
    List<Map<String, dynamic>> tasksData,
    String userCategory,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await masterTaskRepo.importTasksFromExcel(
        tasksData,
        state.currentHotelId,
        userCategory,
      );
      emit(
        state.copyWith(
          isLoading: false,
          message: 'Tasks imported successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, message: 'Failed to import tasks: $e'),
      );
    }
  }

  // Export tasks to Excel
  Future<List<MasterTaskModel>> exportTasksToExcel(String role) async {
    try {
      return await masterTaskRepo.getTasksForExport(state.currentHotelId, role);
    } catch (e) {
      emit(state.copyWith(message: 'Failed to export tasks: $e'));
      return [];
    }
  }

  // Search tasks
  void searchTasks(String query) {
    emit(state.copyWith(searchQuery: query));
    final currentTasks = state.tasksByRole[state.selectedRole] ?? [];
    final filteredTasks = _applyFilters(currentTasks);
    emit(state.copyWith(filteredTasks: filteredTasks));
  }

  // Change selected role
  void changeRole(String role) {
    emit(state.copyWith(selectedRole: role));
    final currentTasks = state.tasksByRole[role] ?? [];
    final filteredTasks = _applyFilters(currentTasks);
    emit(state.copyWith(filteredTasks: filteredTasks));
  }

  // Change department filter
  void changeDepartment(String department) {
    emit(state.copyWith(selectedDepartment: department));
    final currentTasks = state.tasksByRole[state.selectedRole] ?? [];
    final filteredTasks = _applyFilters(currentTasks);
    emit(state.copyWith(filteredTasks: filteredTasks));
  }

  // Clear message
  void clearMessage() {
    emit(state.copyWith(message: null));
  }

  // Apply filters helper method
  List<MasterTaskModel> _applyFilters(List<MasterTaskModel> tasks) {
    var filtered = tasks;

    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (task) =>
                task.title.toLowerCase().contains(
                  state.searchQuery.toLowerCase(),
                ) ||
                task.desc.toLowerCase().contains(
                  state.searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    // Apply department filter (only for Department Manager role)
    if (state.selectedRole == 'dm' &&
        state.selectedDepartment != 'All Departments') {
      filtered = filtered
          .where((task) => task.departmentId == state.selectedDepartment)
          .toList();
    }

    return filtered;
  }
}
