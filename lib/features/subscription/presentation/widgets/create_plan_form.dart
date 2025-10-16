// ============================================
// SUBSCRIPTION PLAN FORM - Modern & Responsive
// ============================================

import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';
import 'package:taskoteladmin/features/subscription/presentation/cubit/subscription_form_cubit.dart';
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
    final cubit = context.read<SubscriptionFormCubit>();
    cubit.initializeForm(planToEdit);

    return BlocConsumer<SubscriptionFormCubit, SubscriptionFormState>(
      listener: (context, state) {
        if (state.submitError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.submitError!),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }

        if (state.validationMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.validationMessage!),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<SubscriptionFormCubit>();

        return ResponsiveCustomBuilder(
          mobileBuilder: (width) => _buildMobileForm(context, cubit, state),
          tabletBuilder: (width) => _buildTabletForm(context, cubit, state),
          desktopBuilder: (width) => _buildDesktopForm(context, cubit, state),
        );
      },
    );
  }

  // Mobile Form Layout
  Widget _buildMobileForm(
    BuildContext context,
    SubscriptionFormCubit cubit,
    SubscriptionFormState state,
  ) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(context, state, isMobile: true),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoSection(cubit, isMobile: true),
                    const SizedBox(height: 20),
                    _buildRoomRangeSection(cubit, isMobile: true),
                    const SizedBox(height: 20),
                    _buildPricingSection(cubit, isMobile: true),
                    const SizedBox(height: 20),
                    _buildFeaturesSection(cubit, state, isMobile: true),
                    const SizedBox(height: 20),
                    _buildSettingsSection(cubit, state, isMobile: true),
                  ],
                ),
              ),
            ),
          ),
          _buildActionButtons(context, cubit, state),
        ],
      ),
    );
  }

  // Tablet Form Layout
  Widget _buildTabletForm(
    BuildContext context,
    SubscriptionFormCubit cubit,
    SubscriptionFormState state,
  ) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 650),
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: [
          _buildHeader(context, state),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoSection(cubit),
                    const SizedBox(height: 24),
                    _buildRoomRangeSection(cubit),
                    const SizedBox(height: 24),
                    _buildPricingSection(cubit),
                    const SizedBox(height: 24),
                    _buildFeaturesSection(cubit, state),
                    const SizedBox(height: 24),
                    _buildSettingsSection(cubit, state),
                  ],
                ),
              ),
            ),
          ),
          _buildActionButtons(context, cubit, state),
        ],
      ),
    );
  }

  // Desktop Form Layout
  Widget _buildDesktopForm(
    BuildContext context,
    SubscriptionFormCubit cubit,
    SubscriptionFormState state,
  ) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: [
          _buildHeader(context, state),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoSection(cubit),
                    const SizedBox(height: 28),
                    _buildRoomRangeSection(cubit),
                    const SizedBox(height: 28),
                    _buildPricingSection(cubit),
                    const SizedBox(height: 28),
                    _buildFeaturesSection(cubit, state),
                    const SizedBox(height: 28),
                    _buildSettingsSection(cubit, state),
                  ],
                ),
              ),
            ),
          ),
          _buildActionButtons(context, cubit, state),
        ],
      ),
    );
  }

  // Header Section
  Widget _buildHeader(
    BuildContext context,
    SubscriptionFormState state, {
    bool isMobile = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderGrey)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              CupertinoIcons.star_fill,
              color: AppColors.primary,
              size: isMobile ? 20 : 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              state.isEditMode ? "Edit Plan" : "Create New Plan",
              style: GoogleFonts.inter(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(CupertinoIcons.xmark_circle_fill),
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  // Basic Information Section
  Widget _buildBasicInfoSection(
    SubscriptionFormCubit cubit, {
    bool isMobile = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                CupertinoIcons.info_circle_fill,
                size: 16,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Basic Information",
              style: AppTextStyles.textFieldTitle.copyWith(
                fontSize: isMobile ? 14 : 16,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 16 : 20),
        CustomTextField(
          controller: cubit.titleController,
          title: "Plan Title *",
          hintText: "e.g., Professional",
          validator: true,
        ),
        SizedBox(height: isMobile ? 16 : 20),
        CustomTextField(
          controller: cubit.descController,
          title: "Description *",
          hintText: "Brief description of the plan",
          validator: true,
        ),
      ],
    );
  }

  // Room Range Section
  Widget _buildRoomRangeSection(
    SubscriptionFormCubit cubit, {
    bool isMobile = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                CupertinoIcons.bed_double_fill,
                size: 16,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Room Range",
              style: AppTextStyles.textFieldTitle.copyWith(
                fontSize: isMobile ? 14 : 16,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 16 : 20),
        if (isMobile) ...[
          CustomNumTextField(
            controller: cubit.minRoomsController,
            title: "Min Rooms *",
            hintText: "1",
          ),
          const SizedBox(height: 16),
          CustomNumTextField(
            controller: cubit.maxRoomsController,
            title: "Max Rooms *",
            hintText: "100",
          ),
        ] else
          Row(
            children: [
              Expanded(
                child: CustomNumTextField(
                  controller: cubit.minRoomsController,
                  title: "Min Rooms *",
                  hintText: "1",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomNumTextField(
                  controller: cubit.maxRoomsController,
                  title: "Max Rooms *",
                  hintText: "100",
                ),
              ),
            ],
          ),
      ],
    );
  }

  // Pricing Section
  Widget _buildPricingSection(
    SubscriptionFormCubit cubit, {
    bool isMobile = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                CupertinoIcons.money_dollar_circle_fill,
                size: 16,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Pricing",
              style: AppTextStyles.textFieldTitle.copyWith(
                fontSize: isMobile ? 14 : 16,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 16 : 20),
        if (isMobile) ...[
          CustomTextField(
            controller: cubit.monthlyPriceController,
            title: "Monthly Price (\$) *",
            hintText: "29.99",
            validator: true,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: cubit.yearlyPriceController,
            title: "Yearly Price (\$) *",
            hintText: "299.99",
            validator: true,
          ),
        ] else
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: cubit.monthlyPriceController,
                  title: "Monthly Price (\$) *",
                  hintText: "29.99",
                  validator: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: cubit.yearlyPriceController,
                  title: "Yearly Price (\$) *",
                  hintText: "299.99",
                  validator: true,
                ),
              ),
            ],
          ),
      ],
    );
  }

  // Features Section
  Widget _buildFeaturesSection(
    SubscriptionFormCubit cubit,
    SubscriptionFormState state, {
    bool isMobile = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                CupertinoIcons.checkmark_seal_fill,
                size: 16,
                color: Colors.purple.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Features *",
              style: AppTextStyles.textFieldTitle.copyWith(
                fontSize: isMobile ? 14 : 16,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 16 : 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: cubit.featureController,
                decoration: InputDecoration(
                  hintText: "Add a feature",
                  hintStyle: TextStyle(fontSize: isMobile ? 13 : 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => cubit.addFeature(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Add",
                style: TextStyle(fontSize: isMobile ? 12 : 14),
              ),
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
              children: state.features.map((feature) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.checkmark_alt,
                        size: 17,
                        color: Color(0xff35c662),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feature,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
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
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  _buildSettingsSection(
    SubscriptionFormCubit cubit,
    SubscriptionFormState state, {
    bool isMobile = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                CupertinoIcons.settings,
                size: 16,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Settings",
              style: AppTextStyles.textFieldTitle.copyWith(
                fontSize: isMobile ? 14 : 16,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 16 : 20),
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

  _buildActionButtons(
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

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:taskoteladmin/core/theme/app_colors.dart';
// import 'package:taskoteladmin/core/theme/app_text_styles.dart';
// import 'package:taskoteladmin/core/widget/custom_textfields.dart';
// import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';
// import 'package:taskoteladmin/features/subscription/presentation/cubit/subscription_form_cubit.dart';

// class CreatePlanForm extends StatelessWidget {
//   final SubscriptionPlanModel? planToEdit;

//   const CreatePlanForm({super.key, this.planToEdit});

//   @override
//   Widget build(BuildContext context) {
//     // Get the cubit that was already provided in the parent widget
//     final cubit = context.read<SubscriptionFormCubit>();

//     // Initialize the form with the plan data
//     cubit.initializeForm(planToEdit);

//     return BlocConsumer<SubscriptionFormCubit, SubscriptionFormState>(
//       listener: (context, state) {
//         // Handle validation and submit errors here, not navigation
//         if (state.submitError != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.submitError!),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }

//         if (state.validationMessage != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.validationMessage!),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         final cubit = context.read<SubscriptionFormCubit>();

//         return Container(
//           height: MediaQuery.of(context).size.height * 0.9,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Column(
//             children: [
//               // Header
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: const BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(color: AppColors.borderGrey),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       state.isEditMode ? "Edit Plan" : "Create New Plan",
//                       style: AppTextStyles.dialogHeading,
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         // Safe navigation close
//                         if (Navigator.canPop(context)) {
//                           Navigator.of(context).pop();
//                         }
//                       },
//                       icon: const Icon(CupertinoIcons.xmark),
//                     ),
//                   ],
//                 ),
//               ),

//               // Form Content
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(20),
//                   child: Form(
//                     key: cubit.formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Basic Information Section
//                         _buildBasicInformationSection(cubit),
//                         const SizedBox(height: 24),

//                         // Room Range Section
//                         _buildRoomRangeSection(cubit),
//                         const SizedBox(height: 24),

//                         // Pricing Section
//                         _buildPricingSection(cubit),
//                         const SizedBox(height: 24),

//                         // Features Section
//                         _buildFeaturesSection(cubit, state),
//                         const SizedBox(height: 24),

//                         // Settings Section
//                         _buildSettingsSection(cubit, state),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               // Action Buttons
//               _buildActionButtons(context, cubit, state),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildBasicInformationSection(SubscriptionFormCubit cubit) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Basic Information", style: AppTextStyles.textFieldTitle),
//         const SizedBox(height: 16),
//         CustomTextField(
//           controller: cubit.titleController,
//           title: "Plan Title *",
//           hintText: "Enter plan title",
//           validator: true,
//         ),
//         const SizedBox(height: 16),
//         CustomTextField(
//           controller: cubit.descController,
//           title: "Description *",
//           hintText: "Enter plan description",
//           validator: true,
//         ),
//       ],
//     );
//   }

//   Widget _buildRoomRangeSection(SubscriptionFormCubit cubit) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Room Range", style: AppTextStyles.textFieldTitle),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: CustomNumTextField(
//                 controller: cubit.minRoomsController,
//                 title: "Min Rooms *",
//                 hintText: "1",
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: CustomNumTextField(
//                 controller: cubit.maxRoomsController,
//                 title: "Max Rooms *",
//                 hintText: "100",
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildPricingSection(SubscriptionFormCubit cubit) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Pricing", style: AppTextStyles.textFieldTitle),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: CustomTextField(
//                 controller: cubit.monthlyPriceController,
//                 title: "Monthly Price (\$) *",
//                 hintText: "29.99",
//                 validator: true,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: CustomTextField(
//                 controller: cubit.yearlyPriceController,
//                 title: "Yearly Price (\$) *",
//                 hintText: "299.99",
//                 validator: true,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildFeaturesSection(
//     SubscriptionFormCubit cubit,
//     SubscriptionFormState state,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Features *", style: AppTextStyles.textFieldTitle),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: cubit.featureController,
//                 decoration: InputDecoration(
//                   hintText: "Add a feature",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             ElevatedButton(
//               onPressed: () => cubit.addFeature(),
//               child: const Text("Add"),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         if (state.features.isNotEmpty) ...[
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               border: Border.all(color: AppColors.borderGrey),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Column(
//               children: state.features
//                   .map(
//                     (feature) => Padding(
//                       padding: const EdgeInsets.only(bottom: 8),
//                       child: Row(
//                         children: [
//                           const Icon(
//                             CupertinoIcons.checkmark_circle,
//                             size: 16,
//                             color: Colors.green,
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(child: Text(feature)),
//                           IconButton(
//                             onPressed: () => cubit.removeFeature(feature),
//                             icon: const Icon(
//                               CupertinoIcons.minus_circle,
//                               size: 16,
//                               color: Colors.red,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                   .toList(),
//             ),
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _buildSettingsSection(
//     SubscriptionFormCubit cubit,
//     SubscriptionFormState state,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Settings", style: AppTextStyles.textFieldTitle),
//         const SizedBox(height: 16),
//         SwitchListTile(
//           title: const Text("Active Plan"),
//           subtitle: const Text("Plan is available for subscription"),
//           value: state.isActive,
//           onChanged: (value) => cubit.updateActiveStatus(value),
//         ),
//         SwitchListTile(
//           title: const Text("General Plan"),
//           subtitle: const Text("Plan is available for all users"),
//           value: state.forGeneral,
//           onChanged: (value) => cubit.updateGeneralStatus(value),
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButtons(
//     BuildContext context,
//     SubscriptionFormCubit cubit,
//     SubscriptionFormState state,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         border: Border(top: BorderSide(color: AppColors.borderGrey)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: SizedBox(
//               height: 40,
//               child: OutlinedButton(
//                 onPressed: () {
//                   // Safe navigation close
//                   if (Navigator.canPop(context)) {
//                     Navigator.of(context).pop();
//                   }
//                 },
//                 child: const Text("Cancel"),
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: SizedBox(
//               height: 40,
//               child: ElevatedButton(
//                 onPressed: state.isSubmitting
//                     ? null
//                     : () => cubit.submitForm(planToEdit),
//                 child: state.isSubmitting
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : Text(state.isEditMode ? "Update" : "Create"),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
