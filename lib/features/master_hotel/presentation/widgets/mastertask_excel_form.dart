import 'package:file_picker/file_picker.dart';
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
import 'package:taskoteladmin/features/master_hotel/presentation/cubit/master-task/master_task_form_cubit.dart';

class MasterTaskExcelFormScreen extends StatelessWidget {
  final String hotelId;

  const MasterTaskExcelFormScreen({super.key, required this.hotelId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MasterTaskFormCubit(masterHotelRepo: MasterHotelFirebaseRepo()),
      child: BlocConsumer<MasterTaskFormCubit, MasterTaskFormState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
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
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }

          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tasks imported successfully!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return ResponsiveCustomBuilder(
            mobileBuilder: (width) => _buildForm(context, state, width, true),
            tabletBuilder: (width) => _buildForm(context, state, width, false),
            desktopBuilder: (width) => _buildForm(context, state, width, false),
          );
        },
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    MasterTaskFormState state,
    double width,
    bool isMobile,
  ) {
    return Container(
      constraints: BoxConstraints(maxWidth: isMobile ? width : 800),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 0 : 20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildHeader(context, isMobile),

          // Form Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step 1: User Category
                  _buildUserCategorySection(context, state, isMobile),
                  SizedBox(height: isMobile ? 20 : 28),

                  // Step 2: Import Options
                  _buildImportOptionsSection(context, state, isMobile),
                  SizedBox(height: isMobile ? 20 : 28),

                  // Step 3: Import Tasks
                  _buildImportSection(context, state, isMobile),
                ],
              ),
            ),
          ),

          // Action Buttons
          _buildActionButtons(context, state, isMobile),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderGrey)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 6 : 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              CupertinoIcons.tray_arrow_down_fill,
              color: AppColors.primary,
              size: isMobile ? 20 : 24,
            ),
          ),
          SizedBox(width: isMobile ? 8 : 12),
          Expanded(
            child: Text(
              "Import Master Tasks from Excel",
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

  Widget _buildUserCategorySection(
    BuildContext context,
    MasterTaskFormState state,
    bool isMobile,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                CupertinoIcons.person_2_fill,
                size: isMobile ? 14 : 16,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Step 1: Select User Category",
                style: AppTextStyles.textFieldTitle.copyWith(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Choose the user category for all tasks in the Excel file",
          style: GoogleFonts.inter(
            color: Colors.grey[600],
            fontSize: isMobile ? 12 : 14,
          ),
        ),
        const SizedBox(height: 16),
        CustomDropDownField(
          title: "User Category *",
          hintText: "Select user category",
          initialValue: state.selectedCategory,
          validatorText: "Please select a user category",
          items: roles.map((item) {
            return DropdownMenuItem(
              value: item['key'],
              child: Text(item['name'] ?? ''),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              context.read<MasterTaskFormCubit>().selectUserCategory(value);
            }
          },
          validator: true,
        ),
      ],
    );
  }

  Widget _buildImportOptionsSection(
    BuildContext context,
    MasterTaskFormState state,
    bool isMobile,
  ) {
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
                CupertinoIcons.settings,
                size: isMobile ? 14 : 16,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Step 2: Import Options",
                style: AppTextStyles.textFieldTitle.copyWith(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    state.isCreateNewTasks
                        ? CupertinoIcons.add_circled_solid
                        : CupertinoIcons.arrow_2_circlepath,
                    color: state.isCreateNewTasks ? Colors.green : Colors.blue,
                    size: isMobile ? 18 : 20,
                  ),
                  SizedBox(width: isMobile ? 8 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.isCreateNewTasks
                              ? "Create New Tasks"
                              : "Update Existing Tasks",
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 13 : 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.isCreateNewTasks
                              ? "Import tasks as new entries"
                              : "Update tasks based on existing IDs",
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 11 : 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: state.isCreateNewTasks,
                    onChanged: (value) => context
                        .read<MasterTaskFormCubit>()
                        .createNewTasks(value),
                    activeColor: Colors.green,
                  ),
                ],
              ),
              if (!state.isCreateNewTasks)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding: EdgeInsets.all(isMobile ? 10 : 12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.info_circle_fill,
                          color: Colors.orange.shade700,
                          size: isMobile ? 14 : 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Make sure your Excel file includes task IDs for updates",
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 11 : 12,
                              color: Colors.orange.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImportSection(
    BuildContext context,
    MasterTaskFormState state,
    bool isMobile,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                CupertinoIcons.doc_text_fill,
                size: isMobile ? 14 : 16,
                color: Colors.purple.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Step 3: Import Excel File",
                style: AppTextStyles.textFieldTitle.copyWith(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 16 : 20),

        // Download Template Card
        Container(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.2)),
          ),
          child: isMobile
              ? Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            CupertinoIcons.doc_text,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Download Excel Template",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Get the template and fill it",
                                style: GoogleFonts.inter(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: state.isDownloadingTemplate
                            ? null
                            : () => context
                                  .read<MasterTaskFormCubit>()
                                  .downloadTemplate(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: state.isDownloadingTemplate
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                CupertinoIcons.cloud_download,
                                size: 16,
                              ),
                        label: const Text("Download"),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        CupertinoIcons.doc_text,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Download Excel Template",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Get the template, fill in your tasks, and upload it below",
                            style: GoogleFonts.inter(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton.icon(
                        onPressed: state.isDownloadingTemplate
                            ? null
                            : () => context
                                  .read<MasterTaskFormCubit>()
                                  .downloadTemplate(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: state.isDownloadingTemplate
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                CupertinoIcons.cloud_download,
                                size: 18,
                              ),
                        label: const Text("Download"),
                      ),
                    ),
                  ],
                ),
        ),

        SizedBox(height: isMobile ? 16 : 24),

        // Upload File Card
        Container(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload Excel File *",
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: isMobile ? 12 : 16),

              // File picker
              InkWell(
                onTap: state.selectedCategory == null
                    ? null
                    : () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['xlsx', 'xls'],
                        );

                        if (result != null && context.mounted) {
                          context.read<MasterTaskFormCubit>().selectFile(
                            result.files.first,
                          );
                        }
                      },
                child: Container(
                  padding: EdgeInsets.all(isMobile ? 16 : 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: state.selectedCategory == null
                          ? Colors.grey.withOpacity(0.3)
                          : (state.selectedFile != null
                                ? Colors.green.withOpacity(0.5)
                                : Colors.blue.withOpacity(0.3)),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isMobile ? 8 : 12),
                        decoration: BoxDecoration(
                          color: state.selectedFile != null
                              ? Colors.green.shade50
                              : (state.selectedCategory == null
                                    ? Colors.grey.shade100
                                    : Colors.blue.shade50),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          state.selectedFile != null
                              ? CupertinoIcons.checkmark_alt
                              : CupertinoIcons.cloud_upload,
                          size: isMobile ? 24 : 28,
                          color: state.selectedFile != null
                              ? Colors.green
                              : (state.selectedCategory == null
                                    ? Colors.grey
                                    : Colors.blue),
                        ),
                      ),
                      SizedBox(width: isMobile ? 12 : 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.selectedFile != null
                                  ? state.selectedFile!.name
                                  : "Click to select Excel file",
                              style: GoogleFonts.inter(
                                fontSize: isMobile ? 14 : 16,
                                fontWeight: FontWeight.w500,
                                color: state.selectedFile != null
                                    ? Colors.black
                                    : (state.selectedCategory == null
                                          ? Colors.grey
                                          : Colors.blue),
                              ),
                              maxLines: isMobile ? 1 : 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.selectedFile != null
                                  ? "File selected successfully"
                                  : "Supported formats: .xlsx, .xls",
                              style: GoogleFonts.inter(
                                fontSize: isMobile ? 12 : 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (state.selectedFile != null)
                        IconButton(
                          onPressed: () =>
                              context.read<MasterTaskFormCubit>().clearFile(),
                          icon: Icon(
                            CupertinoIcons.xmark_circle_fill,
                            color: Colors.red,
                            size: isMobile ? 20 : 24,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              if (state.selectedCategory == null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding: EdgeInsets.all(isMobile ? 10 : 12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.exclamationmark_triangle_fill,
                          size: isMobile ? 14 : 16,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Please select a user category first",
                            style: GoogleFonts.inter(
                              color: Colors.orange.shade900,
                              fontSize: isMobile ? 12 : 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    MasterTaskFormState state,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderGrey)),
      ),
      child: isMobile
          ? Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed:
                        (state.selectedCategory != null &&
                            state.selectedFile != null &&
                            !state.isCreating)
                        ? () => context
                              .read<MasterTaskFormCubit>()
                              .createMasterTasksFromExcel(context, hotelId)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: state.isCreating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Import Tasks",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton(
                    onPressed: state.isCreating
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
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: state.isCreating
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
                      onPressed:
                          (state.selectedCategory != null &&
                              state.selectedFile != null &&
                              !state.isCreating)
                          ? () => context
                                .read<MasterTaskFormCubit>()
                                .createMasterTasksFromExcel(context, hotelId)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: state.isCreating
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Import Tasks",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
