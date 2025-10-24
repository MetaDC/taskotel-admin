import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/core/utils/helpers.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/core/widget/tabel_widgets.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
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

    cubit.switchTab(UserRoles.rm, widget.hotelId);
    cubit.loadTasksForHotel(widget.hotelId, UserRoles.rm);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MasterhotelTaskCubit, MasterhotelTaskState>(
      builder: (context, state) {
        return ResponsiveCustomBuilder(
          mobileBuilder: (width) => _buildMobileLayout(state, width),
          tabletBuilder: (width) => _buildTabletLayout(state, width),
          desktopBuilder: (width) => _buildDesktopLayout(state, width),
        );
      },
    );
  }

  // Mobile Layout (< 768px)
  Widget _buildMobileLayout(MasterhotelTaskState state, double width) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, true),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Task Management",
                style: AppTextStyles.dialogHeading.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 16),
              _buildRoleDropdownMobile(state),
              const SizedBox(height: 16),
              _buildSearchBarMobile(),
              const SizedBox(height: 16),
              _buildTaskListMobile(state),
            ],
          ),
        ],
      ),
    );
  }

  // Tablet Layout (768px - 1024px)
  Widget _buildTabletLayout(MasterhotelTaskState state, double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, true),
          const SizedBox(height: 24),
          Expanded(
            child: CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Task Management",
                    style: AppTextStyles.dialogHeading.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 18),
                  _buildRoleTabs(state, isCompact: true),
                  const SizedBox(height: 18),
                  _buildSearchBar(isCompact: true),
                  const SizedBox(height: 18),
                  Expanded(child: _buildTaskTableTablet(state)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Desktop Layout (>= 1024px)
  Widget _buildDesktopLayout(MasterhotelTaskState state, double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, false),
          const SizedBox(height: 30),
          Expanded(
            child: CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Task Management", style: AppTextStyles.dialogHeading),
                  const SizedBox(height: 20),
                  _buildRoleTabs(state),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  Expanded(child: _buildTaskTableDesktop(state)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header for Desktop/Tablet
  Widget _buildHeader(BuildContext context, bool isMobile) {
    return PageHeaderWithButton(
      heading: widget.HotelName,
      subHeading: "Manage master tasks and franchise details",
      buttonText: "Create Task",
      onButtonPressed: () {
        _showCreateTaskDialog(context, isMobile);
      },
    );
  }

  _showCreateTaskDialog(BuildContext context, bool isMobile) {
    if (isMobile) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: MasterTaskExcelFormScreen(hotelId: widget.hotelId),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: MasterTaskExcelFormScreen(hotelId: widget.hotelId),
          );
        },
      );
    }
  }

  // Header for Mobile
  Widget _buildHeaderMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.HotelName,
          style: AppTextStyles.headerHeading.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(
          "Manage master tasks and franchise details",
          style: AppTextStyles.headerSubheading.copyWith(fontSize: 12),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: MasterTaskExcelFormScreen(hotelId: widget.hotelId),
                ),
              );
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text("Create Task"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  // Role Tabs for Desktop/Tablet
  Widget _buildRoleTabs(MasterhotelTaskState state, {bool isCompact = false}) {
    Map<String, Widget> segmentedControlTabs = {};

    for (String tab in roles.map((role) => role['key']!).toList()) {
      final isSelected = state.selectedTab == tab;

      segmentedControlTabs[tab] = Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 10 : 12,
          vertical: isCompact ? 6 : 8,
        ),
        child: Text(
          state.getTabDisplayName(tab),
          style: GoogleFonts.inter(
            fontSize: isCompact ? 13 : 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Color(0xff040917) : AppColors.slateGray,
          ),
        ),
      );
    }

    return SizedBox(
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

  // Role Tabs for Mobile (Scrollable)
  Widget _buildRoleTabsMobile(MasterhotelTaskState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: roles.map((role) {
          final tab = role['key']!;
          final isSelected = state.selectedTab == tab;
          return GestureDetector(
            onTap: () {
              context.read<MasterhotelTaskCubit>().switchTab(
                tab,
                widget.hotelId,
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : AppColors.slateLightGray,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? AppColors.slateGray : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Text(
                state.getTabDisplayName(tab),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.black : AppColors.slateGray,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRoleDropdownMobile(MasterhotelTaskState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: state.selectedTab,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          dropdownColor: Colors.white,
          items: roles.map((role) {
            final key = role['key']!;
            final name = role['name']!;
            return DropdownMenuItem<String>(
              value: key,
              child: Row(
                children: [
                  Icon(
                    _getIconForRole(key),
                    size: 18,
                    color: AppColors.slateGray,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            if (value != null) {
              context.read<MasterhotelTaskCubit>().switchTab(
                value,
                widget.hotelId,
              );
            }
          },
        ),
      ),
    );
  }

  // Helper method to get icons for each role
  IconData _getIconForRole(String roleKey) {
    switch (roleKey) {
      case UserRoles.rm:
        return CupertinoIcons.person_3_fill;
      case UserRoles.gm:
        return CupertinoIcons.person_2_fill;
      case UserRoles.dm:
        return CupertinoIcons.person_badge_plus_fill;
      case UserRoles.operators:
        return CupertinoIcons.person_fill;
      default:
        return CupertinoIcons.square_list;
    }
  }

  // Search Bar for Desktop/Tablet
  Widget _buildSearchBar({bool isCompact = false}) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: isCompact ? 42 : 45,
            child: TextFormField(
              controller: context.read<MasterhotelTaskCubit>().serachController,
              onChanged: (value) {
                context.read<MasterhotelTaskCubit>().searchTasks();
              },
              cursorHeight: isCompact ? 16 : 18,
              style: GoogleFonts.inter(fontSize: isCompact ? 13 : 14),
              decoration: InputDecoration(
                hintText: " Search tasks...",
                hintStyle: GoogleFonts.inter(fontSize: isCompact ? 13 : 14),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: AppColors.slateGray,
                  size: isCompact ? 16 : 18,
                ),
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
          icon: Icon(
            CupertinoIcons.cloud_download,
            color: Colors.grey,
            size: isCompact ? 20 : 24,
          ),
        ),
      ],
    );
  }

  // Search Bar for Mobile
  Widget _buildSearchBarMobile() {
    return Column(
      children: [
        Container(
          height: 42,
          child: TextFormField(
            controller: context.read<MasterhotelTaskCubit>().serachController,
            onChanged: (value) {
              context.read<MasterhotelTaskCubit>().searchTasks();
            },
            cursorHeight: 16,
            style: GoogleFonts.inter(fontSize: 13),
            decoration: InputDecoration(
              hintText: " Search tasks...",
              hintStyle: GoogleFonts.inter(fontSize: 13),
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: AppColors.slateGray,
                size: 16,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  context.read<MasterhotelTaskCubit>().exportTasksToExcel(
                    context.read<MasterhotelTaskCubit>().state.filteredTasks,
                  );
                },
                icon: Icon(
                  CupertinoIcons.cloud_download,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
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
          ),
        ),
      ],
    );
  }

  // Desktop Task Table (Full width, all columns)
  Widget _buildTaskTableDesktop(MasterhotelTaskState state) {
    if (state.isLoadingTasks) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.filteredTasks.isEmpty) {
      return const Center(child: Text("No tasks found"));
    }

    return Column(
      children: [
        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SizedBox(width: TableConfig.horizontalSpacing),
              _buildTableHeader("Task ID", flex: 1),
              _buildTableHeader("Task Title", flex: 2),
              _buildTableHeader("Description", flex: 2),
              _buildTableHeader("Frequency", flex: 1),
              _buildTableHeader("Est. Completion Time", flex: 2),
              _buildTableHeader("Active", flex: 1),
              _buildTableHeader("Actions", flex: 1),
            ],
          ),
        ),
        const SizedBox(height: 13),
        const Divider(color: AppColors.slateGray, thickness: 0.07, height: 0),

        // Task Rows
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) =>
                Divider(color: AppColors.slateGray, thickness: 0.07, height: 0),
            itemCount: state.filteredTasks.length,
            itemBuilder: (context, index) {
              final task = state.filteredTasks[index];
              return _buildTaskRowDesktop(task, index);
            },
          ),
        ),
      ],
    );
  }

  // Tablet Task Table (Compact, some columns hidden)
  Widget _buildTaskTableTablet(MasterhotelTaskState state) {
    if (state.isLoadingTasks) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.filteredTasks.isEmpty) {
      return const Center(child: Text("No tasks found"));
    }

    return Column(
      children: [
        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SizedBox(width: TableConfig.horizontalSpacing - 5),
              _buildTableHeader("ID", flex: 1, fontSize: 13),
              _buildTableHeader("Title", flex: 2, fontSize: 13),
              _buildTableHeader("Frequency", flex: 1, fontSize: 13),
              _buildTableHeader("Time", flex: 2, fontSize: 13),
              _buildTableHeader("Active", flex: 1, fontSize: 13),
              _buildTableHeader("Actions", flex: 1, fontSize: 13),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Divider(color: AppColors.slateGray, thickness: 0.07, height: 0),

        // Task Rows
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) =>
                Divider(color: AppColors.slateGray, thickness: 0.07, height: 0),
            itemCount: state.filteredTasks.length,
            itemBuilder: (context, index) {
              final task = state.filteredTasks[index];
              return _buildTaskRowTablet(task, index);
            },
          ),
        ),
      ],
    );
  }

  // Desktop Task Row (Full width)
  Widget _buildTaskRowDesktop(CommonTaskModel task, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
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
            child: Text(task.frequency, style: AppTextStyles.tableRowRegular),
          ),
          Expanded(
            flex: 2,
            child: Text(task.duration, style: AppTextStyles.tableRowRegular),
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
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                      onTap: () {
                        true
                            ? _showEditTaskDialog(context, task, false)
                            : showDialog(
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
                          message: "Are you sure you want to delete this task?",
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
    );
  }

  _showEditTaskDialog(
    BuildContext context,
    CommonTaskModel task,
    bool isMobile,
  ) {
    if (isMobile) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: TaskEditCreateForm(
              hotelId: widget.hotelId,
              taskToEdit: task,
            ),
          );
        },
      );
    } else {
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
    }
  }

  // Tablet Task Row (Compact)
  Widget _buildTaskRowTablet(CommonTaskModel task, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(width: TableConfig.horizontalSpacing - 5),
          Expanded(
            flex: 1,
            child: Text(
              task.taskId,
              style: AppTextStyles.tableRowPrimary.copyWith(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              task.title,
              style: AppTextStyles.tableRowPrimary.copyWith(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              task.frequency,
              style: AppTextStyles.tableRowRegular.copyWith(fontSize: 11),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              task.duration,
              style: AppTextStyles.tableRowRegular.copyWith(fontSize: 11),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 0.6,
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
                    size: 18,
                    color: AppColors.textBlackColor,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 6),
                          Text('Edit', style: GoogleFonts.inter(fontSize: 12)),
                        ],
                      ),
                      onTap: () {
                        _showEditTaskDialog(context, task, false);
                      },
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.delete,
                            size: 14,
                            color: Colors.red,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Delete',
                            style: GoogleFonts.inter(
                              color: Colors.red,
                              fontSize: 12,
                            ),
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
                          message: "Are you sure you want to delete this task?",
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
    );
  }

  Widget _buildTaskListMobile(MasterhotelTaskState state) {
    if (state.isLoadingTasks) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.filteredTasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.square_list,
                size: 64,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                "No Tasks Found",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slateGray,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Try adjusting your search or filters",
                style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.filteredTasks.length,
      itemBuilder: (context, index) {
        final task = state.filteredTasks[index];
        return _buildTaskCardMobile(task);
      },
    );
  }

  // Replace _buildTaskCardMobile with improved version:

  Widget _buildTaskCardMobile(CommonTaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row - Task ID and Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Task ID Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  task.taskId,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: AppColors.primary,
                  ),
                ),
              ),

              // // Actions
              // Row(
              //   children: [
              //     Transform.scale(
              //       scale: 0.7,
              //       child: CupertinoSwitch(
              //         activeTrackColor: AppColors.primary,
              //         value: task.isActive,
              //         onChanged: (value) {
              //           context.read<MasterhotelTaskCubit>().toggleTaskStatus(
              //             task.docId,
              //           );
              //         },
              //       ),
              //     ),
              //     const SizedBox(width: 4),
              //     PopupMenuButton(
              //       padding: EdgeInsets.zero,
              //       icon: Icon(
              //         Icons.more_vert,
              //         size: 20,
              //         color: AppColors.textBlackColor,
              //       ),
              //       itemBuilder: (context) => [
              //         PopupMenuItem(
              //           child: Row(
              //             children: [
              //               Icon(Icons.edit, size: 18),
              //               SizedBox(width: 8),
              //               Text('Edit'),
              //             ],
              //           ),
              //           onTap: () {
              //             Future.delayed(
              //               const Duration(milliseconds: 100),
              //               () => _showEditTaskDialog(context, task, true),
              //             );
              //           },
              //         ),
              //         PopupMenuItem(
              //           child: Row(
              //             children: [
              //               Icon(
              //                 CupertinoIcons.delete,
              //                 size: 16,
              //                 color: Colors.red,
              //               ),
              //               SizedBox(width: 8),
              //               Text(
              //                 'Delete',
              //                 style: GoogleFonts.inter(color: Colors.red),
              //               ),
              //             ],
              //           ),
              //           onTap: () {
              //             Future.delayed(
              //               const Duration(milliseconds: 100),
              //               () =>
              //                   showConfirmDeletDialog<
              //                     MasterhotelTaskCubit,
              //                     MasterhotelTaskState
              //                   >(
              //                     context: context,
              //                     onBtnTap: () {
              //                       context
              //                           .read<MasterhotelTaskCubit>()
              //                           .deleteTask(task.docId);
              //                     },
              //                     title: "Delete Task",
              //                     message:
              //                         "Are you sure you want to delete this task?",
              //                     btnText: "Delete",
              //                     isLoadingSelector: (state) => state.isLoading,
              //                     successMessageSelector: (state) =>
              //                         state.message ?? "",
              //                   ),
              //             );
              //           },
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
            ],
          ),
          const SizedBox(height: 12),

          // Task Title
          Text(
            task.title,
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // Task Description
          Text(
            task.desc,
            style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Divider
          Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
          const SizedBox(height: 12),

          // Footer - Frequency and Duration
          Row(
            children: [
              // Frequency
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.repeat,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        task.frequency,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 16,
                color: Colors.grey.shade300,
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              // Duration
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.clock,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        task.duration,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Divider
          Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  _showEditTaskDialog(context, task, true);
                },
                child: Icon(Icons.edit, size: 18),
              ),
              const SizedBox(width: 12),
              InkWell(
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
                    message: "Are you sure you want to delete this task?",
                    btnText: "Delete",
                    isLoadingSelector: (state) => state.isLoading,
                    successMessageSelector: (state) => state.message ?? "",
                  );
                },
                child: Icon(CupertinoIcons.delete, size: 18, color: Colors.red),
              ),
              Spacer(),
              const SizedBox(width: 20),

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
        ],
      ),
    );
  }

  /*   // Mobile Task List (Card View)
  Widget _buildTaskListMobile(MasterhotelTaskState state) {
    if (state.isLoadingTasks) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.filteredTasks.isEmpty) {
      return const Center(child: Text("No tasks found"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.filteredTasks.length,
      itemBuilder: (context, index) {
        final task = state.filteredTasks[index];
        return _buildTaskCardMobile(task);
      },
    );
  }

  // Mobile Task Card
  Widget _buildTaskCardMobile(CommonTaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                task.taskId,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Row(
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
                  const SizedBox(width: 8),
                  PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert,
                      size: 20,
                      color: AppColors.textBlackColor,
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                        onTap: () {
                          _showEditTaskDialog(context, task, true);
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
            ],
          ),
          const SizedBox(height: 12),
          Text(
            task.title,
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            task.desc,
            style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
 */
  _buildTableHeader(String title, {int flex = 1, double fontSize = 14}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          title,
          style: AppTextStyles.tabelHeader.copyWith(fontSize: fontSize),
        ),
      ),
    );
  }
}
