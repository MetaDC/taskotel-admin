import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/core/utils/helpers.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/core/widget/tabel_widgets.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/cubit/master-task/master_task_form_cubit.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/cubit/master-task/masterhotel_task_cubit.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/widgets/mastertask_edit_form.dart';
import 'package:taskoteladmin/features/master_hotel/presentation/widgets/mastertask_excel_form.dart';

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
  @override
  void initState() {
    super.initState();
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
              _buildHeader(context),

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

  // Header
  Widget _buildHeader(BuildContext context) {
    return PageHeaderWithButton(
      heading: widget.HotelName,
      subHeading: "Manage master tasks and franchise details",
      buttonText: "Create Task",
      onButtonPressed: () {
        showDialog(
          context: context,
          builder: (context) =>
              Dialog(child: MasterTaskExcelFormScreen(hotelId: widget.hotelId)),
        );
      },
    );
  }

  // Role Tabs
  Widget _buildRoleTabs(MasterhotelTaskState state) {
    // Create a map for the segmented control
    Map<String, Widget> segmentedControlTabs = {};

    for (String tab in roles.map((role) => role['key']!).toList()) {
      final isSelected = state.selectedTab == tab;

      segmentedControlTabs[tab] = Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          state.getTabDisplayName(tab),

          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Color(0xff040917) : AppColors.slateGray,
          ),
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

  // Search Bar
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 45,
            child: TextFormField(
              controller: context.read<MasterhotelTaskCubit>().serachController,
              onChanged: (value) {
                context.read<MasterhotelTaskCubit>().searchTasks();
              },
              cursorHeight: 18,
              decoration: InputDecoration(
                hintText: " Search tasks...",
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: AppColors.slateGray,
                  size: 18,
                ),
                // hint: Center(child: Text("Search tasks...")),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.slateLightGray,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.slateLightGray,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.slateLightGray,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              // contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        SizedBox(width: 12),
        IconButton(
          onPressed: () {
            context.read<MasterhotelTaskCubit>().exportTasksToExcel(
              context.read<MasterhotelTaskCubit>().state.filteredTasks,
            );
          },
          icon: Icon(CupertinoIcons.cloud_download, color: Colors.grey),
        ),
      ],
    );
  }

  // Task Table
  Widget _buildTaskTable(MasterhotelTaskState state) {
    return Expanded(
      child: Column(
        children: [
          // Table Header
          Row(
            children: [
              SizedBox(width: TableConfig.horizontalSpacing),
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
          // const Divider(thickness: 0.5),
          const SizedBox(height: 13),
          const Divider(color: AppColors.slateGray, thickness: 0.07, height: 0),
          // Task Rows
          if (state.isLoadingTasks)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (state.filteredTasks.isEmpty)
            const Expanded(child: Center(child: Text("No tasks found")))
          else
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.slateGray,
                  thickness: 0.07,
                  height: 0,
                ),
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

  // Table Header
  Widget _buildTableHeader(String title, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(title, style: AppTextStyles.tabelHeader),
    );
  }

  // Task Row
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
                child: Text(task.taskId, style: AppTextStyles.tableRowPrimary),
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
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.scale(
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
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
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
                                style: GoogleFonts.inter(color: Colors.red),
                              ),
                            ],
                          ),
                          onTap: () {
                            showConfirmDeletDialog<
                              MasterhotelTaskCubit,
                              MasterhotelTaskState
                            >(
                              context: context,
                              onBtnTap: () {
                                context.read<MasterhotelTaskCubit>().deleteTask(
                                  task.docId,
                                );
                              },
                              title: "Delete Task",
                              message:
                                  "Are you sure you want to delete this task?",
                              btnText: "Delete",
                              isLoadingSelector: (state) => state.isLoading,
                              successMessageSelector: (state) =>
                                  state.message ?? "",
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // const SizedBox(height: 8),
          // const Divider(thickness: 0.1),
        ],
      ),
    );
  }
}
