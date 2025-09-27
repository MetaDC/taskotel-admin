// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:taskoteladmin/core/theme/app_colors.dart';
// import 'package:taskoteladmin/core/utils/const.dart';
// import 'package:taskoteladmin/features/master_task/domain/model/mastertask_model.dart';
// import 'package:taskoteladmin/features/master_task/presentation/cubit/mastertask_form_cubit.dart';
// import 'package:taskoteladmin/features/master_task/data/mastertask_firebaserepo.dart';

// class CreateTaskModal extends StatelessWidget {
//   final String hotelId;
//   final String assignedRole;
//   final MasterTaskModel? taskToEdit;

//   const CreateTaskModal({
//     Key? key,
//     required this.hotelId,
//     required this.assignedRole,
//     this.taskToEdit,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) {
//         final cubit = MasterTaskFormCubit(
//           masterTaskRepo: MasterTaskFirebaseRepo(),
//         );
//         if (taskToEdit != null) {
//           cubit.initializeForEdit(taskToEdit!);
//         } else {
//           cubit.initializeForCreate(hotelId, assignedRole);
//         }
//         return cubit;
//       },
//       child: BlocConsumer<MasterTaskFormCubit, MasterTaskFormState>(
//         listener: (context, state) {
//           if (state.successMessage != null) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.successMessage!),
//                 backgroundColor: Colors.green,
//               ),
//             );
//             Navigator.pop(context);
//           }
//           if (state.errorMessage != null) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.errorMessage!),
//                 backgroundColor: Colors.red,
//               ),
//             );
//             context.read<MasterTaskFormCubit>().clearMessages();
//           }
//         },
//         builder: (context, state) {
//           return Container(
//             height: MediaQuery.of(context).size.height * 0.9,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: Column(
//               children: [
//                 _buildHeader(context, state),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(20),
//                     child: _buildForm(context, state),
//                   ),
//                 ),
//                 _buildBottomActions(context, state),
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
//         color: Color(0xFFF8F9FA),
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.blue.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               state.isEditMode ? Icons.edit : Icons.add,
//               color: Colors.blue,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             state.isEditMode ? 'Edit Master Task' : 'Create Master Task',
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const Spacer(),
//           IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: const Icon(Icons.close),
//             style: IconButton.styleFrom(
//               backgroundColor: Colors.grey.withOpacity(0.1),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildForm(BuildContext context, MasterTaskFormState state) {
//     final cubit = context.read<MasterTaskFormCubit>();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Basic Information
//         _buildSectionTitle('Basic Information'),
//         const SizedBox(height: 16),

//         _buildTextField(
//           label: 'Task Title',
//           value: state.title,
//           onChanged: cubit.updateTitle,
//           isRequired: true,
//           errorText: cubit.getFieldError('title'),
//         ),
//         const SizedBox(height: 16),

//         _buildTextField(
//           label: 'Description',
//           value: state.description,
//           onChanged: cubit.updateDescription,
//           maxLines: 3,
//           isRequired: true,
//           errorText: cubit.getFieldError('description'),
//         ),

//         const SizedBox(height: 24),

//         // Task Details
//         _buildSectionTitle('Task Details'),
//         const SizedBox(height: 16),

//         Row(
//           children: [
//             Expanded(
//               child: _buildNumberField(
//                 label: 'Duration (minutes)',
//                 value: state.duration,
//                 onChanged: cubit.updateDuration,
//                 isRequired: true,
//                 errorText: cubit.getFieldError('duration'),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: _buildDropdown(
//                 label: 'Frequency',
//                 value: state.selectedFrequency,
//                 items: cubit.getFrequencyOptions(),
//                 onChanged: cubit.updateFrequency,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),

//         Row(
//           children: [
//             Expanded(
//               child: _buildDropdown(
//                 label: 'Assigned Role',
//                 value: state.assignedRole,
//                 items: roles.map((role) => role['key']!).toList(),
//                 itemLabels: roles.map((role) => role['name']!).toList(),
//                 onChanged: cubit.updateAssignedRole,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: _buildDropdown(
//                 label: 'Department',
//                 value: state.department,
//                 items: cubit.getCurrentDepartmentOptions(),
//                 onChanged: cubit.updateDepartment,
//                 isRequired: true,
//                 errorText: cubit.getFieldError('department'),
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 24),

//         // Optional Details
//         _buildSectionTitle('Optional Details'),
//         const SizedBox(height: 16),

//         Row(
//           children: [
//             Expanded(
//               child: _buildTextField(
//                 label: 'Place/Location',
//                 value: state.place,
//                 onChanged: cubit.updatePlace,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: _buildTextField(
//                 label: 'Day/Date',
//                 value: state.dayOrDate,
//                 onChanged: cubit.updateDayOrDate,
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 20),

//         // Status Toggle
//         _buildStatusToggle(context, state, cubit),

//         const SizedBox(height: 30),
//       ],
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//         color: Colors.black87,
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required String label,
//     required String value,
//     required ValueChanged<String> onChanged,
//     int maxLines = 1,
//     bool isRequired = false,
//     String? errorText,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichText(
//           text: TextSpan(
//             text: label,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//             children: isRequired
//                 ? [
//                     const TextSpan(
//                       text: ' *',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ]
//                 : [],
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           initialValue: value,
//           maxLines: maxLines,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(
//                 color: errorText != null
//                     ? Colors.red
//                     : Colors.grey.withOpacity(0.3),
//               ),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(
//                 color: errorText != null
//                     ? Colors.red
//                     : Colors.grey.withOpacity(0.3),
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(
//                 color: errorText != null ? Colors.red : Colors.blue,
//               ),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 12,
//               vertical: 12,
//             ),
//             filled: true,
//             fillColor: Colors.white,
//             errorText: errorText,
//           ),
//           onChanged: onChanged,
//         ),
//       ],
//     );
//   }

//   Widget _buildNumberField({
//     required String label,
//     required int value,
//     required ValueChanged<int> onChanged,
//     bool isRequired = false,
//     String? errorText,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichText(
//           text: TextSpan(
//             text: label,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//             children: isRequired
//                 ? [
//                     const TextSpan(
//                       text: ' *',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ]
//                 : [],
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           initialValue: value.toString(),
//           keyboardType: TextInputType.number,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(
//                 color: errorText != null
//                     ? Colors.red
//                     : Colors.grey.withOpacity(0.3),
//               ),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(
//                 color: errorText != null
//                     ? Colors.red
//                     : Colors.grey.withOpacity(0.3),
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(
//                 color: errorText != null ? Colors.red : Colors.blue,
//               ),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 12,
//               vertical: 12,
//             ),
//             filled: true,
//             fillColor: Colors.white,
//             errorText: errorText,
//           ),
//           onChanged: (value) {
//             final intValue = int.tryParse(value) ?? 0;
//             onChanged(intValue);
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildDropdown({
//     required String label,
//     required String value,
//     required List<String> items,
//     List<String>? itemLabels,
//     required ValueChanged<String> onChanged,
//     bool isRequired = false,
//     String? errorText,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichText(
//           text: TextSpan(
//             text: label,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//             children: isRequired
//                 ? [
//                     const TextSpan(
//                       text: ' *',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ]
//                 : [],
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: errorText != null
//                   ? Colors.red
//                   : Colors.grey.withOpacity(0.3),
//             ),
//             borderRadius: BorderRadius.circular(8),
//             color: Colors.white,
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: items.contains(value) ? value : items.first,
//               isExpanded: true,
//               items: items.asMap().entries.map((entry) {
//                 final index = entry.key;
//                 final item = entry.value;
//                 final displayText = itemLabels != null
//                     ? itemLabels[index]
//                     : item;

//                 return DropdownMenuItem<String>(
//                   value: item,
//                   child: Text(displayText),
//                 );
//               }).toList(),
//               onChanged: (newValue) {
//                 if (newValue != null) {
//                   onChanged(newValue);
//                 }
//               },
//             ),
//           ),
//         ),
//         if (errorText != null) ...[
//           const SizedBox(height: 4),
//           Text(
//             errorText,
//             style: const TextStyle(color: Colors.red, fontSize: 12),
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _buildStatusToggle(
//     BuildContext context,
//     MasterTaskFormState state,
//     MasterTaskFormCubit cubit,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.withOpacity(0.2)),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             state.isActive ? Icons.toggle_on : Icons.toggle_off,
//             color: state.isActive ? Colors.green : Colors.grey,
//             size: 28,
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Task Status',
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                 ),
//                 Text(
//                   state.isActive
//                       ? 'Task is active and will be assigned'
//                       : 'Task is inactive and will not be assigned',
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           ),
//           Switch(
//             value: state.isActive,
//             onChanged: cubit.updateActiveStatus,
//             activeColor: Colors.green,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomActions(BuildContext context, MasterTaskFormState state) {
//     final cubit = context.read<MasterTaskFormCubit>();

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.grey.withOpacity(0.05),
//         border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: OutlinedButton(
//               onPressed: state.isSubmitting
//                   ? null
//                   : () => Navigator.pop(context),
//               style: OutlinedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 side: const BorderSide(color: Colors.grey),
//               ),
//               child: const Text('Cancel'),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: ElevatedButton(
//               onPressed: state.isSubmitting || !state.isFormValid
//                   ? null
//                   : cubit.saveTask,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 disabledBackgroundColor: Colors.grey.withOpacity(0.3),
//               ),
//               child: state.isSubmitting
//                   ? const SizedBox(
//                       height: 20,
//                       width: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       ),
//                     )
//                   : Text(
//                       state.isEditMode ? 'Update Task' : 'Create Task',
//                       style: const TextStyle(color: Colors.white),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
