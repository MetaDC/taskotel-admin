import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/custom_container.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';

// ============================================
// SUBSCRIBER DISTRIBUTION CHART
// ============================================
class SubscriberDistributionChart extends StatelessWidget {
  final List<SubscriptionPlanModel> plans;

  const SubscriberDistributionChart({Key? key, required this.plans})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Subscriber Distribution",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 40),
          Center(
            child: SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: _buildPieChartSections(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 80,
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          _buildLegend(),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final colors = [
      Color(0xFF5B7C99), // Slate blue
      Color(0xFFFFA726), // Orange
      Color(0xFF42A5F5), // Blue
      Color(0xFFAB47BC), // Purple
    ];

    return plans.asMap().entries.map((entry) {
      final index = entry.key;
      final plan = entry.value;
      final color = colors[index % colors.length];

      return PieChartSectionData(
        color: color,
        value: plan.totalSubScribers.toDouble(),
        title: '',
        radius: 60,
      );
    }).toList();
  }

  Widget _buildLegend() {
    final colors = [
      Color(0xFF5B7C99),
      Color(0xFFFFA726),
      Color(0xFF42A5F5),
      Color(0xFFAB47BC),
    ];

    return Wrap(
      spacing: 20,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: plans.asMap().entries.map((entry) {
        final index = entry.key;
        final plan = entry.value;
        final color = colors[index % colors.length];

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(width: 6),
            Text(
              "${plan.title} (${plan.totalSubScribers})",
              style: TextStyle(fontSize: 14),
            ),
          ],
        );
      }).toList(),
    );
  }
}

// ============================================
// REVENUE BY PLAN CHART
// ============================================
class RevenueByPlanChart extends StatelessWidget {
  final List<SubscriptionPlanModel> plans;

  const RevenueByPlanChart({Key? key, required this.plans}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Revenue by Plan",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 40),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxRevenue() * 1.2,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '\$${rod.toY.toStringAsFixed(0)}',
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < plans.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              plans[value.toInt()].title,
                              style: TextStyle(fontSize: 12),
                            ),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${(value / 1000).toStringAsFixed(0)}k',
                          style: TextStyle(fontSize: 11),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 7000,
                ),
                barGroups: _buildBarGroups(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return plans.asMap().entries.map((entry) {
      final index = entry.key;
      final plan = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: plan.totalRevenue,
            color: Color(0xFF42A5F5),
            width: 40,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  double _getMaxRevenue() {
    if (plans.isEmpty) return 30000;
    return plans.map((p) => p.totalRevenue).reduce((a, b) => a > b ? a : b);
  }
}

// ============================================
// PLAN DETAILS CARDS (Below Charts)
// ============================================
class PlanDetailsCard extends StatelessWidget {
  final SubscriptionPlanModel plan;

  const PlanDetailsCard({Key? key, required this.plan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plan.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              Icon(Icons.more_horiz, size: 20),
            ],
          ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "\${(plan.price['monthly'] ?? 0).toStringAsFixed(0)}",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                " /month",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            "\${(plan.price['yearly'] ?? 0).toStringAsFixed(0)} /year",
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            plan.desc,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.totalSubScribers.toString(),
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Subscribers",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$${plan.totalRevenue.toStringAsFixed(0)}",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Revenue",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
