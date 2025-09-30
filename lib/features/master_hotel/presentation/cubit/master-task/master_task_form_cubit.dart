import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:taskoteladmin/core/services/image_picker.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as excel;
import 'package:taskoteladmin/features/auth/presentation/cubit/auth_cubit.dart';

import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/master_hotel/data/masterhotel_firebaserepo.dart';
part 'master_task_form_state.dart';

class MasterTaskFormCubit extends Cubit<MasterTaskFormState> {
  final MasterHotelFirebaseRepo masterHotelRepo;
  MasterTaskFormCubit({required this.masterHotelRepo})
    : super(MasterTaskFormState.initial());

  void selectUserCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void selectFile(PlatformFile? file) {
    // emit(state.copyWith(selectedFile: file));
    print("File selected:${state.selectedFile?.name}");
  }

  void downloadTemplate() {
    // Implement template download logic
    emit(state.copyWith(isDownloadingTemplate: true));
    // Simulate download
    Future.delayed(Duration(seconds: 2), () {
      emit(state.copyWith(isDownloadingTemplate: false));
    });
  }

  Future<void> createMasterTasks(
    BuildContext context,
    String masterHotelId,
  ) async {
    print("object ${state.selectedFile?.name}");
    // final authCubit = context.read<AuthCubit>();

    print(state.selectedCategory != null && state.selectedFile != null);
    if (state.selectedCategory != null && state.selectedFile != null) {
      emit(state.copyWith(isCreating: true));
      // Simulate task creation

      List<CommonTaskModel> importTaskList = [];

      print("object=======1");
      final bytes = state.selectedFile!.bytes;
      print("object=======2");
      print(bytes != null);
      final excelFile = excel.Excel.decodeBytes(bytes!);
      print("object=======3");
      // final excelFile = SpreadsheetDecoder.decodeBytes(bytes!, update: true);
      for (var sheet in excelFile.tables.keys) {
        print("IN For Loop");
        print("object=======4");

        final table = excelFile.tables[sheet]!;
        print("object=======5");

        for (var rowIndex = 1; rowIndex <= (table.maxRows - 1); rowIndex++) {
          print("object=======6");

          final toAddTask = CommonTaskModel(
            docId: '',
            title: table.rows[rowIndex][0]!.value.toString(),
            desc: table.rows[rowIndex][1]!.value.toString(),
            createdAt: DateTime.now(),
            createdByDocId: FBAuth.auth.currentUser!.uid,
            createdByName: 'Super Admin',
            updatedAt: DateTime.now(),
            updatedBy: FBAuth.auth.currentUser!.uid,
            updatedByName: 'Super Admin',
            hotelId: masterHotelId,
            assignedRole: state.selectedCategory!,
            frequency: table.rows[rowIndex][5]!.value.toString(),
            dayOrDate: table.rows[rowIndex][6]!.value.toString(),
            duration: table.rows[rowIndex][2]!.value.toString(),
            place: table.rows[rowIndex][3]!.value.toString(),
            questions: [],
            fromMasterHotel: null,
            isActive: true,
          );
          print("object=======1");

          importTaskList.add(toAddTask);
          print("object=======8");
          print(importTaskList.length);
        }
      }

      for (var task in importTaskList) {
        await masterHotelRepo.createTaskForHotel(task);
      }

      await Future.delayed(Duration(seconds: 2), () {
        emit(state.copyWith(isCreating: false, isSuccess: true));
      });
    }
  }
}
