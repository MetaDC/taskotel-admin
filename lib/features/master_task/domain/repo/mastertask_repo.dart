import 'package:taskoteladmin/features/master_task/domain/model/mastertask_model.dart';

abstract class MasterTaskRepo {
  // Stream methods
  Stream<List<MasterTaskModel>> getTasksByRoleStream(
    String role,
    String hotelId,
  );
  Stream<List<MasterTaskModel>> getAllTasksStream(String hotelId);

  // CRUD operations
  Future<void> createTask(MasterTaskModel task);
  Future<void> updateTask(MasterTaskModel task);
  Future<void> deleteTask(String taskId);

  // Task management
  Future<void> toggleTaskStatus(String taskId, bool isActive);
  Future<List<MasterTaskModel>> searchTasks(String query, String hotelId);
  Future<List<MasterTaskModel>> getTasksByRole(String role, String hotelId);

  // Excel import/export
  Future<void> importTasksFromExcel(
    List<Map<String, dynamic>> tasksData,
    String hotelId,
    String userCategory,
  );
  Future<List<MasterTaskModel>> getTasksForExport(String hotelId, String role);

  // Analytics
  Future<Map<String, dynamic>> getTaskAnalytics(String hotelId);
}
