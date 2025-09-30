// ClientDetailCubit
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/features/clients/domain/entity/%20analytics_models.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hotel_model.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
import 'package:taskoteladmin/features/clients/domain/repo/client_repo.dart';

part 'client_detail_state.dart';

class ClientDetailCubit extends Cubit<ClientDetailState> {
  final ClientRepo clientRepo;

  ClientDetailCubit({required this.clientRepo})
    : super(ClientDetailState.initial());

  void loadClientDetails(String clientId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final client = await clientRepo.getClientDetials(clientId);
      final hotels = await clientRepo.getClientHotels(clientId);

      print("Client loaded: ${client.name}");
      emit(state.copyWith(client: client, hotels: hotels, isLoading: false));
      loadClientAnalytics();
      print("Client loaded: ${state.client?.docId}--${hotels.length}");
    } catch (e) {
      emit(state.copyWith(isLoading: false, message: e.toString()));
    }
  }

  void loadHotelDetails(String hotelId) async {
    if (state.client == null || state.hotels.isEmpty) {
      emit(state.copyWith(message: "Please navigate from client page"));
      return;
    }

    try {
      emit(state.copyWith(isLoadingTasks: true));

      // Find hotel from loaded hotels list
      final hotel = state.hotels
          .where((hotel) => hotel.docId == hotelId)
          .firstOrNull;

      if (hotel != null) {
        // Load all tasks for the hotel
        final allTasks = await clientRepo.getHotelTasks(hotelId);

        emit(
          state.copyWith(
            hotelDetail: hotel,
            allTasks: allTasks,
            isLoadingTasks: false,
          ),
        );
      } else {
        print("Hotel not found in loaded hotels list");
        emit(state.copyWith(message: "Hotel not found", isLoadingTasks: false));
      }
    } catch (e) {
      print("Error loading hotel details: ${e.toString()}");
      emit(state.copyWith(message: e.toString(), isLoadingTasks: false));
    }
  }

  // Tab management methods
  void switchTab(RoleTab tab) {
    if (state.selectedTab != tab) {
      emit(state.copyWith(selectedTab: tab));
    }
  }

  void searchTasks(String query) {
    print("Searching tasks with query: '$query'");
    emit(state.copyWith(searchQuery: query));
  }

  void toggleTaskStatus(String taskId) {
    print("Toggling task status for: $taskId");
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

  void deleteTask(String taskId) {
    print("Deleting task: $taskId");
    final updatedTasks = state.allTasks
        .where((task) => task.docId != taskId)
        .toList();
    emit(state.copyWith(allTasks: updatedTasks));
  }

  void loadClientAnalytics() {
    if (state.client == null || state.hotels.isEmpty) {
      emit(state.copyWith(message: "Please navigate from client page"));
      return;
    }
    for (var hotel in state.hotels) {
      print(
        "Hotel: ${hotel.name}---${hotel.totaltask}---${hotel.totalRevenue}",
      );
    }
    try {
      final clientAnalytics = ClientDetailAnalytics(
        totalHotels: state.client?.totalHotels ?? 0,
        totalRevenue: state.client?.totalRevenue ?? 0.0,
        activeSubscriptions: state.hotels
            .where((hotel) => hotel.isActive)
            .length,
        totalTasks: state.hotels.fold<int>(
          0,
          (sum, hotel) => sum + hotel.totaltask,
        ),
        averageHotelRating:
            state.hotels.fold<double>(
              0,
              (sum, hotel) => sum + hotel.totalRevenue,
            ) /
            state.hotels.length,
      );

      emit(state.copyWith(clientAnalytics: clientAnalytics));
    } catch (e) {
      print("Error loading client analytics: ${e.toString()}");
    }
  }

  // void loadHotelAnalytics() {
  //   if (state.hotelDetail == null) {
  //     emit(state.copyWith(message: "Please navigate from client page"));
  //     return;
  //   }
  //   try {
  //     final hotelAnalytics = HotelDetailAnalytics(
  //       totalTasks: state.hotelDetail?.totaltask ?? 0,
  //       activeTasks: state.allTasks.where((task) => task.isActive).length,
  //       completedTasks: state.allTasks.where((task) => !task.isActive).length,
  //       taskCompletionRate:
  //           (state.allTasks.where((task) => !task.isActive).length /
  //               state.allTasks.length) *
  //           100,
  //       totalRooms:
  //           state.hotelDetail?.floors.values.fold<int>(
  //             0,
  //             (sum, rooms) => sum + rooms,
  //           ) ??
  //           0,
  //       monthlyRevenue: state.hotelDetail?.totalRevenue ?? 0.0,
  //     );

  //     emit(state.copyWith(hotelAnalytics: hotelAnalytics));
  //   } catch (e) {
  //     print("Error loading hotel analytics: ${e.toString()}");
  //   }
  // }
}
