import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hotel_model.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_detail_cubit.dart';
import 'package:taskoteladmin/features/master_hotel/data/masterhotel_firebaserepo.dart';
import 'package:taskoteladmin/features/master_hotel/domain/entity/masterhotel_model.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/cubit/master-hotel/masterhotel_cubit.dart';

part 'masterhotel_task_state.dart';

class MasterhotelTaskCubit extends Cubit<MasterhotelTaskState> {
  final MasterHotelFirebaseRepo masterHotelRepo;
  MasterhotelTaskCubit({required this.masterHotelRepo})
    : super(MasterhotelTaskState.initial());

  StreamSubscription<List<CommonTaskModel>>? taskStream;

  @override
  Future<void> close() {
    taskStream?.cancel();
    return super.close();
  }

  void getHotelDetail(String hotelId, BuildContext context) async {
    final masterHotelCubit = context.read<MasterHotelCubit>();
    final hotelDetail = masterHotelCubit.state.masterHotels.firstWhere(
      (hotel) => hotel.docId == hotelId,
    );
    emit(state.copyWith(hotelDetail: hotelDetail));
  }

  void loadTasksForHotel(String hotelId) async {
    emit(state.copyWith(isLoadingTasks: true));
    taskStream?.cancel();
    try {
      taskStream = masterHotelRepo.getTaskOfHotel(hotelId).listen((tasks) {
        emit(state.copyWith(allTasks: tasks, isLoadingTasks: false));
      });
    } catch (e) {
      print('Error fetching tasks for hotel: $e');
      emit(state.copyWith(isLoadingTasks: false, message: e.toString()));
    }
  }

  void switchTab(RoleTab tab) {
    if (state.selectedTab != tab) {
      emit(state.copyWith(selectedTab: tab));
    }
  }

  void searchTasks(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void toggleTaskStatus(String taskId) {
    final updatedTasks = state.allTasks.map((task) {
      if (task.docId == taskId) {
        // You'll need to implement copyWith in CommonTaskModel
        // For now, create a new instance manually or use a different approach
        // This is a placeholder - you'll need to implement this based on your model
        return CommonTaskModel(
          docId: task.docId,
          title: task.title,
          desc: task.desc,
          frequency: task.frequency,
          duration: task.duration,
          assignedRole: task.assignedRole,
          isActive: !task.isActive, // Toggle the status
          createdAt: task.createdAt,
          createdByDocId: task.createdByDocId,
          createdByName: task.createdByName,
          updatedAt: task.updatedAt,
          updatedBy: task.updatedBy,
          updatedByName: task.updatedByName,
          hotelId: task.hotelId,
          assignedDepartmentId: task.assignedDepartmentId,
          serviceType: task.serviceType,
          dayOrDate: task.dayOrDate,
          questions: task.questions,
          startDate: task.startDate,
          endDate: task.endDate,
          fromMasterHotel: task.fromMasterHotel,
          place: task.place,
        );
      }
      return task;
    }).toList();

    emit(state.copyWith(allTasks: updatedTasks));
  }
}
