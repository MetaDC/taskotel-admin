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

  // Set current hotel ID
  void setHotelId(String hotelId) {
    emit(state.copyWith(currentHotelId: hotelId));
  }

  // Load tasks by role
  Future<void> loadTasksByRole(String role, String hotelId) async {
    emit(
      state.copyWith(
        isLoading: true,
        selectedRole: role,
        currentHotelId: hotelId,
      ),
    );
    _taskStream?.cancel();

    try {
      _taskStream = masterTaskRepo
          .getTasksByRoleStream(role, hotelId)
          .listen(
            (tasks) {
              final updatedTasksByRole =
                  Map<String, List<MasterTaskModel>>.from(state.tasksByRole);
              updatedTasksByRole[role] = tasks;

              emit(
                state.copyWith(
                  tasksByRole: updatedTasksByRole,
                  filteredTasks: _applyFilters(tasks),
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

  // Load all tasks for a hotel
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
              for (final task in tasks) {
                if (!tasksByRole.containsKey(task.assignedRole)) {
                  tasksByRole[task.assignedRole] = [];
                }
                tasksByRole[task.assignedRole]!.add(task);
              }

              emit(
                state.copyWith(
                  allTasks: tasks,
                  tasksByRole: tasksByRole,
                  filteredTasks: _applyFilters(
                    tasksByRole[state.selectedRole] ?? [],
                  ),
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

    // Load tasks for this role if not already loaded
    if (currentTasks.isEmpty && state.currentHotelId.isNotEmpty) {
      loadTasksByRole(role, state.currentHotelId);
    }
  }

  // Load analytics
  Future<void> loadAnalytics() async {
    if (state.currentHotelId.isEmpty) return;

    try {
      final analytics = await masterTaskRepo.getTaskAnalytics(
        state.currentHotelId,
      );
      emit(state.copyWith(analytics: analytics));
    } catch (e) {
      emit(state.copyWith(message: 'Failed to load analytics: $e'));
    }
  }

  // Clear message
  void clearMessage() {
    emit(state.copyWith(message: null));
  }

  // Change department filter
  void changeDepartment(String department) {
    emit(state.copyWith(selectedDepartment: department));
    final currentTasks = state.tasksByRole[state.selectedRole] ?? [];
    final filteredTasks = _applyFilters(currentTasks);
    emit(state.copyWith(filteredTasks: filteredTasks));
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
