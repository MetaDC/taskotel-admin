import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
import 'package:taskoteladmin/features/master_hotel/data/masterhotel_firebaserepo.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/master_hotel/domain/entity/masterhotel_model.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:excel/excel.dart';
import 'dart:io' show File, Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:js_interop';

import 'package:web/web.dart' as web;
part 'masterhotel_task_state.dart';

class MasterhotelTaskCubit extends Cubit<MasterhotelTaskState> {
  final MasterHotelFirebaseRepo masterHotelRepo;
  MasterhotelTaskCubit({required this.masterHotelRepo})
    : super(MasterhotelTaskState.initial());

  StreamSubscription<List<CommonTaskModel>>? taskStream;
  final serachController = TextEditingController();

  @override
  Future<void> close() {
    taskStream?.cancel();
    return super.close();
  }

  // void getHotelDetail(String hotelId, BuildContext context) async {
  //   print("obj-----1");
  //   final masterHotelCubit = context.read<MasterHotelCubit>();
  //   print("obj-----2");
  //   print(
  //     "obj-----${hotelId} --- ${masterHotelCubit.state.masterHotels.length}",
  //   );

  //   final hotelDetail = masterHotelCubit.state.masterHotels.firstWhere(
  //     (hotel) => hotel.docId == hotelId,
  //   );
  //   emit(state.copyWith(hotelDetail: hotelDetail));

  //   print("obj-----3");
  //   print("obj-----4");
  // }

  void loadTasksForHotel(String hotelId, String role) async {
    emit(state.copyWith(isLoadingTasks: true, allTasks: [], message: ""));
    taskStream?.cancel();

    try {
      taskStream = masterHotelRepo.getTaskOfHotel(hotelId, role).listen((
        tasks,
      ) {
        emit(state.copyWith(allTasks: tasks, isLoadingTasks: false));
        searchTasks();
      });
    } catch (e) {
      print('Error fetching tasks for hotel: $e');
      emit(state.copyWith(isLoadingTasks: false, message: e.toString()));
    }
  }

  void switchTab(String tab, String hotelId) async {
    if (state.selectedTab != tab) {
      loadTasksForHotel(hotelId, tab);
      emit(state.copyWith(selectedTab: tab));
    }
  }

  void searchTasks() {
    final filteredTasks = state.allTasks.where((task) {
      return task.title.toLowerCase().contains(
        serachController.text.toLowerCase().trim().toLowerCase(),
      );
    }).toList();
    emit(state.copyWith(filteredTasks: filteredTasks));
  }

  void toggleTaskStatus(String taskId) {
    CommonTaskModel task = state.allTasks.firstWhere(
      (task) => task.docId == taskId,
    );
    task = task.copyWith(isActive: !task.isActive);
    masterHotelRepo.updateTaskForHotel(task.docId, task);
  }

  void deleteTask(String taskId) async {
    emit(state.copyWith(isLoading: true, message: null));

    try {
      // Get the task to find the hotel ID before deleting
      final taskDoc = await FBFireStore.tasks.doc(taskId).get();
      final hotelId = taskDoc.data()?['hotelId'] as String?;

      // Delete the task
      await masterHotelRepo.deleteTask(taskId);

      // Update master hotel task count if hotelId exists
      if (hotelId != null) {
        await _updateMasterHotelTaskCount(hotelId);
      }

      emit(state.copyWith(isLoading: false, message: "Task Deleted"));
    } catch (e) {
      emit(state.copyWith(isLoading: false, message: "Failed to delete task"));
    }
  }

  // Helper method to update master hotel task count
  Future<void> _updateMasterHotelTaskCount(String masterHotelId) async {
    try {
      // Get all tasks for this hotel
      final allTasksSnapshot = await FBFireStore.tasks
          .where('hotelId', isEqualTo: masterHotelId)
          .get();

      final totalTasks = allTasksSnapshot.docs.length;

      // Update the master hotel document
      await masterHotelRepo.updateMasterHotelTaskCount(
        masterHotelId,
        totalTasks,
      );
    } catch (e) {
      print('Error updating master hotel task count: $e');
    }
  }

  Future<void> exportTasksToExcel(List<CommonTaskModel> filteredTasks) async {
    if (filteredTasks.isEmpty) {
      emit(state.copyWith(message: "No tasks to export"));
      return;
    }
    try {
      final excel = Excel.createExcel();

      // Remove the default sheet and create our own
      excel.delete('Sheet1');
      excel.copy('Sheet1', 'Tasks'); // Or just rename

      // OR better: just use the default sheet
      Sheet sheet = excel['Sheet1']; // Use default sheet instead

      // Headers
      final headers = [
        'Task ID',
        'Title',
        'Description',
        'Duration',
        'Place',
        'Department ID',
        'Frequency',
        'Day or Date',
      ];
      sheet.appendRow(headers.map((e) => TextCellValue(e)).toList());

      // Write task data
      for (var task in filteredTasks) {
        sheet.appendRow([
          TextCellValue(task.taskId ?? ''),
          TextCellValue(task.title ?? ''),
          TextCellValue(task.desc ?? ''),
          TextCellValue(task.duration?.toString() ?? ''),
          TextCellValue(task.place ?? ''),
          TextCellValue(task.assignedDepartmentId ?? ''),
          TextCellValue(task.frequency ?? ''),
          TextCellValue(task.dayOrDate ?? ''),
        ]);
      }

      // Debug: Check if tasks were added
      print("📊 Total tasks to export: ${filteredTasks.length}");
      print("📊 Sheet rows: ${sheet.maxRows}");
      print("📊 Available sheets: ${excel.tables.keys.toList()}");

      final List<int>? fileBytes = excel.encode();
      if (fileBytes == null) {
        throw Exception("Failed to encode Excel file");
      }

      print("📊 File size: ${fileBytes.length} bytes");

      if (kIsWeb) {
        _downloadFileWeb(fileBytes, 'exported_tasks.xlsx');
        print("✅ Excel file downloaded for web");
      } else {
        if (Platform.isAndroid) {
          var status = await Permission.storage.request();
          if (!status.isGranted) {
            throw Exception("Storage permission not granted");
          }
        }

        final directory = await getExternalStorageDirectory();
        final filePath = '${directory!.path}/exported_tasks.xlsx';
        final file = File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);

        print("✅ Excel file saved: $filePath");
      }
    } catch (e) {
      print("❌ Error exporting tasks: $e");
      rethrow;
    }
  }

  // Helper method for web download using package:web
  void _downloadFileWeb(List<int> bytes, String fileName) {
    if (kIsWeb) {
      // Convert List<int> to Uint8List first
      final uint8List = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);

      final blob = web.Blob(
        [uint8List.toJS].toJS,
        web.BlobPropertyBag(
          type:
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        ),
      );

      final url = web.URL.createObjectURL(blob);
      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = url;
      anchor.download = fileName;
      anchor.click();

      web.URL.revokeObjectURL(url);
    }
  }
}
