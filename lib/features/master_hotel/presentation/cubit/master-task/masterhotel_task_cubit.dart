import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
import 'package:taskoteladmin/features/master_hotel/data/masterhotel_firebaserepo.dart';
import 'package:taskoteladmin/features/master_hotel/domain/entity/masterhotel_model.dart';

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
    emit(state.copyWith(isLoadingTasks: true, allTasks: []));
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

  void deleteTask(String taskId) {
    emit(state.copyWith(isLoading: true, message: null));
    masterHotelRepo.deleteTask(taskId);
    emit(state.copyWith(isLoading: false, message: "Task Deleted"));
  }
}
