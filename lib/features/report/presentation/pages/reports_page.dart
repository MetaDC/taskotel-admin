import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/core/widget/stats_card.dart';
import 'package:taskoteladmin/features/report/presentation/cubit/report_cubit.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();
    // context.read<ReportCubit>().initialize();
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

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(state),
              const SizedBox(height: 30),

              // Key Metrics
              _buildKeyMetrics(state),
              const SizedBox(height: 30),

              // Charts Row 1
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildRevenueChart(state)),
                  const SizedBox(width: 20),
                  Expanded(child: _buildPlanDistributionChart(state)),
                ],
              ),
              const SizedBox(height: 30),

              // Charts Row 2
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildClientAcquisitionChart(state)),
                  const SizedBox(width: 20),
                  Expanded(child: _buildChurnVsRetentionChart(state)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ReportState state) {
    return Row(
      children: [
        Expanded(
          child: PageHeaderWithButton(
            heading: "Reports & Analytics",
            subHeading: "Comprehensive business performance metrics",
            buttonText: "Export Report",
            onButtonPressed: () {
              // TODO: Implement export functionality
            },
          ),
        ),
        const SizedBox(width: 20),
        // Year selector
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButton<int>(
            value: state.selectedYear,
            underline: const SizedBox(),
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
        // Time filter
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButton<ReportTimeFilter>(
            value: state.timeFilter,
            underline: const SizedBox(),
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
      ],
    );
  }

  Widget _buildKeyMetrics(ReportState state) {
    return StaggeredGrid.extent(
      maxCrossAxisExtent: 300,
      mainAxisSpacing: 16,
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

  Widget _buildRevenueChart(ReportState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Revenue Trend",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.arrow_down_doc),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: state.revenueByMonth.isEmpty
                ? const Center(child: Text("No data available"))
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '\$${(value / 1000).toStringAsFixed(0)}k',
                                style: const TextStyle(fontSize: 10),
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
                                  style: const TextStyle(fontSize: 10),
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
                          barWidth: 3,
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

  Widget _buildPlanDistributionChart(ReportState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Plan Distribution",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: state.planDistribution.isEmpty
                ? const Center(child: Text("No data available"))
                : Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: PieChart(
                          PieChartData(
                            sections: _getPlanSections(state),
                            sectionsSpace: 2,
                            centerSpaceRadius: 60,
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
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: _getPlanColor(entry.key),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${entry.key} (${entry.value})',
                                          style: const TextStyle(fontSize: 12),
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

  Widget _buildClientAcquisitionChart(ReportState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "New Client Acquisition",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: state.clientAcquisitionByMonth.isEmpty
                ? const Center(child: Text("No data available"))
                : BarChart(
                    BarChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 10),
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
                                  style: const TextStyle(fontSize: 10),
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
                                  width: 20,
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

  Widget _buildChurnVsRetentionChart(ReportState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Churn vs Retention",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: state.churnVsRetention.isEmpty
                ? const Center(child: Text("No data available"))
                : BarChart(
                    BarChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 10),
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
                                  style: const TextStyle(fontSize: 10),
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
                                  width: 12,
                                ),
                                BarChartRodData(
                                  toY: e.value['churned'].toDouble(),
                                  color: Colors.red,
                                  width: 12,
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.green, "Retained"),
              const SizedBox(width: 20),
              _buildLegendItem(Colors.red, "Churned"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  List<PieChartSectionData> _getPlanSections(ReportState state) {
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
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
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
}
