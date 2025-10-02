import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/core/widget/custom_textfields.dart';
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
              ),
            );
          }

          if (state.validationMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.validationMessage!),
                backgroundColor: Colors.orange,
              ),
            );
          }

          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tasks imported successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 800, maxHeight: 800),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                _buildHeader(context),

                // Form Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Step 1: User Category
                        _buildUserCategorySection(context, state),
                        const SizedBox(height: 32),

                        // Step 2: Import Tasks
                        _buildImportSection(context, state),
                      ],
                    ),
                  ),
                ),

                // Action Buttons
                _buildActionButtons(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderGrey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Import Master Tasks from Excel",
            style: AppTextStyles.dialogHeading,
          ),
          IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(CupertinoIcons.xmark),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCategorySection(
    BuildContext context,
    MasterTaskFormState state,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Step 1: Select User Category",
          style: AppTextStyles.textFieldTitle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Choose the user category for all tasks in the Excel file",
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(height: 16),
        CustomDropDownField(
          title: "User Category",
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
        ),
      ],
    );
  }

  Widget _buildImportSection(BuildContext context, MasterTaskFormState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Step 2: Import Tasks from Excel",
          style: AppTextStyles.textFieldTitle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),

        // Download Template Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
          ),
          child: Row(
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
                    const Text(
                      "Download Excel Template",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Get the template, fill in your tasks, and upload it below",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: state.isDownloadingTemplate
                    ? null
                    : () => context
                          .read<MasterTaskFormCubit>()
                          .downloadTemplate(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
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
                    : const Icon(CupertinoIcons.cloud_download, size: 18),
                label: const Text("Download"),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Upload File Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Upload Excel File",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

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
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: state.selectedCategory == null
                          ? Colors.grey.withValues(alpha: 0.3)
                          : Colors.blue.withValues(alpha: 0.3),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        state.selectedFile != null
                            ? CupertinoIcons.checkmark_circle_fill
                            : CupertinoIcons.cloud_upload,
                        size: 32,
                        color: state.selectedFile != null
                            ? Colors.green
                            : (state.selectedCategory == null
                                  ? Colors.grey
                                  : Colors.blue),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.selectedFile != null
                                  ? state.selectedFile!.name
                                  : "Click to select Excel file",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: state.selectedFile != null
                                    ? Colors.black
                                    : (state.selectedCategory == null
                                          ? Colors.grey
                                          : Colors.blue),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.selectedFile != null
                                  ? "File selected successfully"
                                  : "Supported formats: .xlsx, .xls",
                              style: TextStyle(
                                fontSize: 14,
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
                          icon: const Icon(
                            CupertinoIcons.xmark_circle_fill,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              if (state.selectedCategory == null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.info_circle,
                        size: 16,
                        color: Colors.orange[700],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Please select a user category first",
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            Text(
              "Import New Tasks from Excel:",
              style: AppTextStyles.textFieldTitle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Checkbox(value: false, onChanged: (value) {}),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, MasterTaskFormState state) {
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
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop();
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Cancel"),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 40,
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
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: state.isCreating
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text("Importing Tasks..."),
                        ],
                      )
                    : const Text("Import Tasks"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
