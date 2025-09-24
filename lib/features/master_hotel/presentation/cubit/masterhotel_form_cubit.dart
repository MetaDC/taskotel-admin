import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/services/image_picker.dart';
import 'package:taskoteladmin/features/master_hotel/data/masterhotel_firebaserepo.dart';
import 'package:taskoteladmin/features/master_hotel/models/masterhotel_model.dart';
import 'package:taskoteladmin/features/stroage/data/firebase_storage_repo.dart';

part 'masterhotel_form_state.dart';

class MasterhotelFormCubit extends Cubit<MasterhotelFormState> {
  final MasterHotelFirebaseRepo masterHotelRepo;

  MasterhotelFormCubit({required this.masterHotelRepo})
    : super(MasterhotelFormState.initial());

  final franchiseController = TextEditingController();
  final descriptionController = TextEditingController();
  final websiteUrlController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Initialize form
  void initializeForm(MasterHotelModel? editMasterHotel) {
    emit(state.copyWith(message: "", isLoading: true));
    if (editMasterHotel != null) {
      franchiseController.text = editMasterHotel.franchiseName;
      descriptionController.text = editMasterHotel.description;
      websiteUrlController.text = editMasterHotel.websiteUrl ?? '';
      emit(state.copyWith(selectedPropertyType: editMasterHotel.propertyType));

      emit(
        state.copyWith(
          dbFile: editMasterHotel.logoUrl,
          isLoading: false,
          selectedFile: null,
        ),
      );
    } else {
      emit(MasterhotelFormState.initial());
    }
  }

  // Files related methods
  Future<void> pickFile(BuildContext context) async {
    final selectedFile = await ImagePickerService().pickFile(
      context,
      useCompressor: true,
    );
    if (selectedFile != null) {
      emit(state.copyWith(selectedFile: selectedFile, message: ""));
    }
  }

  // Pick file from camera
  Future<void> pickFileFromCamera(BuildContext context) async {
    final selectedFile = await ImagePickerService().pickImageNewCamera(
      context,
      useCompressor: true,
    );
    if (selectedFile != null) {
      emit(state.copyWith(selectedFile: selectedFile, message: ""));
    }
  }

  // View file
  Future<void> viewPickFile(
    String? dbImg,
    BuildContext context,
    String? dbImgExt,
  ) async {}

  // Delete file
  void deletPickFile(bool dbImage) {
    if (dbImage) {
      emit(state.copyWith(dbFile: false));
    } else {
      emit(state.copyWith(selectedFile: false));
    }
    print("File deleted:${state.selectedFile}");
  }

  Future<void> submitForm(
    BuildContext context,
    MasterHotelModel? editMasterHotel,
  ) async {
    if (state.isLoading) {
      return;
    }
    if (formKey.currentState?.validate() ?? false) {
      emit(state.copyWith(isLoading: true));
      try {
        final fileUrl = state.selectedFile != null
            ? await FirebaseStorageRepo().uploadMasterHotelIconFile(
                state.selectedFile!,
              )
            : state.dbFile;

        final hotelData = MasterHotelModel(
          docId: editMasterHotel?.docId ?? '',
          franchiseName: franchiseController.text.trim(),
          propertyType: state.selectedPropertyType ?? '',
          description: descriptionController.text.trim(),
          amenities: [],
          logoUrl: fileUrl ?? null,
          logoName: state.selectedFile?.name ?? null,
          logoExtension: state.selectedFile?.extension ?? null,
          websiteUrl: websiteUrlController.text.trim(),
          createdAt: editMasterHotel == null ? DateTime.now() : DateTime.now(),
          updatedAt: DateTime.now(),
          isActive: true,
          totalClients: 0,
          totalMasterTasks: 0,
        );

        if (editMasterHotel == null) {
          await masterHotelRepo.createMasterHotel(hotelData);
        } else {
          await masterHotelRepo.updateMasterHotel(hotelData);
        }

        emit(
          state.copyWith(
            isLoading: false,
            message:
                'Hotel Master ${editMasterHotel == null ? 'Created' : 'Updated'} Successfully!',
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        emit(state.copyWith(isLoading: false, message: 'Error: $e'));
      }
    }
  }

  void setPropertyType(String? value) {
    emit(state.copyWith(selectedPropertyType: value));
  }
}
