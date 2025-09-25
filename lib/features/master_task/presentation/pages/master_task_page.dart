import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/features/master_task/data/mastertask_firebaserepo.dart';
import 'package:taskoteladmin/features/master_task/domain/model/mastertask_model.dart';
import 'package:taskoteladmin/features/master_task/presentation/cubit/mastertask_cubit.dart';
import 'package:taskoteladmin/features/master_task/presentation/widgets/create_task_modal.dart';
import 'package:taskoteladmin/features/master_task/presentation/widgets/import_excel_modal.dart';
import 'package:taskoteladmin/core/utils/excel_utils.dart';

class MasterTaskPage extends StatefulWidget {
  final String hotelId;
  final String hotelName;

  const MasterTaskPage({
    super.key,
    required this.hotelId,
    required this.hotelName,
  });

  @override
  State<MasterTaskPage> createState() => _MasterTaskPageState();
}

class _MasterTaskPageState extends State<MasterTaskPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: roles.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final selectedRole = roles[_tabController.index]['key']!;
        context.read<MasterTaskCubit>().changeRole(selectedRole);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MasterTaskCubit(masterTaskRepo: MasterTaskFirebaseRepo())
            ..loadAllTasks(widget.hotelId),
      child: BlocConsumer<MasterTaskCubit, MasterTaskState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: state.message!.contains('success')
                    ? Colors.green
                    : Colors.red,
              ),
            );
            context.read<MasterTaskCubit>().clearMessage();
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              children: [
                // Page Header
                PageHeader(
                  heading: "Master Tasks - ${widget.hotelName}",
                  subHeading: "Manage master tasks for hotel operations",
                  buttonText: "Create Task",
                  onButtonPressed: () => _showCreateTaskModal(context),
                ),
                const SizedBox(height: 20),

                // Import/Export Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _exportTasks(context),
                      icon: const Icon(CupertinoIcons.cloud_download),
                      label: const Text("Export to Excel"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => _showImportExcelModal(context),
                      icon: const Icon(CupertinoIcons.doc_on_doc),
                      label: const Text("Import from Excel"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Department Filter (only for Department Manager)
                if (state.selectedRole == 'dm') ...[
                  Row(
                    children: [
                      const Text(
                        'Department:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.borderGrey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: state.selectedDepartment,
                              isExpanded: true,
                              items:
                                  [
                                    'All Departments',
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
                                  ].map((department) {
                                    return DropdownMenuItem<String>(
                                      value: department,
                                      child: Text(department),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  context
                                      .read<MasterTaskCubit>()
                                      .changeDepartment(value);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search tasks...",
                    prefixIcon: const Icon(CupertinoIcons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.slateGray),
                    ),
                  ),
                  onChanged: (value) {
                    context.read<MasterTaskCubit>().searchTasks(value);
                  },
                ),
                const SizedBox(height: 20),

                // Tab Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    tabs: roles.map((role) => Tab(text: role['name'])).toList(),
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.slateGray,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3,
                  ),
                ),
                const SizedBox(height: 20),

                // Tab Content
                SizedBox(
                  height: 600, // Fixed height for the tab view
                  child: TabBarView(
                    controller: _tabController,
                    children: roles.map((role) {
                      return _buildTaskTable(context, state, role['key']!);
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskTable(
    BuildContext context,
    MasterTaskState state,
    String role,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.filteredTasks.isEmpty) {
      return const Center(
        child: Text(
          "No tasks found for this role",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            // Table Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      "Task Title",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Text(
                      "Frequency",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Text(
                      "Duration",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Text(
                      "Status",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Text(
                      "Actions",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            // Table Rows
            ...state.filteredTasks.map(
              (task) => Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.borderGrey),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Text(task.title)),
                    Expanded(
                      flex: 3,
                      child: Text(
                        task.desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildFrequencyBadge(task.frequency),
                    ),
                    Expanded(flex: 1, child: Text("${task.duration} min")),
                    Expanded(flex: 1, child: _buildStatusBadge(task.isActive)),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => _showEditTaskModal(context, task),
                            icon: const Icon(CupertinoIcons.pencil, size: 16),
                          ),
                          IconButton(
                            onPressed: () =>
                                _showDeleteConfirmation(context, task),
                            icon: const Icon(
                              CupertinoIcons.delete,
                              size: 16,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyBadge(String frequency) {
    Color color;
    switch (frequency.toLowerCase()) {
      case 'daily':
        color = Colors.green;
        break;
      case 'weekly':
        color = Colors.blue;
        break;
      case 'monthly':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        frequency,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isActive ? Colors.green : Colors.red),
      ),
      child: Text(
        isActive ? "Active" : "Inactive",
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showCreateTaskModal(BuildContext context) {
    final selectedRole = roles[_tabController.index]['key']!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          CreateTaskModal(hotelId: widget.hotelId, assignedRole: selectedRole),
    );
  }

  void _showEditTaskModal(BuildContext context, MasterTaskModel task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateTaskModal(
        hotelId: widget.hotelId,
        assignedRole: task.assignedRole,
        taskToEdit: task,
      ),
    );
  }

  void _showImportExcelModal(BuildContext context) {
    final selectedRole = roles[_tabController.index]['key']!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          ImportExcelModal(hotelId: widget.hotelId, userCategory: selectedRole),
    );
  }

  void _exportTasks(BuildContext context) async {
    final selectedRole = roles[_tabController.index]['key']!;
    final roleName = roles[_tabController.index]['name']!;

    try {
      final tasks = await context.read<MasterTaskCubit>().exportTasksToExcel(
        selectedRole,
      );

      if (tasks.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No tasks found for $roleName'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      await ExcelUtils.exportTasksToExcel(
        tasks,
        '${widget.hotelName}_${roleName}_Tasks',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${tasks.length} tasks exported successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export tasks: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(BuildContext context, MasterTaskModel task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Task"),
        content: Text("Are you sure you want to delete '${task.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<MasterTaskCubit>().deleteTask(task.docId);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
