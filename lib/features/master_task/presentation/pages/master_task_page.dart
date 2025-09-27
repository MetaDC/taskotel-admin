// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:taskoteladmin/core/theme/app_text_styles.dart';
// import 'package:taskoteladmin/core/utils/const.dart';
// import 'package:taskoteladmin/core/widget/custom_container.dart';
// import 'package:taskoteladmin/features/master_task/data/mastertask_firebaserepo.dart';
// import 'package:taskoteladmin/features/master_task/domain/model/mastertask_model.dart';
// import 'package:taskoteladmin/features/master_task/presentation/cubit/mastertask_cubit.dart';
// import 'package:taskoteladmin/core/utils/excel_utils.dart';
// import 'package:taskoteladmin/features/master_task/presentation/widgets/create_task_modal.dart';
// import 'package:taskoteladmin/features/master_task/presentation/widgets/import_excel_modal.dart';

// class MasterTaskPage extends StatefulWidget {
//   final String hotelId;
//   final String hotelName;

//   const MasterTaskPage({
//     super.key,
//     required this.hotelId,
//     required this.hotelName,
//   });

//   @override
//   State<MasterTaskPage> createState() => _MasterTaskPageState();
// }

// class _MasterTaskPageState extends State<MasterTaskPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: roles.length, vsync: this);
//     _tabController.addListener(() {
//       if (!_tabController.indexIsChanging) {
//         final selectedRole = roles[_tabController.index]['key']!;
//         context.read<MasterTaskCubit>().changeRole(selectedRole);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           MasterTaskCubit(masterTaskRepo: MasterTaskFirebaseRepo())
//             ..loadAllTasks(widget.hotelId),
//       child: BlocConsumer<MasterTaskCubit, MasterTaskState>(
//         listener: (context, state) {
//           if (state.message != null) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message!),
//                 backgroundColor: state.message!.contains('success')
//                     ? Colors.green
//                     : Colors.red,
//               ),
//             );
//             context.read<MasterTaskCubit>().clearMessage();
//           }
//         },
//         builder: (context, state) {
//           return true
//               ? Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 25,
//                     vertical: 20,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.hotelName,
//                         style: AppTextStyles.headerHeading,
//                       ),
//                       Text(
//                         "Manage master tasks and franchise details",
//                         style: AppTextStyles.headerSubheading,
//                       ),

//                       // Expanded(
//                       //   child: CustomContainer(
//                       //     child: Column(
//                       //       crossAxisAlignment: CrossAxisAlignment.start,
//                       //       children: [
//                       //         Text(
//                       //           "Task Management",
//                       //           style: AppTextStyles.dialogHeading,
//                       //         ),
//                       //         const SizedBox(height: 20),

//                       //         // Role Tabs
//                       //         _buildRoleTabs(state),
//                       //         const SizedBox(height: 20),

//                       //         // Search Bar
//                       //         _buildSearchBar(),
//                       //         const SizedBox(height: 20),

//                       //         // Task Table
//                       //         _buildTaskTable(state),
//                       //       ],
//                       //     ),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 )
//               //
//               : Scaffold(
//                   backgroundColor: const Color(0xFFF8F9FA),
//                   body: Column(
//                     children: [
//                       // Header Section
//                       Container(
//                         color: Colors.white,
//                         padding: const EdgeInsets.all(24),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Back button and title
//                             Row(
//                               children: [
//                                 IconButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   icon: const Icon(Icons.arrow_back),
//                                   padding: EdgeInsets.zero,
//                                   constraints: const BoxConstraints(),
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Text(
//                                   widget.hotelName,
//                                   style: const TextStyle(
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const Spacer(),
//                                 ElevatedButton.icon(
//                                   onPressed: () =>
//                                       _showCreateTaskModal(context),
//                                   icon: const Icon(
//                                     Icons.add,
//                                     color: Colors.white,
//                                   ),
//                                   label: const Text(
//                                     'Create Master Task',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.black,
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 20,
//                                       vertical: 12,
//                                     ),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             const Text(
//                               'Manage master tasks and franchise details',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Tab Bar
//                       Container(
//                         color: Colors.white,
//                         child: TabBar(
//                           controller: _tabController,
//                           isScrollable: false,
//                           labelColor: Colors.blue,
//                           unselectedLabelColor: Colors.grey,
//                           indicatorColor: Colors.blue,
//                           indicatorWeight: 2,
//                           tabs: roles
//                               .map((role) => Tab(text: role['name']))
//                               .toList(),
//                         ),
//                       ),

//                       // Content Area
//                       Expanded(
//                         child: Container(
//                           color: const Color(0xFFF8F9FA),
//                           child: TabBarView(
//                             controller: _tabController,
//                             children: roles.map((role) {
//                               return _buildRoleTasksView(context, state, role);
//                             }).toList(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//         },
//       ),
//     );
//   }

//   Widget _buildRoleTasksView(
//     BuildContext context,
//     MasterTaskState state,
//     Map<String, String> role,
//   ) {
//     final roleKey = role['key']!;
//     final roleName = role['name']!;
//     final tasks = state.tasksByRole[roleKey] ?? [];
//     final filteredTasks = _getFilteredTasks(tasks, state);

//     return Container(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Role Title and Task Count
//           Row(
//             children: [
//               Text(
//                 '$roleName Tasks',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   '${filteredTasks.length} tasks',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 20),

//           // Controls Row
//           Row(
//             children: [
//               // Search Bar
//               Expanded(
//                 flex: 3,
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Search tasks...',
//                     prefixIcon: const Icon(Icons.search, size: 20),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
//                     ),
//                     filled: true,
//                     fillColor: Colors.white,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                   ),
//                   onChanged: (value) {
//                     context.read<MasterTaskCubit>().searchTasks(value);
//                   },
//                 ),
//               ),

//               const SizedBox(width: 12),

//               // Department Filter (only for Department Manager)
//               if (roleKey == 'dm') ...[
//                 Expanded(
//                   flex: 2,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: const Color(0xFFE0E0E0)),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         value: state.selectedDepartment,
//                         isExpanded: true,
//                         hint: const Text('All Departments'),
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         items:
//                             [
//                               'All Departments',
//                               'Housekeeping',
//                               'Front Office',
//                               'Food & Beverage',
//                               'Maintenance',
//                               'Security',
//                               'Management',
//                               'Guest Services',
//                               'HR',
//                               'Finance',
//                               'Kitchen',
//                               'Laundry',
//                               'Spa & Wellness',
//                             ].map((department) {
//                               return DropdownMenuItem<String>(
//                                 value: department,
//                                 child: Text(department),
//                               );
//                             }).toList(),
//                         onChanged: (value) {
//                           if (value != null) {
//                             context.read<MasterTaskCubit>().changeDepartment(
//                               value,
//                             );
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//               ],

//               // Import/Export Buttons
//               ElevatedButton.icon(
//                 onPressed: () => _exportTasks(context, roleKey, roleName),
//                 icon: const Icon(Icons.download, size: 16),
//                 label: const Text('Export to Excel'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                 ),
//               ),

//               const SizedBox(width: 8),

//               ElevatedButton.icon(
//                 onPressed: () => _showImportExcelModal(context, roleKey),
//                 icon: const Icon(Icons.upload, size: 16),
//                 label: const Text('Import from Excel'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 20),

//           // Tasks Table
//           Expanded(child: _buildTasksTable(context, filteredTasks, roleKey)),
//         ],
//       ),
//     );
//   }

//   Widget _buildTasksTable(
//     BuildContext context,
//     List<MasterTaskModel> tasks,
//     String roleKey,
//   ) {
//     if (tasks.isEmpty) {
//       return Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(40),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: const Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.task_alt, size: 48, color: Colors.grey),
//             SizedBox(height: 16),
//             Text(
//               'No tasks found',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Create your first task to get started',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ],
//         ),
//       );
//     }

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Table Header
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: const BoxDecoration(
//               color: Color(0xFFF8F9FA),
//               borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
//             ),
//             child: Row(
//               children: [
//                 const SizedBox(width: 60), // For Task ID
//                 const Expanded(
//                   flex: 2,
//                   child: Text(
//                     'Task Title',
//                     style: TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 const Expanded(
//                   flex: 3,
//                   child: Text(
//                     'Description',
//                     style: TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 const Expanded(
//                   flex: 1,
//                   child: Text(
//                     'Frequency',
//                     style: TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 if (roleKey == 'dm') ...[
//                   const Expanded(
//                     flex: 1,
//                     child: Text(
//                       'Department',
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ],
//                 const Expanded(
//                   flex: 1,
//                   child: Text(
//                     'Priority',
//                     style: TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 const Expanded(
//                   flex: 1,
//                   child: Text(
//                     'Est. Completion Time',
//                     style: TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 const Expanded(
//                   flex: 1,
//                   child: Text(
//                     'Status',
//                     style: TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 80,
//                   child: Text(
//                     'Actions',
//                     style: TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Table Rows
//           Expanded(
//             child: ListView.builder(
//               itemCount: tasks.length,
//               itemBuilder: (context, index) {
//                 final task = tasks[index];
//                 final taskId = (index + 1).toString().padLeft(3, '0');

//                 return Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(color: Colors.grey.withOpacity(0.1)),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       // Task ID
//                       SizedBox(
//                         width: 60,
//                         child: Text(
//                           taskId,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),

//                       // Task Title
//                       Expanded(
//                         flex: 2,
//                         child: Text(
//                           task.title,
//                           style: const TextStyle(fontWeight: FontWeight.w500),
//                         ),
//                       ),

//                       // Description
//                       Expanded(
//                         flex: 3,
//                         child: Text(
//                           task.desc,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(color: Colors.grey),
//                         ),
//                       ),

//                       // Frequency
//                       Expanded(
//                         flex: 1,
//                         child: _buildFrequencyBadge(task.frequency),
//                       ),

//                       // Department (only for Department Manager)
//                       if (roleKey == 'dm') ...[
//                         Expanded(
//                           flex: 1,
//                           child: Text(
//                             task.departmentId,
//                             style: const TextStyle(fontSize: 12),
//                           ),
//                         ),
//                       ],

//                       // Priority (based on frequency for now)
//                       Expanded(
//                         flex: 1,
//                         child: _buildPriorityBadge(
//                           _getPriority(task.frequency),
//                         ),
//                       ),

//                       // Est. Completion Time
//                       Expanded(
//                         flex: 1,
//                         child: Text(
//                           _formatDuration(task.duration),
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       ),

//                       // Status
//                       Expanded(flex: 1, child: _buildStatusToggle(task)),

//                       // Actions
//                       SizedBox(
//                         width: 80,
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               onPressed: () =>
//                                   _showEditTaskModal(context, task),
//                               icon: const Icon(Icons.edit, size: 16),
//                               padding: EdgeInsets.zero,
//                               constraints: const BoxConstraints(minWidth: 32),
//                             ),
//                             PopupMenuButton<String>(
//                               onSelected: (value) {
//                                 if (value == 'delete') {
//                                   _showDeleteConfirmation(context, task);
//                                 }
//                               },
//                               itemBuilder: (context) => [
//                                 const PopupMenuItem(
//                                   value: 'delete',
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         Icons.delete,
//                                         size: 16,
//                                         color: Colors.red,
//                                       ),
//                                       SizedBox(width: 8),
//                                       Text('Delete'),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                               child: const Icon(Icons.more_horiz, size: 16),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFrequencyBadge(String frequency) {
//     Color color;
//     switch (frequency.toLowerCase()) {
//       case 'daily':
//         color = Colors.blue;
//         break;
//       case 'weekly':
//         color = Colors.blue;
//         break;
//       case 'monthly':
//         color = Colors.blue;
//         break;
//       case 'quarterly':
//         color = Colors.blue;
//         break;
//       default:
//         color = Colors.grey;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         frequency,
//         style: TextStyle(
//           color: color,
//           fontSize: 11,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   Widget _buildPriorityBadge(String priority) {
//     Color color;
//     switch (priority.toLowerCase()) {
//       case 'high':
//         color = Colors.red;
//         break;
//       case 'medium':
//         color = Colors.orange;
//         break;
//       case 'low':
//         color = Colors.green;
//         break;
//       default:
//         color = Colors.grey;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         priority,
//         style: TextStyle(
//           color: color,
//           fontSize: 11,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusToggle(MasterTaskModel task) {
//     return Switch(
//       value: task.isActive,
//       onChanged: (value) {
//         context.read<MasterTaskCubit>().toggleTaskStatus(task.docId, value);
//       },
//       activeColor: Colors.green,
//       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//     );
//   }

//   List<MasterTaskModel> _getFilteredTasks(
//     List<MasterTaskModel> tasks,
//     MasterTaskState state,
//   ) {
//     var filtered = tasks;

//     // Apply search filter
//     if (state.searchQuery.isNotEmpty) {
//       filtered = filtered
//           .where(
//             (task) =>
//                 task.title.toLowerCase().contains(
//                   state.searchQuery.toLowerCase(),
//                 ) ||
//                 task.desc.toLowerCase().contains(
//                   state.searchQuery.toLowerCase(),
//                 ),
//           )
//           .toList();
//     }

//     // Apply department filter (only for Department Manager)
//     if (state.selectedRole == 'dm' &&
//         state.selectedDepartment != 'All Departments') {
//       filtered = filtered
//           .where((task) => task.departmentId == state.selectedDepartment)
//           .toList();
//     }

//     return filtered;
//   }

//   String _getPriority(String frequency) {
//     switch (frequency.toLowerCase()) {
//       case 'daily':
//         return 'High';
//       case 'weekly':
//         return 'High';
//       case 'monthly':
//         return 'Medium';
//       case 'quarterly':
//         return 'Medium';
//       default:
//         return 'Low';
//     }
//   }

//   String _formatDuration(int minutes) {
//     if (minutes < 60) {
//       return '$minutes minutes';
//     } else {
//       final hours = (minutes / 60).floor();
//       final remainingMinutes = minutes % 60;
//       if (remainingMinutes == 0) {
//         return '$hours hour${hours > 1 ? 's' : ''}';
//       } else {
//         return '$hours.${remainingMinutes.toString().padLeft(2, '0')} hours';
//       }
//     }
//   }

//   void _showCreateTaskModal(BuildContext context) {
//     final selectedRole = roles[_tabController.index]['key']!;
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) =>
//           CreateTaskModal(hotelId: widget.hotelId, assignedRole: selectedRole),
//     );
//   }

//   void _showEditTaskModal(BuildContext context, MasterTaskModel task) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => CreateTaskModal(
//         hotelId: widget.hotelId,
//         assignedRole: task.assignedRole,
//         taskToEdit: task,
//       ),
//     );
//   }

//   void _showImportExcelModal(BuildContext context, String userCategory) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) =>
//           ImportExcelModal(hotelId: widget.hotelId, userCategory: userCategory),
//     );
//   }

//   void _exportTasks(
//     BuildContext context,
//     String roleKey,
//     String roleName,
//   ) async {
//     try {
//       final tasks = await context.read<MasterTaskCubit>().exportTasksToExcel(
//         roleKey,
//       );

//       if (tasks.isEmpty) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('No tasks found for $roleName'),
//               backgroundColor: Colors.orange,
//             ),
//           );
//         }
//         return;
//       }

//       await ExcelUtils.exportTasksToExcel(
//         tasks,
//         '${widget.hotelName}_${roleName}_Tasks',
//       );

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('${tasks.length} tasks exported successfully'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to export tasks: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   void _showDeleteConfirmation(BuildContext context, MasterTaskModel task) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Task"),
//         content: Text("Are you sure you want to delete '${task.title}'?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () {
//               context.read<MasterTaskCubit>().deleteTask(task.docId);
//               Navigator.pop(context);
//             },
//             child: const Text("Delete", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }
