import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
              SnackBar(
                content: Text(
                  state.isEditMode
                      ? 'Task updated successfully!'
                      : 'Task created successfully!',
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<MasterTaskFormCubit>();

          return Container(
            constraints: const BoxConstraints(maxWidth: 700),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                _buildHeader(context, state),

                // Form Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
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
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              CupertinoIcons.doc_text_fill,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              state.isEditMode ? "Edit Master Task" : "Create Master Task",
              style: GoogleFonts.inter(
                fontSize: 18,
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

  Widget _buildBasicInformationSection(
    MasterTaskFormCubit cubit,
    MasterTaskFormState state,
  ) {
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
              style: AppTextStyles.textFieldTitle.copyWith(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // User Category
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
              cubit.selectUserCategory(value);
            }
          },
          validator: true,
        ),
        const SizedBox(height: 16),

        // Task Title
        CustomTextField(
          controller: cubit.titleController,
          title: "Task Title *",
          hintText: "Enter task title",
          validator: true,
        ),
        const SizedBox(height: 16),

        // Description
        CustomDescTextField(
          controller: cubit.descController,
          title: "Description",
          hintText: "Enter task description",
          maxChars: 250,
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
                size: 16,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Task Configuration",
              style: AppTextStyles.textFieldTitle.copyWith(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Frequency and Day/Date
        Row(
          children: [
            Expanded(
              child: CustomDropDownField(
                title: "Frequency *",
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
                validator: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: cubit.dayOrDateController,
                title: "Day/Date *",
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
                title: "Duration *",
                hintText: "e.g., 30 mins",
                validator: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: cubit.placeController,
                title: "Place/Location *",
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
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                CupertinoIcons.question_circle_fill,
                size: 16,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Task Questions",
              style: AppTextStyles.textFieldTitle.copyWith(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 20),

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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => cubit.addQuestion(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(CupertinoIcons.add, size: 18),
                label: const Text("Add"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Questions List
        if (state.questions.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderGrey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: state.questions.asMap().entries.map((entry) {
                final index = entry.key;
                final question = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Q${index + 1}',
                          style: GoogleFonts.inter(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          question.question ?? '',
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                      ),
                      IconButton(
                        onPressed: () => cubit.removeQuestion(index),
                        icon: const Icon(
                          CupertinoIcons.trash,
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
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                CupertinoIcons.gear_alt_fill,
                size: 16,
                color: Colors.purple.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Settings",
              style: AppTextStyles.textFieldTitle.copyWith(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderGrey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SwitchListTile(
            title: Text(
              "Active Task",
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              "Task is available for assignment",
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
            ),
            value: state.isActive,
            onChanged: (value) => cubit.updateActiveStatus(value),
          ),
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
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderGrey)),
      ),
      child: Row(
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
                onPressed: state.isCreating
                    ? null
                    : () => cubit.submitForm(context, hotelId, taskToEdit),
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
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        state.isEditMode ? "Update Task" : "Create Task",
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

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:taskoteladmin/core/theme/app_colors.dart';
// import 'package:taskoteladmin/core/theme/app_text_styles.dart';
// import 'package:taskoteladmin/core/utils/const.dart';
// import 'package:taskoteladmin/core/widget/custom_textfields.dart';
// import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
// import 'package:taskoteladmin/features/master_hotel/data/masterhotel_firebaserepo.dart';
// import 'package:taskoteladmin/features/master_hotel/presentation/cubit/master-task/master_task_form_cubit.dart';

// class TaskEditCreateForm extends StatelessWidget {
//   final String hotelId;
//   final CommonTaskModel? taskToEdit;

//   const TaskEditCreateForm({super.key, required this.hotelId, this.taskToEdit});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           MasterTaskFormCubit(masterHotelRepo: MasterHotelFirebaseRepo())
//             ..initializeForm(taskToEdit),
//       child: BlocConsumer<MasterTaskFormCubit, MasterTaskFormState>(
//         listener: (context, state) {
//           if (state.errorMessage != null) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.errorMessage!),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }

//           if (state.validationMessage != null) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.validationMessage!),
//                 backgroundColor: Colors.orange,
//               ),
//             );
//           }

//           if (state.isSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   state.isEditMode
//                       ? 'Task updated successfully!'
//                       : 'Task created successfully!',
//                 ),
//                 backgroundColor: Colors.green,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           final cubit = context.read<MasterTaskFormCubit>();

//           return Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Column(
//               children: [
//                 // Header
//                 _buildHeader(context, state),

//                 // Form Content
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(20),
//                     child: Form(
//                       key: cubit.formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Basic Information Section
//                           _buildBasicInformationSection(cubit, state),
//                           const SizedBox(height: 24),

//                           // Task Configuration Section
//                           _buildTaskConfigurationSection(cubit, state),
//                           const SizedBox(height: 24),

//                           // Questions Section
//                           _buildQuestionsSection(cubit, state),
//                           const SizedBox(height: 24),

//                           // Settings Section
//                           _buildSettingsSection(cubit, state),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Action Buttons
//                 _buildActionButtons(context, cubit, state),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context, MasterTaskFormState state) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         border: Border(bottom: BorderSide(color: AppColors.borderGrey)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             state.isEditMode ? "Edit Master Task" : "Create Master Task",
//             style: AppTextStyles.dialogHeading,
//           ),
//           IconButton(
//             onPressed: () {
//               if (Navigator.canPop(context)) {
//                 Navigator.of(context).pop();
//               }
//             },
//             icon: const Icon(CupertinoIcons.xmark),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBasicInformationSection(
//     MasterTaskFormCubit cubit,
//     MasterTaskFormState state,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Basic Information", style: AppTextStyles.textFieldTitle),
//         const SizedBox(height: 16),

//         // User Category
//         CustomDropDownField(
//           title: "User Category",
//           hintText: "Select user category",
//           initialValue: state.selectedCategory,
//           validatorText: "Please select a user category",
//           items: roles.map((item) {
//             return DropdownMenuItem(
//               value: item['key'],
//               child: Text(item['name'] ?? ''),
//             );
//           }).toList(),
//           onChanged: (value) {
//             if (value != null) {
//               cubit.selectUserCategory(value);
//             }
//           },
//         ),
//         const SizedBox(height: 16),

//         // Task Title
//         CustomTextField(
//           controller: cubit.titleController,
//           title: "Task Title",
//           hintText: "Enter task title",
//           validator: true,
//         ),
//         const SizedBox(height: 16),

//         // Description
//         CustomTextField(
//           controller: cubit.descController,
//           title: "Description",
//           hintText: "Enter task description",
//           validator: true,
//         ),
//       ],
//     );
//   }

//   Widget _buildTaskConfigurationSection(
//     MasterTaskFormCubit cubit,
//     MasterTaskFormState state,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Task Configuration", style: AppTextStyles.textFieldTitle),
//         const SizedBox(height: 16),

//         // Frequency and Day/Date
//         Row(
//           children: [
//             Expanded(
//               child: CustomDropDownField(
//                 title: "Frequency",
//                 hintText: "Select frequency",
//                 initialValue: state.selectedFrequency,
//                 validatorText: "Please select frequency",
//                 items: frequencies
//                     .map(
//                       (freq) =>
//                           DropdownMenuItem(value: freq, child: Text(freq)),
//                     )
//                     .toList(),
//                 onChanged: (value) {
//                   if (value != null) {
//                     cubit.selectFrequency(value);
//                   }
//                 },
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: CustomTextField(
//                 controller: cubit.dayOrDateController,
//                 title: "Day/Date",
//                 hintText: "e.g., Monday or 1",
//                 validator: true,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),

//         // Duration and Place
//         Row(
//           children: [
//             Expanded(
//               child: CustomTextField(
//                 controller: cubit.durationController,
//                 title: "Duration",
//                 hintText: "e.g., 30 mins",
//                 validator: true,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: CustomTextField(
//                 controller: cubit.placeController,
//                 title: "Place/Location",
//                 hintText: "e.g., Lobby",
//                 validator: true,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildQuestionsSection(
//     MasterTaskFormCubit cubit,
//     MasterTaskFormState state,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Task Questions", style: AppTextStyles.textFieldTitle),
//         const SizedBox(height: 16),

//         // Add Question Input
//         Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: cubit.questionController,
//                 decoration: InputDecoration(
//                   hintText: "Add a question for this task",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             ElevatedButton(
//               onPressed: () => cubit.addQuestion(),
//               child: const Text("Add"),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),

//         // Questions List
//         if (state.questions.isNotEmpty) ...[
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               border: Border.all(color: AppColors.borderGrey),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Column(
//               children: state.questions.asMap().entries.map((entry) {
//                 final index = entry.key;
//                 final question = entry.value;
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 8),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.shade50,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           'Q${index + 1}',
//                           style: GoogleFonts.inter(
//                             color: Colors.blue.shade700,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           question['question'] ?? '',
//                           style:  GoogleFonts.inter(fontSize: 14),
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () => cubit.removeQuestion(index),
//                         icon: const Icon(
//                           CupertinoIcons.minus_circle,
//                           size: 18,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _buildSettingsSection(
//     MasterTaskFormCubit cubit,
//     MasterTaskFormState state,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Settings", style: AppTextStyles.textFieldTitle),
//         const SizedBox(height: 16),
//         SwitchListTile(
//           title: const Text("Active Task"),
//           subtitle: const Text("Task is available for assignment"),
//           value: state.isActive,
//           onChanged: (value) => cubit.updateActiveStatus(value),
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButtons(
//     BuildContext context,
//     MasterTaskFormCubit cubit,
//     MasterTaskFormState state,
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
//                 onPressed: state.isCreating
//                     ? null
//                     : () => cubit.submitForm(context, hotelId, taskToEdit),
//                 child: state.isCreating
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : Text(state.isEditMode ? "Update Task" : "Create Task"),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
