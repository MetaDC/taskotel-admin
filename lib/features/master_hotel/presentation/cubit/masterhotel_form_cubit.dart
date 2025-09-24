import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:taskoteladmin/features/master_hotel/domain/entity/masterhotel_model.dart';
import 'package:taskoteladmin/features/master_hotel/domain/repo/masterhotel_repo.dart';

part 'masterhotel_form_state.dart';

class MasterhotelFormCubit extends Cubit<MasterhotelFormState> {
  final MasterHotelRepo masterHotelRepo;

  MasterhotelFormCubit({required this.masterHotelRepo})
    : super(MasterhotelFormState.initial());

  final franchiseController = TextEditingController();
  final descriptionController = TextEditingController();
  final logoUrlController = TextEditingController();
  final websiteController = TextEditingController();

  Future<void> submitForm(
    BuildContext context,
    MasterHotelModel? editMasterHotel,
  ) async {
    emit(state.copyWith(isLoading: true));

    if (_validateForm()) {
      try {
        final hotelData = MasterHotelModel(
          docId: editMasterHotel?.docId ?? '', // If editing, docId will be set
          franchiseName: franchiseController.text.trim(),
          propertyType: state.selectedPropertyType ?? '',
          description: descriptionController.text.trim(),
          amenities: [],
          logoUrl: logoUrlController.text.trim(),
          websiteUrl: websiteController.text.trim(),
          createdAt: editMasterHotel == null ? DateTime.now() : DateTime.now(),
          updatedAt: DateTime.now(),
          isActive: true,
        );

        if (editMasterHotel == null) {
          // If docId is null, it's a new hotel (add operation)
          await masterHotelRepo.createMasterHotel(hotelData);
        } else {
          // If docId is set, update the existing hotel
          await masterHotelRepo.updateMasterHotel(hotelData);
        }

        emit(
          state.copyWith(
            isLoading: false,
            message:
                'Hotel Master ${editMasterHotel == null ? 'Created' : 'Updated'} Successfully!',
          ),
        );
        Navigator.pop(context); // Close the form on success
      } catch (e) {
        emit(state.copyWith(isLoading: false, message: 'Error: $e'));
      }
    } else {
      emit(
        state.copyWith(
          isLoading: false,
          message: 'Please fill all required fields.',
        ),
      );
    }
  }

  bool _validateForm() {
    if (franchiseController.text.isEmpty ||
        state.selectedPropertyType == null ||
        descriptionController.text.isEmpty) {
      return false;
    }
    return true;
  }

  void setPropertyType(String? value) {
    emit(state.copyWith(selectedPropertyType: value));
  }
}
