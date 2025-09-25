import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Border, BorderStyle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' hide Border, BorderStyle;
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/features/master_task/presentation/cubit/mastertask_cubit.dart';

class ImportExcelModal extends StatefulWidget {
  final String hotelId;
  final String userCategory;

  const ImportExcelModal({
    Key? key,
    required this.hotelId,
    required this.userCategory,
  }) : super(key: key);

  @override
  State<ImportExcelModal> createState() => _ImportExcelModalState();
}

class _ImportExcelModalState extends State<ImportExcelModal> {
  String _selectedRole = 'rm';
  File? _selectedFile;
  bool _isProcessing = false;
  List<Map<String, dynamic>> _previewData = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.userCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
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
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.doc_text, color: AppColors.primary),
                const SizedBox(width: 12),
                const Text(
                  'Import Tasks from Excel',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(CupertinoIcons.xmark),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step 1: Select User Category
                  _buildStepHeader('Step 1: Select User Category'),
                  const SizedBox(height: 12),
                  _buildRoleSelector(),
                  const SizedBox(height: 24),

                  // Step 2: Import Tasks
                  _buildStepHeader('Step 2: Import Tasks'),
                  const SizedBox(height: 12),

                  // Download Template Button
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.doc_text, color: Colors.blue),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Import tasks from Excel',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Download the template, fill in your tasks, and upload the file',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _downloadTemplate,
                          icon: const Icon(
                            CupertinoIcons.cloud_download,
                            size: 16,
                          ),
                          label: const Text('Download Template'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Upload Excel File
                  _buildUploadSection(),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.exclamationmark_triangle,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Preview Data
                  if (_previewData.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildPreviewSection(),
                  ],

                  const SizedBox(height: 30),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppColors.borderGrey),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _previewData.isNotEmpty && !_isProcessing
                              ? _importTasks
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isProcessing
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Import Tasks',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedRole,
          isExpanded: true,
          hint: const Text('Select user category for these tasks'),
          items: roles.map((role) {
            return DropdownMenuItem<String>(
              value: role['key'],
              child: Text(role['name']!),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedRole = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildUploadSection() {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedFile != null ? Colors.green : AppColors.borderGrey,
            style: BorderStyle.solid,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: _selectedFile != null
              ? Colors.green.withOpacity(0.05)
              : Colors.grey.withOpacity(0.05),
        ),
        child: Column(
          children: [
            Icon(
              _selectedFile != null
                  ? CupertinoIcons.checkmark_circle_fill
                  : CupertinoIcons.cloud_upload,
              size: 48,
              color: _selectedFile != null ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              _selectedFile != null
                  ? 'File Selected: ${_selectedFile!.path.split('/').last}'
                  : 'Choose file',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _selectedFile != null ? Colors.green : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _selectedFile != null ? 'Click to change file' : 'No file chosen',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preview (${_previewData.length} tasks found)',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderGrey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            itemCount: _previewData.length,
            itemBuilder: (context, index) {
              final task = _previewData[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.borderGrey.withOpacity(0.5),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task['title'] ?? 'No Title',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task['description'] ?? 'No Description',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _downloadTemplate() {
    // TODO: Implement template download
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Template download - Coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _errorMessage = null;
        });
        await _processExcelFile();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error picking file: $e';
      });
    }
  }

  Future<void> _processExcelFile() async {
    if (_selectedFile == null) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      var bytes = _selectedFile!.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      List<Map<String, dynamic>> tasks = [];

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table]!;

        // Skip header row (assuming first row is header)
        for (int i = 1; i < sheet.maxRows; i++) {
          var row = sheet.rows[i];
          if (row.isEmpty) continue;

          // Expected columns: Title, Description, Duration, Frequency, Department, Place, Day/Date
          tasks.add({
            'title': row[0]?.value?.toString() ?? '',
            'description': row[1]?.value?.toString() ?? '',
            'duration': int.tryParse(row[2]?.value?.toString() ?? '30') ?? 30,
            'frequency': row[3]?.value?.toString() ?? 'Daily',
            'departmentId': row[4]?.value?.toString() ?? 'General',
            'place': row[5]?.value?.toString(),
            'dayOrDate': row[6]?.value?.toString(),
          });
        }
      }

      setState(() {
        _previewData = tasks;
        _isProcessing = false;
      });

      if (tasks.isEmpty) {
        setState(() {
          _errorMessage = 'No valid tasks found in the Excel file';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error processing Excel file: $e';
        _isProcessing = false;
      });
    }
  }

  void _importTasks() {
    if (_previewData.isEmpty) return;

    context.read<MasterTaskCubit>().importTasksFromExcel(
      _previewData,
      _selectedRole,
    );
    Navigator.pop(context);
  }
}
