import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/features/master_task/domain/model/mastertask_model.dart';
import 'package:taskoteladmin/features/master_task/presentation/cubit/mastertask_cubit.dart';

class CreateTaskModal extends StatefulWidget {
  final String hotelId;
  final String assignedRole;
  final MasterTaskModel? taskToEdit;

  const CreateTaskModal({
    Key? key,
    required this.hotelId,
    required this.assignedRole,
    this.taskToEdit,
  }) : super(key: key);

  @override
  State<CreateTaskModal> createState() => _CreateTaskModalState();
}

class _CreateTaskModalState extends State<CreateTaskModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _placeController = TextEditingController();
  final _departmentController = TextEditingController();
  final _dayOrDateController = TextEditingController();

  String _selectedFrequency = 'Daily';
  String _selectedRole = 'rm';
  bool _isActive = true;

  final List<String> _frequencies = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  final List<String> _departments = [
    'Housekeeping',
    'Front Office',
    'Food & Beverage',
    'Maintenance',
    'Security',
    'Management',
    'Guest Services',
    'HR',
    'Finance',
    'Kitchen',
    'Laundry',
    'Spa & Wellness',
  ];

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.assignedRole;

    if (widget.taskToEdit != null) {
      _populateFields();
    }
  }

  void _populateFields() {
    final task = widget.taskToEdit!;
    _titleController.text = task.title;
    _descriptionController.text = task.desc;
    _durationController.text = task.duration.toString();
    _placeController.text = task.place ?? '';
    _departmentController.text = task.departmentId;
    _dayOrDateController.text = task.dayOrDate ?? '';
    _selectedFrequency = task.frequency;
    _selectedRole = task.assignedRole;
    _isActive = task.isActive;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _placeController.dispose();
    _departmentController.dispose();
    _dayOrDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(
                  widget.taskToEdit != null
                      ? CupertinoIcons.pencil
                      : CupertinoIcons.add,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.taskToEdit != null
                      ? 'Edit Master Task'
                      : 'Create Master Task',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(CupertinoIcons.xmark),
                ),
              ],
            ),
          ),
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _titleController,
                      label: 'Task Title',
                      hint: 'Enter task title',
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      hint: 'Enter task description',
                      maxLines: 3,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _durationController,
                            label: 'Duration (minutes)',
                            hint: '30',
                            keyboardType: TextInputType.number,
                            isRequired: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdown(
                            label: 'Frequency',
                            value: _selectedFrequency,
                            items: _frequencies,
                            onChanged: (value) {
                              setState(() {
                                _selectedFrequency = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            label: 'Assigned Role',
                            value: _selectedRole,
                            items: roles.map((role) => role['key']!).toList(),
                            itemLabels: roles
                                .map((role) => role['name']!)
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdown(
                            label: 'Department',
                            value: _departmentController.text.isEmpty
                                ? _departments[0]
                                : _departmentController.text,
                            items: _departments,
                            onChanged: (value) {
                              _departmentController.text = value!;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _placeController,
                            label: 'Place/Location',
                            hint: 'Enter location (optional)',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _dayOrDateController,
                            label: 'Day/Date',
                            hint: 'e.g., Monday or 15th',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text(
                          'Active Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: _isActive,
                          onChanged: (value) {
                            setState(() {
                              _isActive = value;
                            });
                          },
                          activeColor: AppColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(
                                color: AppColors.borderGrey,
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveTask,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              widget.taskToEdit != null
                                  ? 'Update Task'
                                  : 'Create Task',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            children: isRequired
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.borderGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.borderGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          validator: isRequired
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '$label is required';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    List<String>? itemLabels,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.borderGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.borderGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          items: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final displayText = itemLabels != null ? itemLabels[index] : item;

            return DropdownMenuItem<String>(
              value: item,
              child: Text(displayText),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final now = DateTime.now();
    final task = MasterTaskModel(
      docId: widget.taskToEdit?.docId ?? '',
      title: _titleController.text.trim(),
      desc: _descriptionController.text.trim(),
      createdAt: widget.taskToEdit?.createdAt ?? now,
      createdByDocId: 'admin', // TODO: Get from auth
      createdByName: 'Admin',
      updatedAt: now,
      updatedBy: 'admin',
      updatedByName: 'Admin',
      duration: int.tryParse(_durationController.text) ?? 30,
      place: _placeController.text.trim().isEmpty
          ? null
          : _placeController.text.trim(),
      questions: [], // TODO: Add questions functionality
      departmentId: _departmentController.text,
      hotelId: widget.hotelId,
      assignedRole: _selectedRole,
      frequency: _selectedFrequency,
      dayOrDate: _dayOrDateController.text.trim().isEmpty
          ? null
          : _dayOrDateController.text.trim(),
      isActive: _isActive,
    );

    if (widget.taskToEdit != null) {
      context.read<MasterTaskCubit>().updateTask(task);
    } else {
      context.read<MasterTaskCubit>().createTask(task);
    }

    Navigator.pop(context);
  }
}
