import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

part 'master_task_form_state.dart';

class MasterTaskFormCubit extends Cubit<MasterTaskFormState> {
  MasterTaskFormCubit() : super(MasterTaskFormState.initial());

  void selectUserCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void selectFile(PlatformFile? file) {
    emit(state.copyWith(selectedFile: file));
  }

  void downloadTemplate() {
    // Implement template download logic
    emit(state.copyWith(isDownloadingTemplate: true));
    // Simulate download
    Future.delayed(Duration(seconds: 2), () {
      emit(state.copyWith(isDownloadingTemplate: false));
    });
  }

  void createMasterTasks() {
    if (state.selectedCategory != null && state.selectedFile != null) {
      emit(state.copyWith(isCreating: true));
      // Simulate task creation
      Future.delayed(Duration(seconds: 2), () {
        emit(state.copyWith(isCreating: false, isSuccess: true));
      });
    }
  }
}
