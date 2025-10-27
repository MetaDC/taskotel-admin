import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/features/clients/domain/entity/%20analytics_models.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hotel_model.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
import 'package:taskoteladmin/features/clients/domain/repo/client_repo.dart';

part 'client_detail_state.dart';

class ClientDetailCubit extends Cubit<ClientDetailState> {
  final ClientRepo clientRepo;

  final TextEditingController serachController = TextEditingController();

  ClientDetailCubit({required this.clientRepo})
    : super(ClientDetailState.initial());

  void loadClientDetails(String clientId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final client = await clientRepo.getClientDetials(clientId);
      final hotels = await clientRepo.getClientHotels(clientId);

      emit(state.copyWith(client: client, hotels: hotels, isLoading: false));
      loadClientAnalytics();
    } catch (e) {
      emit(state.copyWith(isLoading: false, message: e.toString()));
    }
  }

  void loadHotelDetails(String hotelId, String clientId) async {
    try {
      // Set loading states immediately
      emit(state.copyWith(isLoading: true, isLoadingTasks: true));

      // If client data is not loaded, load it first
      if (state.client == null || state.hotels.isEmpty) {
        final client = await clientRepo.getClientDetials(clientId);
        final hotels = await clientRepo.getClientHotels(clientId);

        emit(state.copyWith(client: client, hotels: hotels, isLoading: false));
      }

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
            isLoading: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            message: "Hotel not found",
            isLoadingTasks: false,
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      print("Error loading hotel details: ${e.toString()}");
      emit(
        state.copyWith(
          message: e.toString(),
          isLoadingTasks: false,
          isLoading: false,
        ),
      );
    }
  }

  // Tab management methods
  void switchTab(String tab) {
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
        return CommonTaskModel(
          taskId: task.taskId,
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
}

// // ClientDetailCubit
// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:taskoteladmin/core/utils/const.dart';
// import 'package:taskoteladmin/features/clients/domain/entity/%20analytics_models.dart';
// import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
// import 'package:taskoteladmin/features/clients/domain/entity/hotel_model.dart';
// import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
// import 'package:taskoteladmin/features/clients/domain/repo/client_repo.dart';

// part 'client_detail_state.dart';

// class ClientDetailCubit extends Cubit<ClientDetailState> {
//   final ClientRepo clientRepo;

//   final TextEditingController serachController = TextEditingController();

//   ClientDetailCubit({required this.clientRepo})
//     : super(ClientDetailState.initial());

//   void loadClientDetails(String clientId) async {
//     emit(state.copyWith(isLoading: true));
//     try {
//       final client = await clientRepo.getClientDetials(clientId);
//       final hotels = await clientRepo.getClientHotels(clientId);

//       emit(state.copyWith(client: client, hotels: hotels, isLoading: false));
//       loadClientAnalytics();
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, message: e.toString()));
//     }
//   }

//   void loadHotelDetails(String hotelId) async {
//     if (state.client == null || state.hotels.isEmpty) {
//       emit(state.copyWith(message: "Please navigate from client page"));
//       return;
//     }

//     try {
//       emit(state.copyWith(isLoadingTasks: true));

//       // Find hotel from loaded hotels list
//       final hotel = state.hotels
//           .where((hotel) => hotel.docId == hotelId)
//           .firstOrNull;

//       if (hotel != null) {
//         // Load all tasks for the hotel
//         final allTasks = await clientRepo.getHotelTasks(hotelId);

//         emit(
//           state.copyWith(
//             hotelDetail: hotel,
//             allTasks: allTasks,
//             isLoadingTasks: false,
//           ),
//         );
//       } else {
//         emit(state.copyWith(message: "Hotel not found", isLoadingTasks: false));
//       }
//     } catch (e) {
//       print("Error loading hotel details: ${e.toString()}");
//       emit(state.copyWith(message: e.toString(), isLoadingTasks: false));
//     }
//   }

//   // Tab management methods
//   void switchTab(String tab) {
//     if (state.selectedTab != tab) {
//       emit(state.copyWith(selectedTab: tab));
//     }
//   }

//   void searchTasks(String query) {
//     emit(state.copyWith(searchQuery: query));
//   }

//   void toggleTaskStatus(String taskId) {
//     final updatedTasks = state.allTasks.map((task) {
//       if (task.docId == taskId) {
//         // You'll need to implement copyWith in CommonTaskModel
//         // For now, create a new instance manually or use a different approach
//         // This is a placeholder - you'll need to implement this based on your model
//         return CommonTaskModel(
//           taskId: task.taskId,
//           docId: task.docId,
//           title: task.title,
//           desc: task.desc,
//           frequency: task.frequency,
//           duration: task.duration,
//           assignedRole: task.assignedRole,
//           isActive: !task.isActive, // Toggle the status
//           createdAt: task.createdAt,
//           createdByDocId: task.createdByDocId,
//           createdByName: task.createdByName,
//           updatedAt: task.updatedAt,
//           updatedBy: task.updatedBy,
//           updatedByName: task.updatedByName,
//           hotelId: task.hotelId,
//           assignedDepartmentId: task.assignedDepartmentId,
//           serviceType: task.serviceType,
//           dayOrDate: task.dayOrDate,
//           questions: task.questions,
//           startDate: task.startDate,
//           endDate: task.endDate,
//           fromMasterHotel: task.fromMasterHotel,
//           place: task.place,
//         );
//       }
//       return task;
//     }).toList();

//     emit(state.copyWith(allTasks: updatedTasks));
//   }

//   void deleteTask(String taskId) {
//     final updatedTasks = state.allTasks
//         .where((task) => task.docId != taskId)
//         .toList();
//     emit(state.copyWith(allTasks: updatedTasks));
//   }

//   void loadClientAnalytics() {
//     if (state.client == null || state.hotels.isEmpty) {
//       emit(state.copyWith(message: "Please navigate from client page"));
//       return;
//     }

//     try {
//       final clientAnalytics = ClientDetailAnalytics(
//         totalHotels: state.client?.totalHotels ?? 0,
//         totalRevenue: state.client?.totalRevenue ?? 0.0,
//         activeSubscriptions: state.hotels
//             .where((hotel) => hotel.isActive)
//             .length,
//         totalTasks: state.hotels.fold<int>(
//           0,
//           (sum, hotel) => sum + hotel.totaltask,
//         ),
//         averageHotelRating:
//             state.hotels.fold<double>(
//               0,
//               (sum, hotel) => sum + hotel.totalRevenue,
//             ) /
//             state.hotels.length,
//       );

//       emit(state.copyWith(clientAnalytics: clientAnalytics));
//     } catch (e) {
//       print("Error loading client analytics: ${e.toString()}");
//     }
//   }
// }
