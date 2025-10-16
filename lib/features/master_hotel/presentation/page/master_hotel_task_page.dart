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
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
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
          _buildHeaderMobile(context),
          const SizedBox(height: 20),
          CustomContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Task Management",
                  style: AppTextStyles.dialogHeading.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 16),
                _buildRoleTabsMobile(state),
                const SizedBox(height: 16),
                _buildSearchBarMobile(),
                const SizedBox(height: 16),
                _buildTaskListMobile(state),
              ],
            ),
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
          _buildHeader(context, isTablet: true),
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
          _buildHeader(context),
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
  Widget _buildHeader(BuildContext context, {bool isTablet = false}) {
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

  // Mobile Task List (Card View)
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

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:taskoteladmin/core/theme/app_colors.dart';
// import 'package:taskoteladmin/core/theme/app_text_styles.dart';
// import 'package:taskoteladmin/core/utils/const.dart';
// import 'package:taskoteladmin/core/utils/helpers.dart';
// import 'package:taskoteladmin/core/widget/custom_container.dart';
// import 'package:taskoteladmin/core/widget/page_header.dart';
// import 'package:taskoteladmin/core/widget/tabel_widgets.dart';
// import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
// import 'package:taskoteladmin/features/master_hotel/presentation/cubit/master-task/master_task_form_cubit.dart';
// import 'package:taskoteladmin/features/master_hotel/presentation/cubit/master-task/masterhotel_task_cubit.dart';
// import 'package:taskoteladmin/features/master_hotel/presentation/widgets/mastertask_edit_form.dart';
// import 'package:taskoteladmin/features/master_hotel/presentation/widgets/mastertask_excel_form.dart';

// class MasterHotelTaskPage extends StatefulWidget {
//   final String hotelId;
//   final String HotelName;
//   MasterHotelTaskPage({
//     super.key,
//     required this.hotelId,
//     required this.HotelName,
//   });

//   @override
//   State<MasterHotelTaskPage> createState() => _MasterHotelTaskPageState();
// }

// class _MasterHotelTaskPageState extends State<MasterHotelTaskPage> {
//   @override
//   void initState() {
//     super.initState();
//     final cubit = context.read<MasterhotelTaskCubit>();
//     cubit.loadTasksForHotel(widget.hotelId, UserRoles.rm);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<MasterhotelTaskCubit, MasterhotelTaskState>(
//       builder: (context, state) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(context),

//               const SizedBox(height: 30),
//               Expanded(
//                 child: CustomContainer(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Task Management",
//                         style: AppTextStyles.dialogHeading,
//                       ),
//                       const SizedBox(height: 20),

//                       // Role Tabs
//                       _buildRoleTabs(state),
//                       const SizedBox(height: 20),

//                       // Search Bar
//                       _buildSearchBar(),
//                       const SizedBox(height: 20),

//                       // Task Table
//                       _buildTaskTable(state),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // Header
//   Widget _buildHeader(BuildContext context) {
//     return PageHeaderWithButton(
//       heading: widget.HotelName,
//       subHeading: "Manage master tasks and franchise details",
//       buttonText: "Create Task",
//       onButtonPressed: () {
//         showDialog(
//           context: context,
//           builder: (context) =>
//               Dialog(child: MasterTaskExcelFormScreen(hotelId: widget.hotelId)),
//         );
//       },
//     );
//   }

//   // Role Tabs
//   Widget _buildRoleTabs(MasterhotelTaskState state) {
//     // Create a map for the segmented control
//     Map<String, Widget> segmentedControlTabs = {};

//     for (String tab in roles.map((role) => role['key']!).toList()) {
//       final isSelected = state.selectedTab == tab;

//       segmentedControlTabs[tab] = Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         child: Text(
//           state.getTabDisplayName(tab),

//           style: GoogleFonts.inter(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: isSelected ? Color(0xff040917) : AppColors.slateGray,
//           ),
//         ),
//       );
//     }

//     return Container(
//       width: double.infinity,
//       child: CupertinoSlidingSegmentedControl<String>(
//         children: segmentedControlTabs,
//         groupValue: state.selectedTab,

//         onValueChanged: (String? value) {
//           if (value != null) {
//             context.read<MasterhotelTaskCubit>().switchTab(
//               value,
//               widget.hotelId,
//             );
//           }
//         },
//         backgroundColor: AppColors.slateLightGray,
//         thumbColor: Colors.white,
//         padding: const EdgeInsets.all(4),
//       ),
//     );
//   }

//   // Search Bar
//   Widget _buildSearchBar() {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             height: 45,
//             child: TextFormField(
//               controller: context.read<MasterhotelTaskCubit>().serachController,
//               onChanged: (value) {
//                 context.read<MasterhotelTaskCubit>().searchTasks();
//               },
//               cursorHeight: 18,
//               decoration: InputDecoration(
//                 hintText: " Search tasks...",
//                 prefixIcon: Icon(
//                   CupertinoIcons.search,
//                   color: AppColors.slateGray,
//                   size: 18,
//                 ),
//                 // hint: Center(child: Text("Search tasks...")),
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: AppColors.slateLightGray,
//                     width: 1.5,
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: AppColors.slateLightGray,
//                     width: 1.5,
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: AppColors.slateLightGray,
//                     width: 1.5,
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),

//               // contentPadding: EdgeInsets.symmetric(vertical: 12),
//             ),
//           ),
//         ),

//         SizedBox(width: 12),
//         IconButton(
//           onPressed: () {
//             context.read<MasterhotelTaskCubit>().exportTasksToExcel(
//               context.read<MasterhotelTaskCubit>().state.filteredTasks,
//             );
//           },
//           icon: Icon(CupertinoIcons.cloud_download, color: Colors.grey),
//         ),
//       ],
//     );
//   }

//   // Task Table
//   Widget _buildTaskTable(MasterhotelTaskState state) {
//     return Expanded(
//       child: Column(
//         children: [
//           // Table Header
//           Row(
//             children: [
//               SizedBox(width: TableConfig.horizontalSpacing),
//               _buildTableHeader("Task ID", flex: 1),
//               _buildTableHeader("Task Title", flex: 2),
//               _buildTableHeader("Description", flex: 2),
//               _buildTableHeader("Frequency", flex: 1),
//               // _buildTableHeader("Priority", flex: 1),
//               _buildTableHeader("Est. Completion Time", flex: 2),
//               // _buildTableHeader("Status", flex: 1),
//               _buildTableHeader("Active", flex: 1),
//               _buildTableHeader("Actions", flex: 1),
//               // _buildTableHeader("Actions", flex: 1),
//             ],
//           ),
//           // const Divider(thickness: 0.5),
//           const SizedBox(height: 13),
//           const Divider(color: AppColors.slateGray, thickness: 0.07, height: 0),
//           // Task Rows
//           if (state.isLoadingTasks)
//             const Expanded(child: Center(child: CircularProgressIndicator()))
//           else if (state.filteredTasks.isEmpty)
//             const Expanded(child: Center(child: Text("No tasks found")))
//           else
//             Expanded(
//               child: ListView.separated(
//                 shrinkWrap: true,
//                 separatorBuilder: (context, index) => Divider(
//                   color: AppColors.slateGray,
//                   thickness: 0.07,
//                   height: 0,
//                 ),
//                 itemCount: state.filteredTasks.length,
//                 itemBuilder: (context, index) {
//                   final task = state.filteredTasks[index];

//                   return _buildTaskRow(task, index);
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   // Table Header
//   Widget _buildTableHeader(String title, {int flex = 1}) {
//     return Expanded(
//       flex: flex,
//       child: Text(title, style: AppTextStyles.tabelHeader),
//     );
//   }

//   // Task Row
//   Widget _buildTaskRow(CommonTaskModel task, int index) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               SizedBox(width: TableConfig.horizontalSpacing),
//               Expanded(
//                 flex: 1,
//                 child: Text(task.taskId, style: AppTextStyles.tableRowPrimary),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Text(task.title, style: AppTextStyles.tableRowPrimary),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Text(
//                   task.desc,
//                   style: AppTextStyles.tableRowSecondary,
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 2,
//                 ),
//               ),

//               Expanded(
//                 flex: 1,
//                 child: Text(
//                   task.frequency,
//                   style: AppTextStyles.tableRowRegular,
//                 ),
//               ),

//               Expanded(
//                 flex: 2,
//                 child: Text(
//                   task.duration,
//                   style: AppTextStyles.tableRowRegular,
//                 ),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Transform.scale(
//                       scale: 0.7,

//                       child: CupertinoSwitch(
//                         activeTrackColor: AppColors.primary,
//                         value: task.isActive,
//                         onChanged: (value) {
//                           context.read<MasterhotelTaskCubit>().toggleTaskStatus(
//                             task.docId,
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     PopupMenuButton(
//                       icon: Icon(
//                         Icons.more_horiz,
//                         size: TableConfig.mediumIconSize,
//                         color: AppColors.textBlackColor,
//                       ),
//                       itemBuilder: (context) => [
//                         PopupMenuItem(
//                           child: Row(
//                             children: [
//                               Icon(Icons.edit, size: 16),
//                               SizedBox(width: 8),
//                               Text('Edit'),
//                             ],
//                           ),
//                           onTap: () {
//                             showDialog(
//                               context: context,
//                               builder: (context) => Dialog(
//                                 child: Container(
//                                   constraints: BoxConstraints(maxWidth: 600),
//                                   child: TaskEditCreateForm(
//                                     hotelId: widget.hotelId,
//                                     taskToEdit: task,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         PopupMenuItem(
//                           child: Row(
//                             children: [
//                               Icon(
//                                 CupertinoIcons.delete,
//                                 size: 16,
//                                 color: Colors.red,
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 'Delete',
//                                 style: GoogleFonts.inter(color: Colors.red),
//                               ),
//                             ],
//                           ),
//                           onTap: () {
//                             showConfirmDeletDialog<
//                               MasterhotelTaskCubit,
//                               MasterhotelTaskState
//                             >(
//                               context: context,
//                               onBtnTap: () {
//                                 context.read<MasterhotelTaskCubit>().deleteTask(
//                                   task.docId,
//                                 );
//                               },
//                               title: "Delete Task",
//                               message:
//                                   "Are you sure you want to delete this task?",
//                               btnText: "Delete",
//                               isLoadingSelector: (state) => state.isLoading,
//                               successMessageSelector: (state) =>
//                                   state.message ?? "",
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           // const SizedBox(height: 8),
//           // const Divider(thickness: 0.1),
//         ],
//       ),
//     );
//   }
// }
