// lib/presentation/cubits/subscription_form/subscription_form_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';
import 'package:taskoteladmin/features/subscription/domain/repo/subscription_repo.dart';

part 'subscription_form_state.dart';

class SubscriptionFormCubit extends Cubit<SubscriptionFormState> {
  final SubscriptionRepo subscriptionRepo;

  // Form Key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController minRoomsController = TextEditingController();
  final TextEditingController maxRoomsController = TextEditingController();
  final TextEditingController monthlyPriceController = TextEditingController();
  final TextEditingController yearlyPriceController = TextEditingController();
  final TextEditingController featureController = TextEditingController();

  SubscriptionFormCubit({required this.subscriptionRepo})
    : super(SubscriptionFormState.initial());

  @override
  Future<void> close() {
    // Dispose all controllers
    titleController.dispose();
    descController.dispose();
    minRoomsController.dispose();
    maxRoomsController.dispose();
    monthlyPriceController.dispose();
    yearlyPriceController.dispose();
    featureController.dispose();
    return super.close();
  }

  // Initialize form with existing plan data or reset for new plan
  void initializeForm(SubscriptionPlanModel? plan) {
    if (plan != null) {
      // Populate form with existing plan data
      titleController.text = plan.title;
      descController.text = plan.desc;
      minRoomsController.text = plan.minRooms.toString();
      maxRoomsController.text = plan.maxRooms.toString();
      monthlyPriceController.text = plan.price['monthly']?.toString() ?? '';
      yearlyPriceController.text = plan.price['yearly']?.toString() ?? '';

      emit(
        state.copyWith(
          planToEdit: plan,
          features: List.from(plan.features),
          isActive: plan.isActive,
          forGeneral: plan.forGeneral,
          isEditMode: true,
        ),
      );
    } else {
      // Reset form for new plan
      _resetForm();
      emit(SubscriptionFormState.initial());
    }
  }

  // Reset all form fields
  void _resetForm() {
    titleController.clear();
    descController.clear();
    minRoomsController.clear();
    maxRoomsController.clear();
    monthlyPriceController.clear();
    yearlyPriceController.clear();
    featureController.clear();
  }

  // Add feature
  void addFeature() {
    if (featureController.text.trim().isNotEmpty) {
      final updatedFeatures = List<String>.from(state.features);
      updatedFeatures.add(featureController.text.trim());

      emit(state.copyWith(features: updatedFeatures));
      featureController.clear();
    }
  }

  // Remove feature
  void removeFeature(String feature) {
    final updatedFeatures = List<String>.from(state.features);
    updatedFeatures.remove(feature);
    emit(state.copyWith(features: updatedFeatures));
  }

  // Update active status
  void updateActiveStatus(bool isActive) {
    emit(state.copyWith(isActive: isActive));
  }

  // Update general status
  void updateGeneralStatus(bool forGeneral) {
    emit(state.copyWith(forGeneral: forGeneral));
  }

  // Validate form
  bool validateForm() {
    final isFormValid = formKey.currentState?.validate() ?? false;
    final hasFeatures = state.features.isNotEmpty;

    if (!isFormValid || !hasFeatures) {
      emit(
        state.copyWith(
          validationMessage: !hasFeatures
              ? "Please add at least one feature"
              : "Please fill all required fields",
        ),
      );
      return false;
    }

    emit(state.copyWith(validationMessage: null));
    return true;
  }

  // Submit form (create or update based on mode)
  // Add this method to SubscriptionFormCubit
  Future<void> submitForm(SubscriptionPlanModel? editPlan) async {
    if (state.isSubmitting) return;

    if (formKey.currentState?.validate() ?? false) {
      if (state.features.isEmpty) {
        emit(
          state.copyWith(validationMessage: "Please add at least one feature"),
        );
        return;
      }

      emit(state.copyWith(isSubmitting: true, submitError: null));

      try {
        final planData = SubscriptionPlanModel(
          docId: editPlan?.docId ?? '',
          title: titleController.text.trim(),
          desc: descController.text.trim(),
          minRooms: int.parse(minRoomsController.text),
          maxRooms: int.parse(maxRoomsController.text),
          price: {
            'monthly': double.parse(monthlyPriceController.text),
            'yearly': double.parse(yearlyPriceController.text),
          },
          features: state.features,
          isActive: state.isActive,
          totalSubScribers: editPlan?.totalSubScribers ?? 0,
          totalRevenue: editPlan?.totalRevenue ?? 0.0,
          forGeneral: state.forGeneral,
          createdAt: editPlan?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );

        if (editPlan == null) {
          await subscriptionRepo.createSubscriptionPlan(planData);
        } else {
          await subscriptionRepo.updateSubscriptionPlan(planData);
        }

        emit(
          state.copyWith(
            isSubmitting: false,
            isSubmitted: true,
            successMessage:
                'Subscription Plan ${editPlan == null ? 'Created' : 'Updated'} Successfully!',
          ),
        );
        // Don't navigate here - let the parent handle it
      } catch (e) {
        emit(state.copyWith(isSubmitting: false, submitError: 'Error: $e'));
      }
    }
  }

  // Clear messages
  void clearMessages() {
    emit(
      state.copyWith(
        validationMessage: null,
        submitError: null,
        successMessage: null,
      ),
    );
  }

  // Reset form state
  void resetFormState() {
    _resetForm();
    emit(SubscriptionFormState.initial());
  }
}
