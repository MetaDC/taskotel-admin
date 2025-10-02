import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/widget/custom_textfields.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';
import 'package:taskoteladmin/features/subscription/presentation/cubit/subscription_form_cubit.dart';

class CreatePlanForm extends StatelessWidget {
  final SubscriptionPlanModel? planToEdit;

  const CreatePlanForm({super.key, this.planToEdit});

  @override
  Widget build(BuildContext context) {
    // Get the cubit that was already provided in the parent widget
    final cubit = context.read<SubscriptionFormCubit>();

    // Initialize the form with the plan data
    cubit.initializeForm(planToEdit);

    return BlocConsumer<SubscriptionFormCubit, SubscriptionFormState>(
      listener: (context, state) {
        // Handle validation and submit errors here, not navigation
        if (state.submitError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.submitError!),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state.validationMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.validationMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<SubscriptionFormCubit>();

        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.borderGrey),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.isEditMode ? "Edit Plan" : "Create New Plan",
                      style: AppTextStyles.dialogHeading,
                    ),
                    IconButton(
                      onPressed: () {
                        // Safe navigation close
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: const Icon(CupertinoIcons.xmark),
                    ),
                  ],
                ),
              ),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: cubit.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Basic Information Section
                        _buildBasicInformationSection(cubit),
                        const SizedBox(height: 24),

                        // Room Range Section
                        _buildRoomRangeSection(cubit),
                        const SizedBox(height: 24),

                        // Pricing Section
                        _buildPricingSection(cubit),
                        const SizedBox(height: 24),

                        // Features Section
                        _buildFeaturesSection(cubit, state),
                        const SizedBox(height: 24),

                        // Settings Section
                        _buildSettingsSection(cubit, state),
                      ],
                    ),
                  ),
                ),
              ),

              // Action Buttons
              _buildActionButtons(context, cubit, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBasicInformationSection(SubscriptionFormCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Basic Information", style: AppTextStyles.textFieldTitle),
        const SizedBox(height: 16),
        CustomTextField(
          controller: cubit.titleController,
          title: "Plan Title",
          hintText: "Enter plan title",
          validator: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: cubit.descController,
          title: "Description",
          hintText: "Enter plan description",
          validator: true,
        ),
      ],
    );
  }

  Widget _buildRoomRangeSection(SubscriptionFormCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Room Range", style: AppTextStyles.textFieldTitle),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: cubit.minRoomsController,
                title: "Min Rooms",
                hintText: "1",
                validator: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: cubit.maxRoomsController,
                title: "Max Rooms",
                hintText: "100",
                validator: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPricingSection(SubscriptionFormCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pricing", style: AppTextStyles.textFieldTitle),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: cubit.monthlyPriceController,
                title: "Monthly Price (\$)",
                hintText: "29.99",
                validator: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: cubit.yearlyPriceController,
                title: "Yearly Price (\$)",
                hintText: "299.99",
                validator: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(
    SubscriptionFormCubit cubit,
    SubscriptionFormState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Features", style: AppTextStyles.textFieldTitle),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: cubit.featureController,
                decoration: InputDecoration(
                  hintText: "Add a feature",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => cubit.addFeature(),
              child: const Text("Add"),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (state.features.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderGrey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: state.features
                  .map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.checkmark_circle,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(feature)),
                          IconButton(
                            onPressed: () => cubit.removeFeature(feature),
                            icon: const Icon(
                              CupertinoIcons.minus_circle,
                              size: 16,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSettingsSection(
    SubscriptionFormCubit cubit,
    SubscriptionFormState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Settings", style: AppTextStyles.textFieldTitle),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text("Active Plan"),
          subtitle: const Text("Plan is available for subscription"),
          value: state.isActive,
          onChanged: (value) => cubit.updateActiveStatus(value),
        ),
        SwitchListTile(
          title: const Text("General Plan"),
          subtitle: const Text("Plan is available for all users"),
          value: state.forGeneral,
          onChanged: (value) => cubit.updateGeneralStatus(value),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    SubscriptionFormCubit cubit,
    SubscriptionFormState state,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderGrey)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  // Safe navigation close
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Cancel"),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: state.isSubmitting
                    ? null
                    : () => cubit.submitForm(planToEdit),
                child: state.isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(state.isEditMode ? "Update" : "Create"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
