// ============================================
// File 1: subscriber_distribution_chart.dart
// ============================================

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';

class SubscriberDistributionChart extends StatelessWidget {
  final List<SubscriptionPlanModel> plans;

  const SubscriberDistributionChart({super.key, required this.plans});

  @override
  Widget build(BuildContext context) {
    final sections = _generatePieChartSections();

    if (sections.isEmpty) {
      return Center(
        child: Text(
          'No subscriber data available',
          style: GoogleFonts.inter(color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        Text(
          'Subscriber Distribution',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 80,
                    sectionsSpace: 2,
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(child: _buildLegend()),
            ],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _generatePieChartSections() {
    final colors = [
      const Color(0xFF5B7C99), // Basic - Gray-blue
      const Color(0xFFF5A623), // Standard - Orange
      const Color(0xFF4A90E2), // Premium - Blue
      const Color(0xFF9B59B6), // Enterprise - Purple
    ];

    final activePlans = plans.where((p) => p.isActive).toList();
    final totalSubscribers = activePlans.fold<int>(
      0,
      (sum, plan) => sum + plan.totalSubScribers,
    );

    if (totalSubscribers == 0) return [];

    return List.generate(activePlans.length, (index) {
      final plan = activePlans[index];
      final percentage = (plan.totalSubScribers / totalSubscribers) * 100;

      return PieChartSectionData(
        value: plan.totalSubScribers.toDouble(),
        title: '${percentage.toStringAsFixed(0)}%',
        color: colors[index % colors.length],
        radius: 60,
        titleStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Widget _buildLegend() {
    final colors = [
      const Color(0xFF5B7C99),
      const Color(0xFFF5A623),
      const Color(0xFF4A90E2),
      const Color(0xFF9B59B6),
    ];

    final activePlans = plans.where((p) => p.isActive).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(activePlans.length, (index) {
        final plan = activePlans[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${plan.title} (${plan.totalSubScribers})',
                  style: GoogleFonts.inter(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ============================================
// File 2: revenue_by_plan_chart.dart
// ============================================

class RevenueByPlanChart extends StatelessWidget {
  final List<SubscriptionPlanModel> plans;

  const RevenueByPlanChart({super.key, required this.plans});

  @override
  Widget build(BuildContext context) {
    final activePlans = plans.where((p) => p.isActive).toList();

    if (activePlans.isEmpty) {
      return Center(
        child: Text(
          'No revenue data available',
          style: GoogleFonts.inter(color: Colors.grey),
        ),
      );
    }

    final maxRevenue = activePlans.fold<double>(
      0,
      (max, plan) => plan.totalRevenue > max ? plan.totalRevenue : max,
    );

    // If all revenues are 0, show a message
    if (maxRevenue == 0) {
      return Center(
        child: Text(
          'No revenue data available',
          style: GoogleFonts.inter(color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        Text(
          'Revenue by Plan',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: BarChart(
            BarChartData(
              maxY: maxRevenue * 1.2,
              barGroups: _generateBarGroups(activePlans),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '\$${(value / 1000).toStringAsFixed(0)}k',
                        style: GoogleFonts.inter(fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < activePlans.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            activePlans[index].title,
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                        );
                      }
                      return const SizedBox();
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
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxRevenue > 0 ? maxRevenue / 4 : 1,
              ),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '\$${rod.toY.toStringAsFixed(0)}',
                      GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _generateBarGroups(
    List<SubscriptionPlanModel> activePlans,
  ) {
    final colors = [
      const Color(0xFF5B7C99),
      const Color(0xFFF5A623),
      const Color(0xFF4A90E2),
      const Color(0xFF9B59B6),
    ];

    return List.generate(activePlans.length, (index) {
      final plan = activePlans[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: plan.totalRevenue,
            color: colors[index % colors.length],
            width: 40,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });
  }
}
