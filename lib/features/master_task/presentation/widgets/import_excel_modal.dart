import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/features/master_task/presentation/cubit/mastertask_form_cubit.dart';
import 'package:taskoteladmin/features/master_task/data/mastertask_firebaserepo.dart';

class ImportExcelModal extends StatelessWidget {
  final String hotelId;
  final String userCategory;

  const ImportExcelModal({
    Key? key,
    required this.hotelId,
    required this.userCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = MasterTaskFormCubit(
          masterTaskRepo: MasterTaskFirebaseRepo(),
        );
        cubit.initializeForImport(hotelId, userCategory);
        return cubit;
      },
      child: BlocConsumer<MasterTaskFormCubit, MasterTaskFormState>(
        listener: (context, state) {
          if (state.successMessage != null &&
              state.successMessage!.contains('imported')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: _buildContent(context, state),
                  ),
                ),
                _buildBottomActions(context, state),
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
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.upload_file, color: Colors.green, size: 20),
          ),
          const SizedBox(width: 12),
          const Text(
            'Import Tasks from Excel',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, MasterTaskFormState state) {
    final cubit = context.read<MasterTaskFormCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step 1: Select User Category
        _buildStepHeader('Step 1: Select User Category', Icons.person),
        const SizedBox(height: 12),
        _buildRoleSelector(context, state, cubit),
        const SizedBox(height: 24),

        // Step 2: Download Template
        _buildStepHeader('Step 2: Download Template', Icons.download),
        const SizedBox(height: 12),
        _buildTemplateSection(context, state, cubit),
        const SizedBox(height: 24),

        // Step 3: Upload File
        _buildStepHeader('Step 3: Upload Excel File', Icons.upload),
        const SizedBox(height: 12),
        _buildUploadSection(context, state, cubit),

        // Messages
        if (state.errorMessage != null) ...[
          const SizedBox(height: 16),
          _buildMessageContainer(state.errorMessage!, isError: true),
        ],

        if (state.successMessage != null &&
            !state.successMessage!.contains('imported')) ...[
          const SizedBox(height: 16),
          _buildMessageContainer(state.successMessage!, isError: false),
        ],

        // Preview Data
        if (state.previewData.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildPreviewSection(context, state, cubit),
        ],
      ],
    );
  }

  Widget _buildStepHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: Colors.blue),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelector(
    BuildContext context,
    MasterTaskFormState state,
    MasterTaskFormCubit cubit,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: state.assignedRole,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: roles.map((role) {
            return DropdownMenuItem<String>(
              value: role['key'],
              child: Text(role['name']!),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              cubit.updateImportRole(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildTemplateSection(
    BuildContext context,
    MasterTaskFormState state,
    MasterTaskFormCubit cubit,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Download Template First',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Download our Excel template with sample data and instructions. Fill in your tasks and upload the file below.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: cubit.downloadTemplate,
              icon: const Icon(Icons.download, size: 16),
              label: const Text('Download Excel Template'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection(
    BuildContext context,
    MasterTaskFormState state,
    MasterTaskFormCubit cubit,
  ) {
    return GestureDetector(
      onTap: state.isProcessing ? null : cubit.pickExcelFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          border: Border.all(
            color: state.selectedFile != null
                ? Colors.green
                : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: state.selectedFile != null
              ? Colors.green.withOpacity(0.05)
              : Colors.grey.withOpacity(0.02),
        ),
        child: Column(
          children: [
            if (state.isProcessing) ...[
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ] else ...[
              Icon(
                state.selectedFile != null
                    ? Icons.check_circle
                    : Icons.cloud_upload,
                size: 48,
                color: state.selectedFile != null ? Colors.green : Colors.grey,
              ),
            ],
            const SizedBox(height: 16),
            Text(
              state.isProcessing
                  ? 'Processing file...'
                  : state.selectedFile != null
                  ? 'File Selected'
                  : 'Choose Excel File',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: state.isProcessing
                    ? Colors.blue
                    : state.selectedFile != null
                    ? Colors.green
                    : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              state.selectedFile != null
                  ? state.selectedFile!.path.split('/').last
                  : 'Supports .xlsx and .xls files',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            if (state.selectedFile != null) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: state.isProcessing ? null : cubit.clearSelectedFile,
                child: const Text('Choose Different File'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContainer(String message, {required bool isError}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError
            ? Colors.red.withOpacity(0.1)
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isError
              ? Colors.red.withOpacity(0.3)
              : Colors.green.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError ? Colors.red : Colors.green,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isError ? Colors.red[700] : Colors.green[700],
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSection(
    BuildContext context,
    MasterTaskFormState state,
    MasterTaskFormCubit cubit,
  ) {
    final stats = cubit.getPreviewStats();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildStepHeader(
              'Preview Tasks (${state.previewData.length} found)',
              Icons.preview,
            ),
            const Spacer(),
            if (stats.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Avg: ${stats['averageDuration']}min',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),

        // Preview Statistics
        if (stats.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Import Summary',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildStatChip(
                      'Total Tasks',
                      stats['totalTasks'].toString(),
                    ),
                    _buildStatChip(
                      'Total Duration',
                      '${stats['totalDuration']}min',
                    ),
                    if (cubit.isDepartmentManager() &&
                        stats['departmentCount'] != null)
                      ...((stats['departmentCount'] as Map<String, int>).entries
                          .take(3)
                          .map(
                            (e) => _buildStatChip(e.key, e.value.toString()),
                          )),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Preview Table
        Container(
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text(
                        'Title',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 3,
                      child: Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'Duration',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'Frequency',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (cubit.isDepartmentManager()) ...[
                      const Expanded(
                        flex: 1,
                        child: Text(
                          'Department',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Data
              Expanded(
                child: ListView.builder(
                  itemCount: state.previewData.length,
                  itemBuilder: (context, index) {
                    final task = state.previewData[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              task['title'] ?? 'No Title',
                              style: const TextStyle(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              task['description'] ?? 'No Description',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${task['duration'] ?? 30}m',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              task['frequency'] ?? 'Daily',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          if (cubit.isDepartmentManager()) ...[
                            Expanded(
                              flex: 1,
                              child: Text(
                                task['departmentId'] ?? '',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontSize: 10,
          color: Colors.blue,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, MasterTaskFormState state) {
    final cubit = context.read<MasterTaskFormCubit>();
    final canImport =
        state.previewData.isNotEmpty && cubit.validateImportData();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: canImport && !state.isSubmitting
                  ? cubit.importTasks
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                disabledBackgroundColor: Colors.grey.withOpacity(0.3),
              ),
              child: state.isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      canImport
                          ? 'Import ${state.previewData.length} Tasks'
                          : 'Import Tasks',
                      style: const TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
