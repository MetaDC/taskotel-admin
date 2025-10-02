import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/utils/helpers.dart';
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

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              Row(
                children: [
                  // IconButton(
                  //   icon: const Icon(Icons.arrow_back),
                  //   onPressed: () => Navigator.of(context).pop(),
                  // ),
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

              // Metrics Cards Row
              // _buildMetricsRow(),
              const SizedBox(height: 20),

              // Task Management Section
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

  Widget _buildHotelInformationCard(HotelModel hotel) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Icon(CupertinoIcons.building_2_fill),
              const SizedBox(width: 8),
              Text(
                "Hotel Information",
                style: AppTextStyles.headerHeading.copyWith(fontSize: 22),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Location
              Expanded(
                child: _buildInfoColumn(
                  "Location",
                  "${hotel.addressModel.city}, ${hotel.addressModel.state}",
                  CupertinoIcons.placemark,
                ),
              ),
              // Plan
              Expanded(
                child: _buildInfoColumn(
                  "Plan",
                  hotel.subscriptionName,
                  null,
                  isChip: true,
                  chipColor: Colors.blue,
                ),
              ),
              // Plan Duration
              // Expanded(
              //   child: _buildInfoColumn(
              //     "Plan Duration",
              //     "${hotel.subscriptionStart.goodDayDate()} - ${hotel.subscriptionEnd.goodDayDate()}",
              //     CupertinoIcons.calendar,
              //   ),
              // ),
              // Performance
              Expanded(
                child: _buildInfoColumn(
                  "Performance",
                  "Excellent",
                  null,
                  isChip: true,
                  chipColor: Colors.green,
                ),
              ),
            ],
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.slateGray,
            fontSize: 14,
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
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: CustomContainer(
            child: _buildMetricsCard("Task Performance", [
              ("Completion Rate", "92%"),
              ("On-time Delivery", "88.7%"),
              ("Quality Score", "94.2%"),
            ], CupertinoIcons.chart_bar),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomContainer(
            child: _buildMetricsCard("Activity Metrics", [
              ("Daily Active Users", "45"),
              ("Tasks Created/Day", "12"),
              ("Issues Resolved", "23"),
            ], CupertinoIcons.graph_circle),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomContainer(
            child: _buildMetricsCard("Revenue Analytics", [
              ("Monthly Revenue", "\$5,200"),
              ("Growth Rate", "+8.3%", Colors.green),
              ("Retention Rate", "96.4%"),
            ], CupertinoIcons.money_dollar),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsCard(String title, List<dynamic> metrics, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTextStyles.dialogHeading.copyWith(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...metrics.map((metric) {
          final label = metric[0] as String;
          final value = metric[1] as String;
          final color = metric.length > 2 ? metric[2] as Color? : null;
          return _buildMetricRow(label, value, valueColor: color);
        }),
      ],
    );
  }

  Widget _buildRoleTabs(ClientDetailState state) {
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
            context.read<ClientDetailCubit>().switchTab(value);
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
              controller: context.read<ClientDetailCubit>().serachController,
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

  Widget _buildTaskTable(ClientDetailState state) {
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
                    task.fromMasterHotel ?? false ? "Imported" : "Created",
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
                    context.read<ClientDetailCubit>().toggleTaskStatus(
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

  Widget _buildMetricRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
