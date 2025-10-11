import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/core/widget/custom_textfields.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features/master_hotel/data/masterhotel_firebaserepo.dart';
import 'package:taskoteladmin/features/master_hotel/domain/entity/masterhotel_model.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/cubit/master-hotel/masterhotel_form_cubit.dart';

class MasterHotelForm extends StatefulWidget {
  final MasterHotelModel? editMasterHotel;
  const MasterHotelForm({super.key, this.editMasterHotel});

  @override
  State<MasterHotelForm> createState() => _MasterHotelFormState();
}

class _MasterHotelFormState extends State<MasterHotelForm> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MasterhotelFormCubit(masterHotelRepo: MasterHotelFirebaseRepo())
            ..initializeForm(widget.editMasterHotel),
      child: BlocConsumer<MasterhotelFormCubit, MasterhotelFormState>(
        listener: (context, state) {
          if (state.message != null && state.message!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? ""),
                backgroundColor: state.message!.contains('success')
                    ? Colors.green
                    : Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<MasterhotelFormCubit>();

          return ResponsiveCustomBuilder(
            mobileBuilder: (width) => _buildMobileForm(context, cubit, state),
            tabletBuilder: (width) => _buildTabletForm(context, cubit, state),
            desktopBuilder: (width) => _buildDesktopForm(context, cubit, state),
          );
        },
      ),
    );
  }

  // Mobile Form Layout
  Widget _buildMobileForm(
    BuildContext context,
    MasterhotelFormCubit cubit,
    MasterhotelFormState state,
  ) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context, cubit, state, isMobile: true),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoSection(cubit, state, isMobile: true),
                    const SizedBox(height: 24),
                    _buildBrandAssetsSection(cubit, state, isMobile: true),
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
    MasterhotelFormCubit cubit,
    MasterhotelFormState state,
  ) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 650),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context, cubit, state),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoSection(cubit, state),
                    const SizedBox(height: 24),
                    _buildBrandAssetsSection(cubit, state),
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
    MasterhotelFormCubit cubit,
    MasterhotelFormState state,
  ) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context, cubit, state),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoSection(cubit, state),
                    const SizedBox(height: 28),
                    _buildBrandAssetsSection(cubit, state),
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
    MasterhotelFormCubit cubit,
    MasterhotelFormState state, {
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
              CupertinoIcons.building_2_fill,
              color: AppColors.primary,
              size: isMobile ? 20 : 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.editMasterHotel != null
                  ? "Edit Hotel Master"
                  : "Create Hotel Master",
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
    MasterhotelFormCubit cubit,
    MasterhotelFormState state, {
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

        if (isMobile) ...[
          CustomTextField(
            controller: cubit.franchiseController,
            hintText: "e.g., Marriott",
            title: "Franchise Name *",
            validator: true,
          ),
          const SizedBox(height: 16),
          CustomDropDownField(
            title: "Property Type *",
            hintText: "Select Property Type",
            initialValue: state.selectedPropertyType,
            validatorText: "Please select a property type",
            items: hotelTypes.map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            onChanged: (value) => cubit.setPropertyType(value),
            validator: true,
          ),
        ] else
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: cubit.franchiseController,
                  hintText: "e.g., Marriott",
                  title: "Franchise Name *",
                  validator: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomDropDownField(
                  title: "Property Type *",
                  hintText: "Select Property Type",
                  initialValue: state.selectedPropertyType,
                  validatorText: "Please select a property type",
                  items: hotelTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) => cubit.setPropertyType(value),
                  validator: true,
                ),
              ),
            ],
          ),
        SizedBox(height: isMobile ? 16 : 20),
        CustomDescTextField(
          controller: cubit.descriptionController,
          hintText: "Brief description of the franchise",
          title: "Description",
          maxChars: 250,
        ),
      ],
    );
  }

  // Brand Assets Section
  Widget _buildBrandAssetsSection(
    MasterhotelFormCubit cubit,
    MasterhotelFormState state, {
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
                CupertinoIcons.photo_fill,
                size: 16,
                color: Colors.purple.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Brand Assets",
              style: AppTextStyles.textFieldTitle.copyWith(
                fontSize: isMobile ? 14 : 16,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 16 : 20),
        CustomFileUploadField(
          title: "Logo",
          hintText: state.selectedFile != null
              ? "File Selected: ${state.selectedFile!.name}"
              : state.dbFile != null
              ? "File Selected: ${state.dbFileName}"
              : "Upload logo or paste URL",
          prefixIcon: const Icon(Icons.upload_file),
          onTap: () => cubit.pickFile(context),
          onDeleteImageTap: () => cubit.deletPickFile(false),
          uploadImg: state.selectedFile != null
              ? Image.memory(state.selectedFile!.uInt8List, fit: BoxFit.cover)
              : state.dbFile != null
              ? Image.network(state.dbFile!, fit: BoxFit.cover)
              : null,
        ),
        SizedBox(height: isMobile ? 16 : 20),
        CustomTextField(
          controller: cubit.websiteUrlController,
          hintText: "https://franchise-website.com",
          title: "Website URL",
          prefixIcon: Icons.language,
          validator: false,
        ),
      ],
    );
  }

  // Action Buttons
  Widget _buildActionButtons(
    BuildContext context,
    MasterhotelFormCubit cubit,
    MasterhotelFormState state,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderGrey)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44,
              child: OutlinedButton(
                onPressed: state.isLoading
                    ? null
                    : () {
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                      },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Cancel"),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () => cubit.submitForm(context, widget.editMasterHotel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: state.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        widget.editMasterHotel != null
                            ? "Update Master"
                            : "Create Master",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
