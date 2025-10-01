import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/core/widget/custom_textfields.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
import 'package:taskoteladmin/features/master_hotel/data/masterhotel_firebaserepo.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/cubit/master-task/master_task_form_cubit.dart';

class TaskEditCreateForm extends StatelessWidget {
  final String hotelId;
  final CommonTaskModel? taskToEdit;

  const TaskEditCreateForm({super.key, required this.hotelId, this.taskToEdit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MasterTaskFormCubit(masterHotelRepo: MasterHotelFirebaseRepo())
            ..initializeForm(taskToEdit),
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
              SnackBar(
                content: Text(
                  state.isEditMode
                      ? 'Task updated successfully!'
                      : 'Task created successfully!',
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<MasterTaskFormCubit>();

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Header
                _buildHeader(context, state),

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
                          _buildBasicInformationSection(cubit, state),
                          const SizedBox(height: 24),

                          // Task Configuration Section
                          _buildTaskConfigurationSection(cubit, state),
                          const SizedBox(height: 24),

                          // Questions Section
                          _buildQuestionsSection(cubit, state),
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
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MasterTaskFormState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderGrey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            state.isEditMode ? "Edit Master Task" : "Create Master Task",
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

  Widget _buildBasicInformationSection(
    MasterTaskFormCubit cubit,
    MasterTaskFormState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Basic Information", style: AppTextStyles.textFieldTitle),
        const SizedBox(height: 16),

        // User Category
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
              cubit.selectUserCategory(value);
            }
          },
        ),
        const SizedBox(height: 16),

        // Task Title
        CustomTextField(
          controller: cubit.titleController,
          title: "Task Title",
          hintText: "Enter task title",
          validator: true,
        ),
        const SizedBox(height: 16),

        // Description
        CustomTextField(
          controller: cubit.descController,
          title: "Description",
          hintText: "Enter task description",
          validator: true,
        ),
      ],
    );
  }

  Widget _buildTaskConfigurationSection(
    MasterTaskFormCubit cubit,
    MasterTaskFormState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Task Configuration", style: AppTextStyles.textFieldTitle),
        const SizedBox(height: 16),

        // Frequency and Day/Date
        Row(
          children: [
            Expanded(
              child: CustomDropDownField(
                title: "Frequency",
                hintText: "Select frequency",
                initialValue: state.selectedFrequency,
                validatorText: "Please select frequency",
                items: frequencies
                    .map(
                      (freq) =>
                          DropdownMenuItem(value: freq, child: Text(freq)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    cubit.selectFrequency(value);
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: cubit.dayOrDateController,
                title: "Day/Date",
                hintText: "e.g., Monday or 1",
                validator: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Duration and Place
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: cubit.durationController,
                title: "Duration",
                hintText: "e.g., 30 mins",
                validator: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: cubit.placeController,
                title: "Place/Location",
                hintText: "e.g., Lobby",
                validator: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuestionsSection(
    MasterTaskFormCubit cubit,
    MasterTaskFormState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Task Questions", style: AppTextStyles.textFieldTitle),
        const SizedBox(height: 16),

        // Add Question Input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: cubit.questionController,
                decoration: InputDecoration(
                  hintText: "Add a question for this task",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => cubit.addQuestion(),
              child: const Text("Add"),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Questions List
        if (state.questions.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderGrey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: state.questions.asMap().entries.map((entry) {
                final index = entry.key;
                final question = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Q${index + 1}',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          question['question'] ?? '',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      IconButton(
                        onPressed: () => cubit.removeQuestion(index),
                        icon: const Icon(
                          CupertinoIcons.minus_circle,
                          size: 18,
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

  Widget _buildSettingsSection(
    MasterTaskFormCubit cubit,
    MasterTaskFormState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Settings", style: AppTextStyles.textFieldTitle),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text("Active Task"),
          subtitle: const Text("Task is available for assignment"),
          value: state.isActive,
          onChanged: (value) => cubit.updateActiveStatus(value),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    MasterTaskFormCubit cubit,
    MasterTaskFormState state,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderGrey)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Cancel"),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: state.isCreating
                  ? null
                  : () => cubit.submitForm(context, hotelId, taskToEdit),
              child: state.isCreating
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(state.isEditMode ? "Update Task" : "Create Task"),
            ),
          ),
        ],
      ),
    );
  }
}
