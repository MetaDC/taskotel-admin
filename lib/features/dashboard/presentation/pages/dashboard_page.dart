import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/routes/routes.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/core/widget/stats_card.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedYear = '2024';

  Map<String, List<MonthlyRevenue>> getRevenueData() {
    return {
      '2024': [
        MonthlyRevenue(month: 'Jan', revenue: 45000),
        MonthlyRevenue(month: 'Feb', revenue: 52000),
        MonthlyRevenue(month: 'Mar', revenue: 48000),
        MonthlyRevenue(month: 'Apr', revenue: 62000),
        MonthlyRevenue(month: 'May', revenue: 55000),
        MonthlyRevenue(month: 'Jun', revenue: 68000),
        MonthlyRevenue(month: 'Jul', revenue: 70000),
        MonthlyRevenue(month: 'Aug', revenue: 75000),
        MonthlyRevenue(month: 'Sep', revenue: 78000),
        MonthlyRevenue(month: 'Oct', revenue: 82000),
        MonthlyRevenue(month: 'Nov', revenue: 88000),
        MonthlyRevenue(month: 'Dec', revenue: 95000),
      ],
      '2023': [
        MonthlyRevenue(month: 'Jan', revenue: 38000),
        MonthlyRevenue(month: 'Feb', revenue: 42000),
        MonthlyRevenue(month: 'Mar', revenue: 40000),
        MonthlyRevenue(month: 'Apr', revenue: 48000),
        MonthlyRevenue(month: 'May', revenue: 45000),
        MonthlyRevenue(month: 'Jun', revenue: 52000),
        MonthlyRevenue(month: 'Jul', revenue: 55000),
        MonthlyRevenue(month: 'Aug', revenue: 58000),
        MonthlyRevenue(month: 'Sep', revenue: 62000),
        MonthlyRevenue(month: 'Oct', revenue: 65000),
        MonthlyRevenue(month: 'Nov', revenue: 68000),
        MonthlyRevenue(month: 'Dec', revenue: 72000),
      ],
      '2022': [
        MonthlyRevenue(month: 'Jan', revenue: 32000),
        MonthlyRevenue(month: 'Feb', revenue: 35000),
        MonthlyRevenue(month: 'Mar', revenue: 33000),
        MonthlyRevenue(month: 'Apr', revenue: 38000),
        MonthlyRevenue(month: 'May', revenue: 36000),
        MonthlyRevenue(month: 'Jun', revenue: 42000),
        MonthlyRevenue(month: 'Jul', revenue: 45000),
        MonthlyRevenue(month: 'Aug', revenue: 48000),
        MonthlyRevenue(month: 'Sep', revenue: 50000),
        MonthlyRevenue(month: 'Oct', revenue: 52000),
        MonthlyRevenue(month: 'Nov', revenue: 55000),
        MonthlyRevenue(month: 'Dec', revenue: 58000),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final revenueData = getRevenueData();
    final currentYearData = revenueData[selectedYear] ?? [];

    return ResponsiveCustomBuilder(
      mobileBuilder: (width) => _buildMobileLayout(currentYearData, width),
      tabletBuilder: (width) => _buildTabletLayout(currentYearData, width),
      desktopBuilder: (width) => _buildDesktopLayout(currentYearData, width),
    );
  }

  Widget _buildMobileLayout(
    List<MonthlyRevenue> currentYearData,
    double width,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          // Stats Cards - Mobile: 1 column
          ...[
            StatCardIconRight(
              icon: CupertinoIcons.person_2,
              label: "Active Subscriptions",
              value: "2,847",
              iconColor: Colors.blue,
            ),
            const SizedBox(height: 12),
            StatCardIconRight(
              icon: CupertinoIcons.money_dollar,
              label: "Total Revenue",
              value: "\$742,580",
              iconColor: Colors.green,
            ),
            const SizedBox(height: 12),
            StatCardIconRight(
              icon: CupertinoIcons.building_2_fill,
              label: "Total Master Hotels",
              value: "1,234",
              iconColor: Colors.teal,
            ),
            const SizedBox(height: 12),
            StatCardIconRight(
              icon: CupertinoIcons.cube_box,
              label: "Total Subscription Plans",
              value: "4",
              iconColor: Colors.orange,
            ),
            const SizedBox(height: 12),
            StatCardIconRight(
              icon: CupertinoIcons.star_fill,
              label: "Top Selling Plan",
              value: "Premium",
              iconColor: Colors.amber,
            ),
          ],

          const SizedBox(height: 16),

          // Revenue Overview
          _buildRevenueOverviewCard(currentYearData, isMobile: true),

          const SizedBox(height: 16),

          // Unsubscribed / Not Renewed
          _buildUnsubscribedCard(isMobile: true),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(
    List<MonthlyRevenue> currentYearData,
    double width,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          // Stats Cards - Tablet: 2 columns
          StaggeredGrid.extent(
            maxCrossAxisExtent: 350,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            children: [
              StatCardIconRight(
                icon: CupertinoIcons.person_2,
                label: "Active Subscriptions",
                value: "2,847",
                iconColor: Colors.blue,
              ),
              StatCardIconRight(
                icon: CupertinoIcons.money_dollar,
                label: "Total Revenue",
                value: "\$742,580",
                iconColor: Colors.green,
              ),
              StatCardIconRight(
                icon: CupertinoIcons.building_2_fill,
                label: "Total Master Hotels",
                value: "1,234",
                iconColor: Colors.teal,
              ),
              StatCardIconRight(
                icon: CupertinoIcons.cube_box,
                label: "Total Subscription Plans",
                value: "4",
                iconColor: Colors.orange,
              ),
              StatCardIconRight(
                icon: CupertinoIcons.star_fill,
                label: "Top Selling Plan",
                value: "Premium",
                iconColor: Colors.amber,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Revenue Overview
          _buildRevenueOverviewCard(currentYearData, isMobile: false),

          const SizedBox(height: 16),

          // Unsubscribed / Not Renewed
          _buildUnsubscribedCard(isMobile: false),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    List<MonthlyRevenue> currentYearData,
    double width,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: Column(
        children: [
          // Stats Cards - Desktop: 3+ columns
          StaggeredGrid.extent(
            maxCrossAxisExtent: 400,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              StatCardIconRight(
                icon: CupertinoIcons.person_2,
                label: "Active Subscriptions",
                value: "2,847",
                iconColor: Colors.blue,
              ),
              StatCardIconRight(
                icon: CupertinoIcons.money_dollar,
                label: "Total Revenue",
                value: "\$742,580",
                iconColor: Colors.green,
              ),
              StatCardIconRight(
                icon: CupertinoIcons.building_2_fill,
                label: "Total Master Hotels",
                value: "1,234",
                iconColor: Colors.teal,
              ),
              StatCardIconRight(
                icon: CupertinoIcons.cube_box,
                label: "Total Subscription Plans",
                value: "4",
                iconColor: Colors.orange,
              ),
              StatCardIconRight(
                icon: CupertinoIcons.star_fill,
                label: "Top Selling Plan",
                value: "Premium",
                iconColor: Colors.amber,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Revenue Overview
          _buildRevenueOverviewCard(currentYearData, isMobile: false),

          const SizedBox(height: 16),

          // Unsubscribed / Not Renewed
          _buildUnsubscribedCard(isMobile: false),
        ],
      ),
    );
  }

  Widget _buildRevenueOverviewCard(
    List<MonthlyRevenue> currentYearData, {
    required bool isMobile,
  }) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveCustomBuilder(
            mobileBuilder: (width) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Revenue Overview",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Monthly revenue performance",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildRevenueControls(true),
              ],
            ),
            tabletBuilder: (width) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Revenue Overview",
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Monthly revenue performance",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF64748B),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _buildRevenueControls(false),
              ],
            ),
            desktopBuilder: (width) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Revenue Overview",
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Monthly revenue performance",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF64748B),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _buildRevenueControls(false),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Chart widget
          SizedBox(
            height: isMobile ? 250 : 300,
            child: RevenueChart(data: currentYearData, isMobile: isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueControls(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 39,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.blueGreyBorder),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButton<String>(
              value: selectedYear,
              isExpanded: true,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down),
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textBlackColor,
              ),
              items: ['2024', '2023', '2022'].map((String year) {
                return DropdownMenuItem<String>(
                  value: year,
                  child: Text(
                    year,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedYear = newValue;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              label: const Text("Reports"),
              icon: const Icon(CupertinoIcons.chart_bar_square),
              style: _getButtonStyle(),
              onPressed: () {
                context.go(Routes.reports);
              },
            ),
          ),
        ],
      );
    }

    return Wrap(
      spacing: 12,
      children: [
        Container(
          height: 39,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.blueGreyBorder),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton<String>(
            value: selectedYear,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down),
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textBlackColor,
            ),
            items: ['2024', '2023', '2022'].map((String year) {
              return DropdownMenuItem<String>(
                value: year,
                child: Text(
                  year,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedYear = newValue;
                });
              }
            },
          ),
        ),
        ElevatedButton.icon(
          label: const Text("Reports"),
          icon: const Icon(CupertinoIcons.chart_bar_square),
          style: _getButtonStyle(),
          onPressed: () {
            context.go(Routes.reports);
          },
        ),
      ],
    );
  }

  Widget _buildUnsubscribedCard({required bool isMobile}) {
    return CustomContainer(
      child: ResponsiveCustomBuilder(
        mobileBuilder: (width) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  CupertinoIcons.person_2,
                  color: Color(0xff64748b),
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Unsubscribed / Not Renewed",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Clients who registered but haven't subscribed or renewed",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xff64748b),
                          fontWeight: FontWeight.w500,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              "147 clients",
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            Text(
              "Lost clients this month",
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xff64748b),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: _getButtonStyle(),
                onPressed: () {
                  context.go(Routes.clients);
                },
                child: const Text("View All"),
              ),
            ),
          ],
        ),
        tabletBuilder: (width) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        CupertinoIcons.person_2,
                        color: Color(0xff64748b),
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Unsubscribed / Not Renewed",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Clients who registered but haven't subscribed or renewed",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xff64748b),
                                fontWeight: FontWeight.w500,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "147 clients",
                    style: GoogleFonts.inter(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    "Lost clients this month",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xff64748b),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              style: _getButtonStyle(),
              onPressed: () {
                context.go(Routes.clients);
              },
              child: const Text("View All"),
            ),
          ],
        ),
        desktopBuilder: (width) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        CupertinoIcons.person_2,
                        color: Color(0xff64748b),
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Unsubscribed / Not Renewed",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Clients who registered but haven't subscribed or renewed",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xff64748b),
                                fontWeight: FontWeight.w500,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "147 clients",
                    style: GoogleFonts.inter(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    "Lost clients this month",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xff64748b),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              style: _getButtonStyle(),
              onPressed: () {
                context.go(Routes.clients);
              },
              child: const Text("View All"),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _getButtonStyle() {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.hovered)) {
          return Colors.blue;
        }
        return const Color(0xFFFAFAFA);
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.hovered)) {
          return Colors.white;
        }
        return AppColors.textBlackColor;
      }),
      elevation: WidgetStateProperty.all(0),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      ),
      side: WidgetStateProperty.all(
        BorderSide(color: AppColors.blueGreyBorder),
      ),
      textStyle: WidgetStateProperty.all(
        GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}

// Data model for monthly revenue
class MonthlyRevenue {
  final String month;
  final double revenue;

  MonthlyRevenue({required this.month, required this.revenue});

  factory MonthlyRevenue.fromJson(Map<String, dynamic> json) {
    return MonthlyRevenue(
      month: json['month'] as String,
      revenue: (json['revenue'] as num).toDouble(),
    );
  }
}

// Revenue Chart Widget
class RevenueChart extends StatelessWidget {
  final List<MonthlyRevenue> data;
  final bool isMobile;

  const RevenueChart({super.key, required this.data, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final maxRevenue = data
        .map((e) => e.revenue)
        .reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: EdgeInsets.only(
        right: isMobile ? 8 : 16,
        top: isMobile ? 8 : 16,
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25000,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: const Color(0xffe2e8f0), strokeWidth: 1);
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: isMobile ? 50 : 60,
                interval: 25000,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '\$${(value / 1000).toStringAsFixed(0)}k',
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 10 : 12,
                      color: const Color(0xff64748b),
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        data[index].month,
                        style: GoogleFonts.inter(
                          fontSize: isMobile ? 10 : 12,
                          color: const Color(0xff64748b),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY: 0,
          maxY: (maxRevenue * 1.1).ceilToDouble(),
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value.revenue);
              }).toList(),
              isCurved: true,
              color: const Color(0xff3b82f6),
              barWidth: isMobile ? 2 : 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: isMobile ? 3 : 4,
                    color: const Color(0xff3b82f6),
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xff3b82f6).withOpacity(0.1),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBorder: const BorderSide(color: Color(0xffe2e8f0)),
              tooltipRoundedRadius: 8,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '\$${spot.y.toStringAsFixed(0)}',
                    GoogleFonts.inter(
                      color: const Color(0xff3b82f6),
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 12 : 14,
                    ),
                  );
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:taskoteladmin/core/routes/routes.dart';
// import 'package:taskoteladmin/core/theme/app_colors.dart';
// import 'package:taskoteladmin/core/widget/custom_container.dart';
// import 'package:taskoteladmin/core/widget/stats_card.dart';
// import 'package:fl_chart/fl_chart.dart';

// class DashboardPage extends StatefulWidget {
//   const DashboardPage({super.key});

//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   String selectedYear = '2024';

//   // TODO: Replace this with actual database data
//   // This structure makes it easy to swap with API/DB data
//   Map<String, List<MonthlyRevenue>> getRevenueData() {
//     return {
//       '2024': [
//         MonthlyRevenue(month: 'Jan', revenue: 45000),
//         MonthlyRevenue(month: 'Feb', revenue: 52000),
//         MonthlyRevenue(month: 'Mar', revenue: 48000),
//         MonthlyRevenue(month: 'Apr', revenue: 62000),
//         MonthlyRevenue(month: 'May', revenue: 55000),
//         MonthlyRevenue(month: 'Jun', revenue: 68000),
//         MonthlyRevenue(month: 'Jul', revenue: 70000),
//         MonthlyRevenue(month: 'Aug', revenue: 75000),
//         MonthlyRevenue(month: 'Sep', revenue: 78000),
//         MonthlyRevenue(month: 'Oct', revenue: 82000),
//         MonthlyRevenue(month: 'Nov', revenue: 88000),
//         MonthlyRevenue(month: 'Dec', revenue: 95000),
//       ],
//       '2023': [
//         MonthlyRevenue(month: 'Jan', revenue: 38000),
//         MonthlyRevenue(month: 'Feb', revenue: 42000),
//         MonthlyRevenue(month: 'Mar', revenue: 40000),
//         MonthlyRevenue(month: 'Apr', revenue: 48000),
//         MonthlyRevenue(month: 'May', revenue: 45000),
//         MonthlyRevenue(month: 'Jun', revenue: 52000),
//         MonthlyRevenue(month: 'Jul', revenue: 55000),
//         MonthlyRevenue(month: 'Aug', revenue: 58000),
//         MonthlyRevenue(month: 'Sep', revenue: 62000),
//         MonthlyRevenue(month: 'Oct', revenue: 65000),
//         MonthlyRevenue(month: 'Nov', revenue: 68000),
//         MonthlyRevenue(month: 'Dec', revenue: 72000),
//       ],
//       '2022': [
//         MonthlyRevenue(month: 'Jan', revenue: 32000),
//         MonthlyRevenue(month: 'Feb', revenue: 35000),
//         MonthlyRevenue(month: 'Mar', revenue: 33000),
//         MonthlyRevenue(month: 'Apr', revenue: 38000),
//         MonthlyRevenue(month: 'May', revenue: 36000),
//         MonthlyRevenue(month: 'Jun', revenue: 42000),
//         MonthlyRevenue(month: 'Jul', revenue: 45000),
//         MonthlyRevenue(month: 'Aug', revenue: 48000),
//         MonthlyRevenue(month: 'Sep', revenue: 50000),
//         MonthlyRevenue(month: 'Oct', revenue: 52000),
//         MonthlyRevenue(month: 'Nov', revenue: 55000),
//         MonthlyRevenue(month: 'Dec', revenue: 58000),
//       ],
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     final revenueData = getRevenueData();
//     final currentYearData = revenueData[selectedYear] ?? [];

//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
//       child: Column(
//         children: [
//           // Stats Cards Grid
//           StaggeredGrid.extent(
//             maxCrossAxisExtent: 400,
//             mainAxisSpacing: 16,
//             crossAxisSpacing: 16,
//             children: [
//               StatCardIconRight(
//                 icon: CupertinoIcons.person_2,
//                 label: "Active Subscriptions",
//                 value: "2,847",
//                 iconColor: Colors.blue,
//               ),
//               StatCardIconRight(
//                 icon: CupertinoIcons.money_dollar,
//                 label: "Total Revenue",
//                 value: "\$742,580",
//                 iconColor: Colors.green,
//               ),
//               StatCardIconRight(
//                 icon: CupertinoIcons.building_2_fill,
//                 label: "Total Master Hotels",
//                 value: "1,234",
//                 iconColor: Colors.teal,
//               ),
//               StatCardIconRight(
//                 icon: CupertinoIcons.cube_box,
//                 label: "Total Subscription Plans",
//                 value: "4",
//                 iconColor: Colors.orange,
//               ),
//               StatCardIconRight(
//                 icon: CupertinoIcons.star_fill,
//                 label: "Top Selling Plan",
//                 value: "Premium",
//                 iconColor: Colors.amber,
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),

//           // Revenue Overview
//           CustomContainer(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Left section: Heading & Subheading
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Revenue Overview",
//                           style: GoogleFonts.inter(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                             height: 1.2,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "Monthly revenue performance",
//                           style: GoogleFonts.inter(
//                             fontSize: 14,
//                             color: const Color(0xFF64748B), // Slate-500
//                             height: 1.5,
//                           ),
//                         ),
//                       ],
//                     ),

//                     Wrap(
//                       children: [
//                         // Year Dropdown
//                         Container(
//                           height: 39,
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           margin: const EdgeInsets.only(right: 12),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: AppColors.blueGreyBorder),
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: DropdownButton<String>(
//                             value: selectedYear,
//                             underline: const SizedBox(),
//                             icon: const Icon(Icons.keyboard_arrow_down),
//                             style: GoogleFonts.inter(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: AppColors.textBlackColor,
//                             ),
//                             items: ['2024', '2023', '2022'].map((String year) {
//                               return DropdownMenuItem<String>(
//                                 value: year,
//                                 child: Text(
//                                   year,
//                                   style: GoogleFonts.inter(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                             onChanged: (String? newValue) {
//                               if (newValue != null) {
//                                 setState(() {
//                                   selectedYear = newValue;
//                                 });
//                               }
//                             },
//                           ),
//                         ),

//                         // View All Button
//                         ElevatedButton.icon(
//                           label: const Text("Reports"),
//                           icon: const Icon(CupertinoIcons.chart_bar_square),
//                           style: ButtonStyle(
//                             backgroundColor:
//                                 WidgetStateProperty.resolveWith<Color>((
//                                   Set<WidgetState> states,
//                                 ) {
//                                   if (states.contains(WidgetState.hovered)) {
//                                     return Colors.blue;
//                                   }
//                                   return const Color(0xFFFAFAFA);
//                                 }),
//                             foregroundColor:
//                                 WidgetStateProperty.resolveWith<Color>((
//                                   Set<WidgetState> states,
//                                 ) {
//                                   if (states.contains(WidgetState.hovered)) {
//                                     return Colors.white;
//                                   }
//                                   return AppColors.textBlackColor;
//                                 }),
//                             elevation: WidgetStateProperty.all(0),
//                             padding: WidgetStateProperty.all(
//                               const EdgeInsets.symmetric(
//                                 horizontal: 18,
//                                 vertical: 18,
//                               ),
//                             ),
//                             side: WidgetStateProperty.all(
//                               BorderSide(color: AppColors.blueGreyBorder),
//                             ),
//                             textStyle: WidgetStateProperty.all(
//                               GoogleFonts.inter(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             shape: WidgetStateProperty.all(
//                               RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                             ),
//                           ),
//                           onPressed: () {
//                             context.go(Routes.reports);
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),

//                 // Chart widget
//                 SizedBox(
//                   height: 300,
//                   child: RevenueChart(data: currentYearData),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 16),

//           // Unsubscribed / Not Renewed
//           CustomContainer(
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           const Icon(
//                             CupertinoIcons.person_2,
//                             color: Color(0xff64748b),
//                             size: 24,
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Unsubscribed / Not Renewed",
//                                   style: GoogleFonts.inter(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   "Clients who registered but haven't subscribed or renewed",
//                                   style: GoogleFonts.inter(
//                                     fontSize: 13,
//                                     color: const Color(0xff64748b),
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                   softWrap: true,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 18),
//                       Text(
//                         "147 clients",
//                         style: GoogleFonts.inter(
//                           fontSize: 25,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         ),
//                       ),
//                       Text(
//                         "Lost clients this month",
//                         style: GoogleFonts.inter(
//                           fontSize: 14,
//                           color: const Color(0xff64748b),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: WidgetStateProperty.resolveWith<Color>((
//                       Set<WidgetState> states,
//                     ) {
//                       if (states.contains(WidgetState.hovered)) {
//                         return Colors.blue; // Background on hover
//                       }
//                       return const Color(0xFFFAFAFA); // Default background
//                     }),
//                     foregroundColor: WidgetStateProperty.resolveWith<Color>((
//                       Set<WidgetState> states,
//                     ) {
//                       if (states.contains(WidgetState.hovered)) {
//                         return Colors.white; // Text color on hover
//                       }
//                       return AppColors.textBlackColor; // Default text color
//                     }),
//                     elevation: WidgetStateProperty.all(0),
//                     padding: WidgetStateProperty.all(
//                       const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
//                     ),
//                     side: WidgetStateProperty.all(
//                       BorderSide(color: AppColors.blueGreyBorder),
//                     ),
//                     textStyle: WidgetStateProperty.all(
//                       GoogleFonts.inter(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     shape: WidgetStateProperty.all(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                     ),
//                   ),
//                   onPressed: () {
//                     context.go(Routes.clients);
//                   },
//                   child: const Text("View All"),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Data model for monthly revenue
// class MonthlyRevenue {
//   final String month;
//   final double revenue;

//   MonthlyRevenue({required this.month, required this.revenue});

//   // Factory constructor for easy database/API integration
//   factory MonthlyRevenue.fromJson(Map<String, dynamic> json) {
//     return MonthlyRevenue(
//       month: json['month'] as String,
//       revenue: (json['revenue'] as num).toDouble(),
//     );
//   }
// }

// // Revenue Chart Widget
// class RevenueChart extends StatelessWidget {
//   final List<MonthlyRevenue> data;

//   const RevenueChart({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     if (data.isEmpty) {
//       return const Center(child: Text('No data available'));
//     }

//     final maxRevenue = data
//         .map((e) => e.revenue)
//         .reduce((a, b) => a > b ? a : b);
//     final minRevenue = data
//         .map((e) => e.revenue)
//         .reduce((a, b) => a < b ? a : b);

//     return Padding(
//       padding: const EdgeInsets.only(right: 16, top: 16),
//       child: LineChart(
//         LineChartData(
//           gridData: FlGridData(
//             show: true,
//             drawVerticalLine: false,
//             horizontalInterval: 25000,
//             getDrawingHorizontalLine: (value) {
//               return FlLine(color: const Color(0xffe2e8f0), strokeWidth: 1);
//             },
//           ),
//           titlesData: FlTitlesData(
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 reservedSize: 60,
//                 interval: 25000,
//                 getTitlesWidget: (value, meta) {
//                   return Text(
//                     '\$${(value / 1000).toStringAsFixed(0)}k',
//                     style: GoogleFonts.inter(
//                       fontSize: 12,
//                       color: const Color(0xff64748b),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             rightTitles: const AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//             topTitles: const AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 reservedSize: 30,
//                 interval: 1,
//                 getTitlesWidget: (value, meta) {
//                   final index = value.toInt();
//                   if (index >= 0 && index < data.length) {
//                     return Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Text(
//                         data[index].month,
//                         style: GoogleFonts.inter(
//                           fontSize: 12,
//                           color: const Color(0xff64748b),
//                         ),
//                       ),
//                     );
//                   }
//                   return const SizedBox.shrink();
//                 },
//               ),
//             ),
//           ),
//           borderData: FlBorderData(show: false),
//           minX: 0,
//           maxX: (data.length - 1).toDouble(),
//           minY: 0,
//           maxY: (maxRevenue * 1.1).ceilToDouble(),
//           lineBarsData: [
//             LineChartBarData(
//               spots: data.asMap().entries.map((entry) {
//                 return FlSpot(entry.key.toDouble(), entry.value.revenue);
//               }).toList(),
//               isCurved: true,
//               color: const Color(0xff3b82f6),
//               barWidth: 3,
//               isStrokeCapRound: true,
//               dotData: FlDotData(
//                 show: true,
//                 getDotPainter: (spot, percent, barData, index) {
//                   return FlDotCirclePainter(
//                     radius: 4,
//                     color: const Color(0xff3b82f6),
//                     strokeWidth: 2,
//                     strokeColor: Colors.white,
//                   );
//                 },
//               ),
//               belowBarData: BarAreaData(
//                 show: true,
//                 color: const Color(0xff3b82f6).withOpacity(0.1),
//               ),
//             ),
//           ],
//           lineTouchData: LineTouchData(
//             touchTooltipData: LineTouchTooltipData(
//               tooltipBorder: const BorderSide(color: Color(0xffe2e8f0)),
//               tooltipRoundedRadius: 8,
//               getTooltipItems: (touchedSpots) {
//                 return touchedSpots.map((spot) {
//                   return LineTooltipItem(
//                     '\$${spot.y.toStringAsFixed(0)}',
//                     GoogleFonts.inter(
//                       color: const Color(0xff3b82f6),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   );
//                 }).toList();
//               },
//             ),
//             handleBuiltInTouches: true,
//           ),
//         ),
//       ),
//     );
//   }
// }
