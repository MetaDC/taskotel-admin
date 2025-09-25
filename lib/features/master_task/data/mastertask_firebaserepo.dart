import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/master_task/domain/model/mastertask_model.dart';
import 'package:taskoteladmin/features/master_task/domain/repo/mastertask_repo.dart';

class MasterTaskFirebaseRepo extends MasterTaskRepo {
  final masterTaskCollectionRef = FBFireStore.masterTasks;

  @override
  Stream<List<MasterTaskModel>> getTasksByRoleStream(
    String role,
    String hotelId,
  ) {
    return masterTaskCollectionRef
        .where('assignedRole', isEqualTo: role)
        .where('hotelId', isEqualTo: hotelId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs
              .map((doc) => MasterTaskModel.fromDocSnap(doc))
              .toList();
        });
  }

  @override
  Stream<List<MasterTaskModel>> getAllTasksStream(String hotelId) {
    return masterTaskCollectionRef
        .where('hotelId', isEqualTo: hotelId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs
              .map((doc) => MasterTaskModel.fromDocSnap(doc))
              .toList();
        });
  }

  @override
  Future<void> createTask(MasterTaskModel task) async {
    final taskData = task.toJson();
    taskData.remove('docId'); // Remove docId as it will be auto-generated
    taskData['createdAt'] = FieldValue.serverTimestamp();
    taskData['updatedAt'] = FieldValue.serverTimestamp();

    await masterTaskCollectionRef.add(taskData);
  }

  @override
  Future<void> updateTask(MasterTaskModel task) async {
    final taskData = task.toJson();
    taskData.remove('docId'); // Remove docId from update data
    taskData['updatedAt'] = FieldValue.serverTimestamp();

    await masterTaskCollectionRef.doc(task.docId).update(taskData);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await masterTaskCollectionRef.doc(taskId).update({
      'isActive': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> toggleTaskStatus(String taskId, bool isActive) async {
    await masterTaskCollectionRef.doc(taskId).update({
      'isActive': isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<MasterTaskModel>> searchTasks(
    String query,
    String hotelId,
  ) async {
    try {
      final querySnapshot = await masterTaskCollectionRef
          .where('hotelId', isEqualTo: hotelId)
          .where('isActive', isEqualTo: true)
          .get();

      final tasks = querySnapshot.docs
          .map((doc) => MasterTaskModel.fromDocSnap(doc))
          .toList();

      return tasks
          .where(
            (task) =>
                task.title.toLowerCase().contains(query.toLowerCase()) ||
                task.desc.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to search tasks: $e');
    }
  }

  @override
  Future<void> importTasksFromExcel(
    List<Map<String, dynamic>> tasksData,
    String hotelId,
    String userCategory,
  ) async {
    try {
      final batch = FirebaseFirestore.instance.batch();

      for (final taskData in tasksData) {
        final docRef = masterTaskCollectionRef.doc();

        final task = MasterTaskModel(
          docId: docRef.id,
          title: taskData['title'] ?? '',
          desc: taskData['description'] ?? '',
          createdAt: DateTime.now(),
          createdByDocId: 'admin', // TODO: Get from auth
          createdByName: 'Admin',
          updatedAt: DateTime.now(),
          updatedBy: 'admin',
          updatedByName: 'Admin',
          duration: taskData['duration'] ?? 30,
          place: taskData['place'],
          questions: [], // TODO: Parse questions from Excel
          departmentId: taskData['departmentId'] ?? '',
          hotelId: hotelId,
          assignedRole: userCategory,
          frequency: taskData['frequency'] ?? 'Daily',
          dayOrDate: taskData['dayOrDate'],
          isActive: true,
        );

        batch.set(docRef, task.toJson());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to import tasks: $e');
    }
  }

  @override
  Future<List<MasterTaskModel>> getTasksForExport(
    String hotelId,
    String role,
  ) async {
    try {
      final querySnapshot = await masterTaskCollectionRef
          .where('hotelId', isEqualTo: hotelId)
          .where('assignedRole', isEqualTo: role)
          .where('isActive', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => MasterTaskModel.fromDocSnap(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get tasks for export: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getTaskAnalytics(String hotelId) async {
    try {
      final querySnapshot = await masterTaskCollectionRef
          .where('hotelId', isEqualTo: hotelId)
          .get();

      final tasks = querySnapshot.docs
          .map((doc) => MasterTaskModel.fromDocSnap(doc))
          .toList();

      final totalTasks = tasks.length;
      final activeTasks = tasks.where((task) => task.isActive).length;
      final inactiveTasks = totalTasks - activeTasks;

      // Count by role
      final roleCount = <String, int>{};
      for (final task in tasks.where((t) => t.isActive)) {
        roleCount[task.assignedRole] = (roleCount[task.assignedRole] ?? 0) + 1;
      }

      // Count by frequency
      final frequencyCount = <String, int>{};
      for (final task in tasks.where((t) => t.isActive)) {
        frequencyCount[task.frequency] =
            (frequencyCount[task.frequency] ?? 0) + 1;
      }

      return {
        'totalTasks': totalTasks,
        'activeTasks': activeTasks,
        'inactiveTasks': inactiveTasks,
        'roleCount': roleCount,
        'frequencyCount': frequencyCount,
      };
    } catch (e) {
      throw Exception('Failed to get task analytics: $e');
    }
  }

  @override
  Future<List<MasterTaskModel>> getTasksByRole(
    String role,
    String hotelId,
  ) async {
    try {
      final querySnapshot = await masterTaskCollectionRef
          .where('assignedRole', isEqualTo: role)
          .where('hotelId', isEqualTo: hotelId)
          .where('isActive', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => MasterTaskModel.fromDocSnap(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get tasks by role: $e');
    }
  }
}
