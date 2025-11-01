import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/core/widget/stats_card.dart';
import 'package:taskoteladmin/features/report/presentation/cubit/report_cubit.dart';
import 'package:taskoteladmin/features/report/presentation/services/report_services.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();
    // Initialize after the first frame to avoid calling during build
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (mounted) {
    //     context.read<ReportCubit>().initialize();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(state.errorMessage!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<ReportCubit>().initialize(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RepaintBoundary(
          key: ReportExportService.screenshotKey,
          child: ResponsiveCustomBuilder(
            mobileBuilder: (width) => _buildMobileLayout(state, width),
            tabletBuilder: (width) => _buildTabletLayout(state, width),
            desktopBuilder: (width) => _buildDesktopLayout(state, width),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(ReportState state, double width) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(state, isMobile: true),
          const SizedBox(height: 20),
          _buildKeyMetrics(state, isMobile: true),
          const SizedBox(height: 20),
          _buildRevenueChart(state, isMobile: true),
          const SizedBox(height: 20),
          _buildPlanDistributionChart(state, isMobile: true),
          const SizedBox(height: 20),
          _buildClientAcquisitionChart(state, isMobile: true),
          const SizedBox(height: 20),
          _buildChurnVsRetentionChart(state, isMobile: true),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(ReportState state, double width) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(state, isMobile: false),
          const SizedBox(height: 25),
          _buildKeyMetrics(state, isMobile: false),
          const SizedBox(height: 25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildRevenueChart(state, isMobile: false)),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPlanDistributionChart(state, isMobile: false),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildClientAcquisitionChart(state, isMobile: false),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildChurnVsRetentionChart(state, isMobile: false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(ReportState state, double width) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(state, isMobile: false),
          const SizedBox(height: 30),
          _buildKeyMetrics(state, isMobile: false),
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildRevenueChart(state, isMobile: false)),
              const SizedBox(width: 20),
              Expanded(
                child: _buildPlanDistributionChart(state, isMobile: false),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildClientAcquisitionChart(state, isMobile: false),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildChurnVsRetentionChart(state, isMobile: false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ReportState state, {required bool isMobile}) {
    return ResponsiveCustomBuilder(
      mobileBuilder: (width) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reports & Analytics",
                style: AppTextStyles.headerHeading.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 4),
              Text(
                "Comprehensive business performance metrics",
                style: AppTextStyles.headerSubheading.copyWith(fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStyledContainer(
                child: DropdownButton<int>(
                  value: state.selectedYear,
                  underline: const SizedBox(),
                  isDense: true,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: List.generate(5, (index) {
                    final year = DateTime.now().year - index;
                    return DropdownMenuItem(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),
                  onChanged: (year) {
                    if (year != null) {
                      context.read<ReportCubit>().changeYear(year);
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildStyledContainer(
                child: DropdownButton<ReportTimeFilter>(
                  value: state.timeFilter,
                  underline: const SizedBox(),
                  isDense: true,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: const [
                    DropdownMenuItem(
                      value: ReportTimeFilter.yearly,
                      child: Text("Yearly"),
                    ),
                    DropdownMenuItem(
                      value: ReportTimeFilter.monthly,
                      child: Text("Monthly"),
                    ),
                  ],
                  onChanged: (filter) {
                    if (filter != null) {
                      context.read<ReportCubit>().changeTimeFilter(filter);
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildStyledContainer(
                isButton: true,
                child: InkWell(
                  onTap: () {
                    ReportExportService.showExportDialog(context);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.cloud_download,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Export Report",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      tabletBuilder: (width) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reports & Analytics",
                      style: AppTextStyles.headerHeading,
                    ),
                    Text(
                      "Comprehensive business performance metrics",
                      style: AppTextStyles.headerSubheading,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildStyledContainer(
                child: DropdownButton<int>(
                  value: state.selectedYear,
                  underline: const SizedBox(),
                  isDense: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: List.generate(5, (index) {
                    final year = DateTime.now().year - index;
                    return DropdownMenuItem(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),
                  onChanged: (year) {
                    if (year != null) {
                      context.read<ReportCubit>().changeYear(year);
                    }
                  },
                ),
              ),
              _buildStyledContainer(
                child: DropdownButton<ReportTimeFilter>(
                  value: state.timeFilter,
                  underline: const SizedBox(),
                  isDense: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: const [
                    DropdownMenuItem(
                      value: ReportTimeFilter.yearly,
                      child: Text("Yearly"),
                    ),
                    DropdownMenuItem(
                      value: ReportTimeFilter.monthly,
                      child: Text("Monthly"),
                    ),
                  ],
                  onChanged: (filter) {
                    if (filter != null) {
                      context.read<ReportCubit>().changeTimeFilter(filter);
                    }
                  },
                ),
              ),
              _buildStyledContainer(
                isButton: true,
                child: InkWell(
                  onTap: () {
                    ReportExportService.showExportDialog(context);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.cloud_download,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Export Report",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      desktopBuilder: (width) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Reports & Analytics", style: AppTextStyles.headerHeading),
                Text(
                  "Comprehensive business performance metrics",
                  style: AppTextStyles.headerSubheading,
                ),
              ],
            ),
          ),
          _buildStyledContainer(
            child: DropdownButton<int>(
              value: state.selectedYear,
              underline: const SizedBox(),
              isDense: true,
              isExpanded: false,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: List.generate(5, (index) {
                final year = DateTime.now().year - index;
                return DropdownMenuItem(
                  value: year,
                  child: Text(year.toString()),
                );
              }),
              onChanged: (year) {
                if (year != null) {
                  context.read<ReportCubit>().changeYear(year);
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          _buildStyledContainer(
            child: DropdownButton<ReportTimeFilter>(
              value: state.timeFilter,
              underline: const SizedBox(),
              isDense: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: const [
                DropdownMenuItem(
                  value: ReportTimeFilter.yearly,
                  child: Text("Yearly"),
                ),
                DropdownMenuItem(
                  value: ReportTimeFilter.monthly,
                  child: Text("Monthly"),
                ),
              ],
              onChanged: (filter) {
                if (filter != null) {
                  context.read<ReportCubit>().changeTimeFilter(filter);
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          _buildStyledContainer(
            isButton: true,
            child: InkWell(
              onTap: () {
                ReportExportService.showExportDialog(context);
              },
              borderRadius: BorderRadius.circular(8),
              child: const Row(
                children: [
                  Icon(
                    CupertinoIcons.cloud_download,
                    size: 16,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text("Export Report", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyMetrics(ReportState state, {required bool isMobile}) {
    return StaggeredGrid.extent(
      maxCrossAxisExtent: 400,
      mainAxisSpacing: isMobile ? 12 : 16,
      crossAxisSpacing: 16,
      children: [
        StatCardIconRight(
          icon: CupertinoIcons.money_dollar_circle,
          label: "Total Revenue (YTD)",
          value: "\$${state.totalRevenue.toStringAsFixed(2)}",
          iconColor: Colors.green,
        ),
        StatCardIconRight(
          icon: CupertinoIcons.person_2,
          label: "Active Subscribers",
          value: "${state.activeSubscribers}",
          iconColor: Colors.blue,
        ),
        StatCardIconRight(
          icon: CupertinoIcons.chart_bar,
          label: "Churn Rate",
          value: "${state.churnRate.toStringAsFixed(1)}%",
          iconColor: state.churnRate > 10 ? Colors.red : Colors.orange,
        ),
        StatCardIconRight(
          icon: CupertinoIcons.money_dollar,
          label: "Avg. Revenue Per User",
          value: "\$${state.avgRevenuePerUser.toStringAsFixed(2)}",
          iconColor: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildRevenueChart(ReportState state, {required bool isMobile}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Revenue Trend",
                  style: AppTextStyles.customContainerTitle,
                ),
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.arrow_down_doc),
                iconSize: isMobile ? 20 : 24,
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 20),
          SizedBox(
            height: isMobile ? 200 : 250,
            child: state.revenueByMonth.isEmpty
                ? const Center(child: Text("No data available"))
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: isMobile ? 35 : 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '\$${(value / 1000).toStringAsFixed(0)}k',
                                style: GoogleFonts.inter(
                                  fontSize: isMobile ? 9 : 10,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 &&
                                  value.toInt() < state.revenueByMonth.length) {
                                return Text(
                                  state.revenueByMonth[value.toInt()]['month'],
                                  style: GoogleFonts.inter(
                                    fontSize: isMobile ? 9 : 10,
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: state.revenueByMonth
                              .asMap()
                              .entries
                              .map(
                                (e) => FlSpot(
                                  e.key.toDouble(),
                                  e.value['revenue'].toDouble(),
                                ),
                              )
                              .toList(),
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: isMobile ? 2 : 3,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blue.withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanDistributionChart(
    ReportState state, {
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Plan Distribution", style: AppTextStyles.customContainerTitle),
          SizedBox(height: isMobile ? 16 : 20),
          SizedBox(
            height: isMobile ? 200 : 250,
            child: state.planDistribution.isEmpty
                ? const Center(child: Text("No data available"))
                : Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: PieChart(
                          PieChartData(
                            sections: _getPlanSections(state, isMobile),
                            sectionsSpace: 2,
                            centerSpaceRadius: isMobile ? 40 : 60,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: state.planDistribution.entries
                              .map(
                                (entry) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: isMobile ? 10 : 12,
                                        height: isMobile ? 10 : 12,
                                        decoration: BoxDecoration(
                                          color: _getPlanColor(entry.key),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${entry.key} (${entry.value})',
                                          style: GoogleFonts.inter(
                                            fontSize: isMobile ? 10 : 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientAcquisitionChart(
    ReportState state, {
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New Client Acquisition",
            style: AppTextStyles.customContainerTitle,
          ),
          SizedBox(height: isMobile ? 16 : 20),
          SizedBox(
            height: isMobile ? 200 : 250,
            child: state.clientAcquisitionByMonth.isEmpty
                ? const Center(child: Text("No data available"))
                : BarChart(
                    BarChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: isMobile ? 35 : 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: GoogleFonts.inter(
                                  fontSize: isMobile ? 9 : 10,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 &&
                                  value.toInt() <
                                      state.clientAcquisitionByMonth.length) {
                                return Text(
                                  state.clientAcquisitionByMonth[value
                                      .toInt()]['month'],
                                  style: GoogleFonts.inter(
                                    fontSize: isMobile ? 9 : 10,
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      barGroups: state.clientAcquisitionByMonth
                          .asMap()
                          .entries
                          .map(
                            (e) => BarChartGroupData(
                              x: e.key,
                              barRods: [
                                BarChartRodData(
                                  toY: e.value['count'].toDouble(),
                                  color: Colors.green,
                                  width: isMobile ? 16 : 20,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildChurnVsRetentionChart(
    ReportState state, {
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Churn vs Retention", style: AppTextStyles.customContainerTitle),
          SizedBox(height: isMobile ? 16 : 20),
          SizedBox(
            height: isMobile ? 200 : 250,
            child: state.churnVsRetention.isEmpty
                ? const Center(child: Text("No data available"))
                : BarChart(
                    BarChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: isMobile ? 35 : 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: GoogleFonts.inter(
                                  fontSize: isMobile ? 9 : 10,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 &&
                                  value.toInt() <
                                      state.churnVsRetention.length) {
                                return Text(
                                  state.churnVsRetention[value
                                      .toInt()]['month'],
                                  style: GoogleFonts.inter(
                                    fontSize: isMobile ? 9 : 10,
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      barGroups: state.churnVsRetention
                          .asMap()
                          .entries
                          .map(
                            (e) => BarChartGroupData(
                              x: e.key,
                              barRods: [
                                BarChartRodData(
                                  toY: e.value['retained'].toDouble(),
                                  color: Colors.green,
                                  width: isMobile ? 10 : 12,
                                ),
                                BarChartRodData(
                                  toY: e.value['churned'].toDouble(),
                                  color: Colors.red,
                                  width: isMobile ? 10 : 12,
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.green, "Retained", isMobile),
              SizedBox(width: isMobile ? 16 : 20),
              _buildLegendItem(Colors.red, "Churned", isMobile),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, bool isMobile) {
    return Row(
      children: [
        Container(
          width: isMobile ? 10 : 12,
          height: isMobile ? 10 : 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.inter(fontSize: isMobile ? 11 : 12)),
      ],
    );
  }

  List<PieChartSectionData> _getPlanSections(ReportState state, bool isMobile) {
    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];

    return state.planDistribution.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final planEntry = entry.value;
      final total = state.planDistribution.values.fold<int>(
        0,
        (sum, count) => sum + count,
      );
      final percentage = (planEntry.value / total * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: planEntry.value.toDouble(),
        title: '$percentage%',
        radius: isMobile ? 60 : 80,
        titleStyle: GoogleFonts.inter(
          fontSize: isMobile ? 12 : 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color _getPlanColor(String planName) {
    final colors = {
      'Basic': Colors.blue,
      'Standard': Colors.orange,
      'Premium': Colors.green,
      'Enterprise': Colors.purple,
    };
    return colors[planName] ?? Colors.grey;
  }

  Widget _buildStyledContainer({required Widget child, bool isButton = false}) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isButton ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:taskoteladmin/core/theme/app_colors.dart';
// import 'package:taskoteladmin/core/theme/app_text_styles.dart';
// import 'package:taskoteladmin/core/widget/page_header.dart';
// import 'package:taskoteladmin/core/widget/stats_card.dart';
// import 'package:taskoteladmin/features/report/presentation/cubit/report_cubit.dart';

// class ReportsPage extends StatefulWidget {
//   const ReportsPage({super.key});

//   @override
//   State<ReportsPage> createState() => _ReportsPageState();
// }

// class _ReportsPageState extends State<ReportsPage> {
//   @override
//   void initState() {
//     super.initState();
//     // Initialize after the first frame to avoid calling during build
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   if (mounted) {
//     //     context.read<ReportCubit>().initialize();
//     //   }
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ReportCubit, ReportState>(
//       builder: (context, state) {
//         if (state.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (state.errorMessage != null) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   CupertinoIcons.exclamationmark_triangle,
//                   size: 64,
//                   color: Colors.grey[400],
//                 ),
//                 const SizedBox(height: 16),
//                 Text(state.errorMessage!),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () => context.read<ReportCubit>().initialize(),
//                   child: const Text('Retry'),
//                 ),
//               ],
//             ),
//           );
//         }

//         return SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               _buildHeader(state),
//               const SizedBox(height: 30),

//               // Key Metrics
//               _buildKeyMetrics(state),
//               const SizedBox(height: 30),

//               // Charts Row 1
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(child: _buildRevenueChart(state)),
//                   const SizedBox(width: 20),
//                   Expanded(child: _buildPlanDistributionChart(state)),
//                 ],
//               ),
//               const SizedBox(height: 30),

//               // Charts Row 2
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(child: _buildClientAcquisitionChart(state)),
//                   const SizedBox(width: 20),
//                   Expanded(child: _buildChurnVsRetentionChart(state)),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildHeader(ReportState state) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         // Left heading
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Reports & Analytics", style: AppTextStyles.headerHeading),
//             Text(
//               "Comprehensive business performance metrics",
//               style: AppTextStyles.headerSubheading,
//             ),
//           ],
//         ),
//         const Spacer(),

//         // YEAR SELECTOR
//         _buildStyledContainer(
//           child: DropdownButton<int>(
//             value: state.selectedYear,
//             underline: const SizedBox(),
//             isDense: true,
//             isExpanded: false,
//             icon: const Icon(Icons.keyboard_arrow_down),
//             items: List.generate(5, (index) {
//               final year = DateTime.now().year - index;
//               return DropdownMenuItem(
//                 value: year,
//                 child: Text(year.toString()),
//               );
//             }),
//             onChanged: (year) {
//               if (year != null) {
//                 context.read<ReportCubit>().changeYear(year);
//               }
//             },
//           ),
//         ),

//         const SizedBox(width: 12),

//         // TIME FILTER
//         _buildStyledContainer(
//           child: DropdownButton<ReportTimeFilter>(
//             value: state.timeFilter,
//             underline: const SizedBox(),
//             isDense: true,
//             icon: const Icon(Icons.keyboard_arrow_down),
//             items: const [
//               DropdownMenuItem(
//                 value: ReportTimeFilter.yearly,
//                 child: Text("Yearly"),
//               ),
//               DropdownMenuItem(
//                 value: ReportTimeFilter.monthly,
//                 child: Text("Monthly"),
//               ),
//             ],
//             onChanged: (filter) {
//               if (filter != null) {
//                 context.read<ReportCubit>().changeTimeFilter(filter);
//               }
//             },
//           ),
//         ),

//         const SizedBox(width: 12),

//         // EXPORT BUTTON (styled to match dropdowns)
//         _buildStyledContainer(
//           isButton: true,
//           child: InkWell(
//             onTap: () {
//               // Handle export
//             },
//             borderRadius: BorderRadius.circular(8),
//             child: Row(
//               children: const [
//                 Icon(
//                   CupertinoIcons.cloud_download,
//                   size: 16,
//                   color: Colors.white,
//                 ),
//                 SizedBox(width: 8),
//                 Text("Export Report", style: TextStyle(color: Colors.white)),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildKeyMetrics(ReportState state) {
//     return StaggeredGrid.extent(
//       maxCrossAxisExtent: 300,
//       mainAxisSpacing: 16,
//       crossAxisSpacing: 16,
//       children: [
//         StatCardIconRight(
//           icon: CupertinoIcons.money_dollar_circle,
//           label: "Total Revenue (YTD)",
//           value: "\$${state.totalRevenue.toStringAsFixed(2)}",
//           iconColor: Colors.green,
//         ),
//         StatCardIconRight(
//           icon: CupertinoIcons.person_2,
//           label: "Active Subscribers",
//           value: "${state.activeSubscribers}",
//           iconColor: Colors.blue,
//         ),
//         StatCardIconRight(
//           icon: CupertinoIcons.chart_bar,
//           label: "Churn Rate",
//           value: "${state.churnRate.toStringAsFixed(1)}%",
//           iconColor: state.churnRate > 10 ? Colors.red : Colors.orange,
//         ),
//         StatCardIconRight(
//           icon: CupertinoIcons.money_dollar,
//           label: "Avg. Revenue Per User",
//           value: "\$${state.avgRevenuePerUser.toStringAsFixed(2)}",
//           iconColor: Colors.purple,
//         ),
//       ],
//     );
//   }

//   Widget _buildRevenueChart(ReportState state) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.1),
//             spreadRadius: 1,
//             blurRadius: 3,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Revenue Trend",
//                 style: GoogleFonts.inter(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(CupertinoIcons.arrow_down_doc),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             height: 250,
//             child: state.revenueByMonth.isEmpty
//                 ? const Center(child: Text("No data available"))
//                 : LineChart(
//                     LineChartData(
//                       gridData: FlGridData(show: true),
//                       titlesData: FlTitlesData(
//                         leftTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             reservedSize: 40,
//                             getTitlesWidget: (value, meta) {
//                               return Text(
//                                 '\$${(value / 1000).toStringAsFixed(0)}k',
//                                 style: GoogleFonts.inter(fontSize: 10),
//                               );
//                             },
//                           ),
//                         ),
//                         bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             getTitlesWidget: (value, meta) {
//                               if (value.toInt() >= 0 &&
//                                   value.toInt() < state.revenueByMonth.length) {
//                                 return Text(
//                                   state.revenueByMonth[value.toInt()]['month'],
//                                   style: GoogleFonts.inter(fontSize: 10),
//                                 );
//                               }
//                               return const Text('');
//                             },
//                           ),
//                         ),
//                         rightTitles: const AxisTitles(
//                           sideTitles: SideTitles(showTitles: false),
//                         ),
//                         topTitles: const AxisTitles(
//                           sideTitles: SideTitles(showTitles: false),
//                         ),
//                       ),
//                       borderData: FlBorderData(show: true),
//                       lineBarsData: [
//                         LineChartBarData(
//                           spots: state.revenueByMonth
//                               .asMap()
//                               .entries
//                               .map(
//                                 (e) => FlSpot(
//                                   e.key.toDouble(),
//                                   e.value['revenue'].toDouble(),
//                                 ),
//                               )
//                               .toList(),
//                           isCurved: true,
//                           color: Colors.blue,
//                           barWidth: 3,
//                           dotData: const FlDotData(show: true),
//                           belowBarData: BarAreaData(
//                             show: true,
//                             color: Colors.blue.withValues(alpha: 0.1),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPlanDistributionChart(ReportState state) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.1),
//             spreadRadius: 1,
//             blurRadius: 3,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Plan Distribution",
//             style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             height: 250,
//             child: state.planDistribution.isEmpty
//                 ? const Center(child: Text("No data available"))
//                 : Row(
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: PieChart(
//                           PieChartData(
//                             sections: _getPlanSections(state),
//                             sectionsSpace: 2,
//                             centerSpaceRadius: 60,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: state.planDistribution.entries
//                               .map(
//                                 (entry) => Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 4,
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         width: 12,
//                                         height: 12,
//                                         decoration: BoxDecoration(
//                                           color: _getPlanColor(entry.key),
//                                           shape: BoxShape.circle,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Expanded(
//                                         child: Text(
//                                           '${entry.key} (${entry.value})',
//                                           style: GoogleFonts.inter(
//                                             fontSize: 12,
//                                           ),
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                               .toList(),
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildClientAcquisitionChart(ReportState state) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.1),
//             spreadRadius: 1,
//             blurRadius: 3,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "New Client Acquisition",
//             style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             height: 250,
//             child: state.clientAcquisitionByMonth.isEmpty
//                 ? const Center(child: Text("No data available"))
//                 : BarChart(
//                     BarChartData(
//                       gridData: FlGridData(show: true),
//                       titlesData: FlTitlesData(
//                         leftTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             reservedSize: 40,
//                             getTitlesWidget: (value, meta) {
//                               return Text(
//                                 value.toInt().toString(),
//                                 style: GoogleFonts.inter(fontSize: 10),
//                               );
//                             },
//                           ),
//                         ),
//                         bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             getTitlesWidget: (value, meta) {
//                               if (value.toInt() >= 0 &&
//                                   value.toInt() <
//                                       state.clientAcquisitionByMonth.length) {
//                                 return Text(
//                                   state.clientAcquisitionByMonth[value
//                                       .toInt()]['month'],
//                                   style: GoogleFonts.inter(fontSize: 10),
//                                 );
//                               }
//                               return const Text('');
//                             },
//                           ),
//                         ),
//                         rightTitles: const AxisTitles(
//                           sideTitles: SideTitles(showTitles: false),
//                         ),
//                         topTitles: const AxisTitles(
//                           sideTitles: SideTitles(showTitles: false),
//                         ),
//                       ),
//                       borderData: FlBorderData(show: true),
//                       barGroups: state.clientAcquisitionByMonth
//                           .asMap()
//                           .entries
//                           .map(
//                             (e) => BarChartGroupData(
//                               x: e.key,
//                               barRods: [
//                                 BarChartRodData(
//                                   toY: e.value['count'].toDouble(),
//                                   color: Colors.green,
//                                   width: 20,
//                                   borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(4),
//                                     topRight: Radius.circular(4),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                           .toList(),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildChurnVsRetentionChart(ReportState state) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.1),
//             spreadRadius: 1,
//             blurRadius: 3,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Churn vs Retention",
//             style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             height: 250,
//             child: state.churnVsRetention.isEmpty
//                 ? const Center(child: Text("No data available"))
//                 : BarChart(
//                     BarChartData(
//                       gridData: FlGridData(show: true),
//                       titlesData: FlTitlesData(
//                         leftTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             reservedSize: 40,
//                             getTitlesWidget: (value, meta) {
//                               return Text(
//                                 value.toInt().toString(),
//                                 style: GoogleFonts.inter(fontSize: 10),
//                               );
//                             },
//                           ),
//                         ),
//                         bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             getTitlesWidget: (value, meta) {
//                               if (value.toInt() >= 0 &&
//                                   value.toInt() <
//                                       state.churnVsRetention.length) {
//                                 return Text(
//                                   state.churnVsRetention[value
//                                       .toInt()]['month'],
//                                   style: GoogleFonts.inter(fontSize: 10),
//                                 );
//                               }
//                               return const Text('');
//                             },
//                           ),
//                         ),
//                         rightTitles: const AxisTitles(
//                           sideTitles: SideTitles(showTitles: false),
//                         ),
//                         topTitles: const AxisTitles(
//                           sideTitles: SideTitles(showTitles: false),
//                         ),
//                       ),
//                       borderData: FlBorderData(show: true),
//                       barGroups: state.churnVsRetention
//                           .asMap()
//                           .entries
//                           .map(
//                             (e) => BarChartGroupData(
//                               x: e.key,
//                               barRods: [
//                                 BarChartRodData(
//                                   toY: e.value['retained'].toDouble(),
//                                   color: Colors.green,
//                                   width: 12,
//                                 ),
//                                 BarChartRodData(
//                                   toY: e.value['churned'].toDouble(),
//                                   color: Colors.red,
//                                   width: 12,
//                                 ),
//                               ],
//                             ),
//                           )
//                           .toList(),
//                     ),
//                   ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildLegendItem(Colors.green, "Retained"),
//               const SizedBox(width: 20),
//               _buildLegendItem(Colors.red, "Churned"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLegendItem(Color color, String label) {
//     return Row(
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         const SizedBox(width: 8),
//         Text(label, style: GoogleFonts.inter(fontSize: 12)),
//       ],
//     );
//   }

//   List<PieChartSectionData> _getPlanSections(ReportState state) {
//     final colors = [
//       Colors.blue,
//       Colors.orange,
//       Colors.green,
//       Colors.purple,
//       Colors.red,
//       Colors.teal,
//     ];

//     return state.planDistribution.entries.toList().asMap().entries.map((entry) {
//       final index = entry.key;
//       final planEntry = entry.value;
//       final total = state.planDistribution.values.fold<int>(
//         0,
//         (sum, count) => sum + count,
//       );
//       final percentage = (planEntry.value / total * 100).toStringAsFixed(1);

//       return PieChartSectionData(
//         color: colors[index % colors.length],
//         value: planEntry.value.toDouble(),
//         title: '$percentage%',
//         radius: 80,
//         titleStyle: GoogleFonts.inter(
//           fontSize: 14,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       );
//     }).toList();
//   }

//   Color _getPlanColor(String planName) {
//     final colors = {
//       'Basic': Colors.blue,
//       'Standard': Colors.orange,
//       'Premium': Colors.green,
//       'Enterprise': Colors.purple,
//     };
//     return colors[planName] ?? Colors.grey;
//   }

//   Widget _buildStyledContainer({required Widget child, bool isButton = false}) {
//     return Container(
//       height: 48,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: isButton ? Colors.black : Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       alignment: Alignment.center,
//       child: child,
//     );
//   }
// }
