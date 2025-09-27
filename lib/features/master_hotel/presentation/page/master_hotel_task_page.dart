import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_detail_cubit.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/cubit/master-task/masterhotel_task_cubit.dart';
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
  Widget build(BuildContext context) {
    return BlocBuilder<MasterhotelTaskCubit, MasterhotelTaskState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                heading: widget.HotelName,
                subHeading: "Manage master tasks and franchise details",
                buttonText: "Create Task",
                onButtonPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => MasterTaskFormScreen(),
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
    Map<RoleTab, Widget> segmentedControlTabs = {};

    for (RoleTab tab in RoleTab.values) {
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
      child: CupertinoSlidingSegmentedControl<RoleTab>(
        children: segmentedControlTabs,
        groupValue: state.selectedTab,
        onValueChanged: (RoleTab? value) {
          if (value != null) {
            context.read<MasterhotelTaskCubit>().switchTab(value);
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
              _buildTableHeader("Status", flex: 1),
              _buildTableHeader("Active", flex: 1),
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
              Expanded(
                flex: 1,
                child: Text(
                  "${task.assignedRole.toUpperCase()} ${index + 1}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  task.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  task.desc,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              Expanded(flex: 1, child: Text(task.frequency)),

              Expanded(flex: 2, child: Text(task.duration)),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    // color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.fromMasterHotel ? "Imported" : "Created",
                    style: TextStyle(
                      // color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    context.read<MasterhotelTaskCubit>().toggleTaskStatus(
                      task.docId,
                    );
                  },
                  child: Text(
                    task.isActive ? "ON" : "OFF",
                    style: TextStyle(
                      color: task.isActive ? Colors.green : AppColors.slateGray,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
