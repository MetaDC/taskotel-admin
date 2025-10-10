import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/utils/helpers.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hotel_model.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_detail_cubit.dart';

class HotelDetailPage extends StatefulWidget {
  final String hotelId;
  final String clientId;

  const HotelDetailPage({
    super.key,
    required this.hotelId,
    required this.clientId,
  });

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  @override
  void initState() {
    super.initState();

    final cubit = context.read<ClientDetailCubit>();
    cubit.loadHotelDetails(widget.hotelId);
    cubit.switchTab(RoleTab.regionalManager);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientDetailCubit, ClientDetailState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final hotel = state.hotelDetail;
        if (hotel == null) {
          return const Center(child: Text('Hotel not found'));
        }

        return ResponsiveCustomBuilder(
          mobileBuilder: (width) => _buildMobileLayout(hotel, state, width),
          tabletBuilder: (width) => _buildTabletLayout(hotel, state, width),
          desktopBuilder: (width) => _buildDesktopLayout(hotel, state, width),
        );
      },
    );
  }

  // Mobile Layout (< 768px)
  Widget _buildMobileLayout(
    HotelModel hotel,
    ClientDetailState state,
    double width,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hotel.name,
                style: AppTextStyles.headerHeading.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 4),
              Text(
                "Hotel Management Dashboard",
                style: AppTextStyles.headerSubheading.copyWith(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Hotel Information Card (Mobile)
          _buildHotelInformationCardMobile(hotel),
          const SizedBox(height: 20),

          // Task Management Section
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
                _buildSearchBar(isMobile: true),
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
  Widget _buildTabletLayout(
    HotelModel hotel,
    ClientDetailState state,
    double width,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel.name,
                      style: AppTextStyles.headerHeading.copyWith(fontSize: 20),
                    ),
                    Text(
                      "Hotel Management Dashboard",
                      style: AppTextStyles.headerSubheading.copyWith(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Hotel Information Card (Tablet)
          _buildHotelInformationCard(hotel, isTablet: true),
          const SizedBox(height: 20),

          // Task Management Section
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
                  _buildRoleTabs(state),
                  const SizedBox(height: 18),
                  _buildSearchBar(),
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
  Widget _buildDesktopLayout(
    HotelModel hotel,
    ClientDetailState state,
    double width,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hotel.name, style: AppTextStyles.headerHeading),
                  Text(
                    "Hotel Management Dashboard",
                    style: AppTextStyles.headerSubheading,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Hotel Information Card
          _buildHotelInformationCard(hotel),
          const SizedBox(height: 20),

          // Task Management Section
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

  // Hotel Information Card (Desktop/Tablet)
  Widget _buildHotelInformationCard(HotelModel hotel, {bool isTablet = false}) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(CupertinoIcons.building_2_fill, size: isTablet ? 20 : 22),
              const SizedBox(width: 8),
              Text(
                "Hotel Information",
                style: AppTextStyles.headerHeading.copyWith(
                  fontSize: isTablet ? 18 : 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildInfoColumn(
                  "Location",
                  "${hotel.addressModel.city}, ${hotel.addressModel.state}",
                  CupertinoIcons.placemark,
                  fontSize: isTablet ? 13 : 14,
                ),
              ),
              Expanded(
                child: _buildInfoColumn(
                  "Plan",
                  hotel.subscriptionName,
                  null,
                  isChip: true,
                  chipColor: Colors.blue,
                  fontSize: isTablet ? 13 : 14,
                ),
              ),
              Expanded(
                child: _buildInfoColumn(
                  "Performance",
                  "Excellent",
                  null,
                  isChip: true,
                  chipColor: Colors.green,
                  fontSize: isTablet ? 13 : 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Hotel Information Card (Mobile - Vertical Layout)
  Widget _buildHotelInformationCardMobile(HotelModel hotel) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(CupertinoIcons.building_2_fill, size: 20),
              const SizedBox(width: 8),
              Text(
                "Hotel Information",
                style: AppTextStyles.headerHeading.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoColumn(
            "Location",
            "${hotel.addressModel.city}, ${hotel.addressModel.state}",
            CupertinoIcons.placemark,
            fontSize: 12,
          ),
          const SizedBox(height: 12),
          _buildInfoColumn(
            "Plan",
            hotel.subscriptionName,
            null,
            isChip: true,
            chipColor: Colors.blue,
            fontSize: 12,
          ),
          const SizedBox(height: 12),
          _buildInfoColumn(
            "Performance",
            "Excellent",
            null,
            isChip: true,
            chipColor: Colors.green,
            fontSize: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(
    String label,
    String value,
    IconData? icon, {
    bool isChip = false,
    Color? chipColor,
    double fontSize = 14,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.slateGray,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
            ],
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize + 2,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Role Tabs for Desktop/Tablet
  Widget _buildRoleTabs(ClientDetailState state) {
    Map<RoleTab, Widget> segmentedControlTabs = {};

    for (RoleTab tab in RoleTab.values) {
      segmentedControlTabs[tab] = Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          state.getTabDisplayName(tab),
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      );
    }

    return CupertinoSlidingSegmentedControl<RoleTab>(
      children: segmentedControlTabs,
      groupValue: state.selectedTab,
      onValueChanged: (RoleTab? value) {
        if (value != null) {
          context.read<ClientDetailCubit>().switchTab(value);
        }
      },
      backgroundColor: AppColors.slateLightGray,
      thumbColor: Colors.white,
      padding: const EdgeInsets.all(4),
    );
  }

  // Role Tabs for Mobile (Scrollable)
  Widget _buildRoleTabsMobile(ClientDetailState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: RoleTab.values.map((tab) {
          final isSelected = state.selectedTab == tab;
          return GestureDetector(
            onTap: () {
              context.read<ClientDetailCubit>().switchTab(tab);
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

  Widget _buildSearchBar({bool isMobile = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.search,
            size: isMobile ? 14 : 16,
            color: Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: context.read<ClientDetailCubit>().serachController,
              style: GoogleFonts.inter(fontSize: isMobile ? 13 : 14),
              decoration: InputDecoration(
                hintText: "Search tasks...",
                hintStyle: GoogleFonts.inter(fontSize: isMobile ? 13 : 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: isMobile ? 10 : 12,
                ),
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

  // Desktop Task Table (Full view with all columns)
  Widget _buildTaskTableDesktop(ClientDetailState state) {
    if (state.isLoadingTasks) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.filteredTasks.isEmpty) {
      return const Center(child: Text("No tasks found"));
    }

    return SingleChildScrollView(
      child: Column(
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
                _buildTableHeader("Task ID", flex: 1),
                _buildTableHeader("Task Title", flex: 2),
                _buildTableHeader("Description", flex: 2),
                _buildTableHeader("Frequency", flex: 1),
                _buildTableHeader("Est. Time", flex: 2),
                _buildTableHeader("Status", flex: 1),
                _buildTableHeader("Active", flex: 1),
              ],
            ),
          ),
          const Divider(thickness: 0.5, height: 1),

          // Task Rows
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.filteredTasks.length,
            itemBuilder: (context, index) {
              final task = state.filteredTasks[index];
              return _buildTaskRowDesktop(task, index);
            },
          ),
        ],
      ),
    );
  }

  // Tablet Task Table (Compact view, hidden description)
  Widget _buildTaskTableTablet(ClientDetailState state) {
    if (state.isLoadingTasks) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.filteredTasks.isEmpty) {
      return const Center(child: Text("No tasks found"));
    }

    return SingleChildScrollView(
      child: Column(
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
                _buildTableHeader("ID", flex: 1, fontSize: 13),
                _buildTableHeader("Title", flex: 2, fontSize: 13),
                _buildTableHeader("Frequency", flex: 1, fontSize: 13),
                _buildTableHeader("Time", flex: 2, fontSize: 13),
                _buildTableHeader("Status", flex: 1, fontSize: 13),
                _buildTableHeader("Active", flex: 1, fontSize: 13),
              ],
            ),
          ),
          const Divider(thickness: 0.5, height: 1),

          // Task Rows
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.filteredTasks.length,
            itemBuilder: (context, index) {
              final task = state.filteredTasks[index];
              return _buildTaskRowTablet(task, index);
            },
          ),
        ],
      ),
    );
  }

  // Desktop Task Row
  Widget _buildTaskRowDesktop(CommonTaskModel task, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.white : Colors.grey.shade50,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  task.taskId,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  task.title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  task.desc,
                  style: GoogleFonts.inter(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  task.frequency,
                  style: GoogleFonts.inter(fontSize: 14),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  task.duration,
                  style: GoogleFonts.inter(fontSize: 14),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (task.fromMasterHotel ?? false)
                        ? Colors.blue.shade50
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.fromMasterHotel ?? false ? "Imported" : "Created",
                    style: GoogleFonts.inter(
                      color: (task.fromMasterHotel ?? false)
                          ? Colors.blue
                          : Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    context.read<ClientDetailCubit>().toggleTaskStatus(
                      task.docId,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: task.isActive
                          ? Colors.green.shade50
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.isActive ? "ON" : "OFF",
                      style: GoogleFonts.inter(
                        color: task.isActive
                            ? Colors.green
                            : AppColors.slateGray,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 0.1, height: 1),
        ],
      ),
    );
  }

  // Tablet Task Row (Compact)
  Widget _buildTaskRowTablet(CommonTaskModel task, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.white : Colors.grey.shade50,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  task.taskId,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  task.title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  task.frequency,
                  style: GoogleFonts.inter(fontSize: 12),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  task.duration,
                  style: GoogleFonts.inter(fontSize: 12),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: (task.fromMasterHotel ?? false)
                        ? Colors.blue.shade50
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    task.fromMasterHotel ?? false ? "Import" : "Create",
                    style: GoogleFonts.inter(
                      color: (task.fromMasterHotel ?? false)
                          ? Colors.blue
                          : Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    context.read<ClientDetailCubit>().toggleTaskStatus(
                      task.docId,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: task.isActive
                          ? Colors.green.shade50
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      task.isActive ? "ON" : "OFF",
                      style: GoogleFonts.inter(
                        color: task.isActive
                            ? Colors.green
                            : AppColors.slateGray,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Divider(thickness: 0.1, height: 1),
        ],
      ),
    );
  }

  // Mobile Task List (Card View)
  Widget _buildTaskListMobile(ClientDetailState state) {
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
              GestureDetector(
                onTap: () {
                  context.read<ClientDetailCubit>().toggleTaskStatus(
                    task.docId,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: task.isActive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.isActive ? "ON" : "OFF",
                    style: GoogleFonts.inter(
                      color: task.isActive ? Colors.green : AppColors.slateGray,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            task.title,
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            task.desc,
            style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildMobileInfoChip(task.frequency, icon: CupertinoIcons.time),
              _buildMobileInfoChip(task.duration, icon: CupertinoIcons.clock),
              _buildMobileInfoChip(
                task.fromMasterHotel ?? false ? "Imported" : "Created",
                color: (task.fromMasterHotel ?? false)
                    ? Colors.blue.shade50
                    : Colors.green.shade50,
                textColor: (task.fromMasterHotel ?? false)
                    ? Colors.blue
                    : Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileInfoChip(
    String text, {
    Color? color,
    Color? textColor,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor ?? Colors.grey[700]),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor ?? Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String title, {int flex = 1, double fontSize = 14}) {
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
