import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/core/utils/helpers.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/widget/custom_textfields.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/core/widget/tabel_widgets.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_detail_cubit.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/cubit/master-task/masterhotel_task_cubit.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/widgets/mastertask_edit_form.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/widgets/mastertask_form.dart';

class MasterHotelTaskPage extends StatefulWidget {
  final String hotelId;
  final String HotelName;
  MasterHotelTaskPage({
    super.key,
    required this.hotelId,
    required this.HotelName,
  });

  @override
  State<MasterHotelTaskPage> createState() => _MasterHotelTaskPageState();
}

class _MasterHotelTaskPageState extends State<MasterHotelTaskPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    final cubit = context.read<MasterhotelTaskCubit>();
    cubit.loadTasksForHotel(widget.hotelId, UserRoles.rm);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MasterhotelTaskCubit, MasterhotelTaskState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeaderWithButton(
                heading: widget.HotelName,
                subHeading: "Manage master tasks and franchise details",
                buttonText: "Create Task",
                onButtonPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        MasterTaskFormScreen(hotelId: widget.hotelId),
                  );
                },
              ),

              const SizedBox(height: 30),
              Expanded(
                child: CustomContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Task Management",
                        style: AppTextStyles.dialogHeading,
                      ),
                      const SizedBox(height: 20),

                      // Role Tabs
                      _buildRoleTabs(state),
                      const SizedBox(height: 20),

                      // Search Bar
                      _buildSearchBar(),
                      const SizedBox(height: 20),

                      // Task Table
                      _buildTaskTable(state),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoleTabs(MasterhotelTaskState state) {
    // Create a map for the segmented control
    Map<String, Widget> segmentedControlTabs = {};

    for (String tab in roles.map((role) => role['key']!).toList()) {
      segmentedControlTabs[tab] = Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          state.getTabDisplayName(tab),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      );
    }

    return Container(
      width: double.infinity,
      child: CupertinoSlidingSegmentedControl<String>(
        children: segmentedControlTabs,
        groupValue: state.selectedTab,
        onValueChanged: (String? value) {
          if (value != null) {
            context.read<MasterhotelTaskCubit>().switchTab(
              value,
              widget.hotelId,
            );
          }
        },
        backgroundColor: AppColors.slateLightGray,
        thumbColor: Colors.white,
        padding: const EdgeInsets.all(4),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(CupertinoIcons.search, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: TextEditingController(),
              decoration: const InputDecoration(
                hintText: "Search tasks...",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                context.read<ClientDetailCubit>().searchTasks(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTable(MasterhotelTaskState state) {
    return Expanded(
      child: Column(
        children: [
          // Table Header
          Row(
            children: [
              _buildTableHeader("Task ID", flex: 1),
              _buildTableHeader("Task Title", flex: 2),
              _buildTableHeader("Description", flex: 2),
              _buildTableHeader("Frequency", flex: 1),
              // _buildTableHeader("Priority", flex: 1),
              _buildTableHeader("Est. Completion Time", flex: 2),
              // _buildTableHeader("Status", flex: 1),
              _buildTableHeader("Active", flex: 1),
              _buildTableHeader("Actions", flex: 1),
              // _buildTableHeader("Actions", flex: 1),
            ],
          ),
          const Divider(thickness: 0.5),

          // Task Rows
          if (state.isLoadingTasks)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (state.filteredTasks.isEmpty)
            const Expanded(child: Center(child: Text("No tasks found")))
          else
            Expanded(
              child: ListView.builder(
                itemCount: state.filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = state.filteredTasks[index];

                  return _buildTaskRow(task, index);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskRow(CommonTaskModel task, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: TableConfig.horizontalSpacing),
              Expanded(
                flex: 1,
                child: Text(
                  "${task.assignedRole.toUpperCase()} ${index + 1}",
                  style: AppTextStyles.tableRowPrimary,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(task.title, style: AppTextStyles.tableRowPrimary),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  task.desc,
                  style: AppTextStyles.tableRowSecondary,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),

              Expanded(
                flex: 1,
                child: Text(
                  task.frequency,
                  style: AppTextStyles.tableRowRegular,
                ),
              ),

              Expanded(
                flex: 2,
                child: Text(
                  task.duration,
                  style: AppTextStyles.tableRowRegular,
                ),
              ),
              // Expanded(
              //   flex: 1,
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 8,
              //       vertical: 4,
              //     ),
              //     decoration: BoxDecoration(
              //       // color: statusColor.withOpacity(0.1),
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     child: Text(
              //       task.fromMasterHotel ?? false ? "Imported" : "Created",
              //       style: TextStyle(
              //         // color: statusColor,
              //         fontWeight: FontWeight.w600,
              //         fontSize: 12,
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                flex: 1,
                child: Transform.scale(
                  scale: 0.7,

                  child: CupertinoSwitch(
                    activeTrackColor: AppColors.primary,
                    value: task.isActive,
                    onChanged: (value) {
                      context.read<MasterhotelTaskCubit>().toggleTaskStatus(
                        task.docId,
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          PopupMenuButton(
                            icon: Icon(
                              Icons.more_horiz,
                              size: TableConfig.mediumIconSize,
                              color: AppColors.textBlackColor,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.pencil, size: 16),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 600,
                                        ),
                                        child: TaskEditCreateForm(
                                          hotelId: widget.hotelId,
                                          taskToEdit: task,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.delete,
                                      size: 16,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  showConfirmDeletDialog(
                                    context,
                                    () {
                                      context
                                          .read<MasterhotelTaskCubit>()
                                          .deleteTask(task.docId);
                                    },
                                    "Delete Task",
                                    "Are you sure you want to delete this task ?",
                                    "Delete",
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          IconButton(
                            icon: const Icon(CupertinoIcons.pencil, size: 16),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Container(
                                    constraints: BoxConstraints(maxWidth: 600),
                                    child: TaskEditCreateForm(
                                      hotelId: widget.hotelId,
                                      taskToEdit: task,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
              ),
              // Expanded(
              //   flex: 1,
              //   child: Row(
              //     children: [
              //       IconButton(
              //         icon: const Icon(CupertinoIcons.pencil, size: 16),
              //         onPressed: () {
              //           // Edit task functionality
              //           ScaffoldMessenger.of(context).showSnackBar(
              //             SnackBar(content: Text('Edit task: ${task.docId}')),
              //           );
              //         },
              //       ),
              //       IconButton(
              //         icon: const Icon(CupertinoIcons.delete, size: 16),
              //         onPressed: () {
              //           // Delete task with confirmation
              //           _showDeleteConfirmation(task);
              //         },
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 0.1),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String title, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(title, style: AppTextStyles.tabelHeader),
    );
  }
}

class EditTaskForm extends StatelessWidget {
  const EditTaskForm({super.key, required this.task});
  final CommonTaskModel task;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 600),

      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Edit Task", style: AppTextStyles.dialogHeading),
            SizedBox(height: 20),
            StaggeredGrid.extent(
              maxCrossAxisExtent: 400,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                CustomTextField(
                  controller: TextEditingController(),
                  hintText: 'Task Title',
                  title: 'Title',
                ),
                CustomTextField(
                  controller: TextEditingController(),
                  hintText: 'Task Description',
                  title: 'Description',
                ),
                CustomDropDownField(
                  title: "Frequency",
                  hintText: "Select Frequency",
                  initialValue: task.frequency,
                  validatorText: "Please select a frequency",
                  items: frequencies.map((item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  }).toList(),
                  onChanged: (value) {
                    print("value: $value");
                  },
                ),

                CustomTextField(
                  controller: TextEditingController(),
                  hintText: 'Duration',
                  title: 'Duration',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
