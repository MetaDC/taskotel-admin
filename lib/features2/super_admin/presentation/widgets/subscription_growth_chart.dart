import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/features2/super_admin/domain/entities/dashboard_analytics_entity.dart';
import 'package:intl/intl.dart';

class SubscriptionGrowthChart extends StatelessWidget {
  final List<SubscriptionGrowthDataPoint> growthData;
  final String title;
  final double height;

  const SubscriptionGrowthChart({
    super.key,
    required this.growthData,
    this.title = 'Subscription Growth',
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
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
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              _buildLegend(),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: growthData.isEmpty
                ? _buildEmptyState()
                : BarChart(_buildBarChartData()),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        _buildLegendItem('New', Colors.green),
        const SizedBox(width: 16),
        _buildLegendItem('Cancelled', Colors.red),
        const SizedBox(width: 16),
        _buildLegendItem('Net Growth', Colors.blue),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No subscription data available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  BarChartData _buildBarChartData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: _getMaxY(),
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.black87,
          tooltipRoundedRadius: 8,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String label;
            switch (rodIndex) {
              case 0:
                label = 'New: ${rod.toY.toInt()}';
                break;
              case 1:
                label = 'Cancelled: ${rod.toY.toInt()}';
                break;
              case 2:
                label = 'Net Growth: ${rod.toY.toInt()}';
                break;
              default:
                label = '';
            }
            return BarTooltipItem(
              label,
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: _buildBottomTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: _calculateInterval(),
            getTitlesWidget: _buildLeftTitles,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey[200]!),
      ),
      barGroups: _buildBarGroups(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: _calculateInterval(),
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey[200]!,
            strokeWidth: 1,
          );
        },
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return growthData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.newSubscriptions.toDouble(),
            color: Colors.green,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          BarChartRodData(
            toY: data.cancelledSubscriptions.toDouble(),
            color: Colors.red,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          BarChartRodData(
            toY: data.netGrowth.toDouble(),
            color: Colors.blue,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildBottomTitles(double value, TitleMeta meta) {
    if (value.toInt() >= growthData.length) return const Text('');
    
    final date = growthData[value.toInt()].date;
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        DateFormat('MMM').format(date),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildLeftTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        value.toInt().toString(),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
    );
  }

  double _getMaxY() {
    if (growthData.isEmpty) return 100;
    
    double maxValue = 0;
    for (final data in growthData) {
      final values = [
        data.newSubscriptions.toDouble(),
        data.cancelledSubscriptions.toDouble(),
        data.netGrowth.toDouble(),
      ];
      final localMax = values.reduce((a, b) => a > b ? a : b);
      if (localMax > maxValue) maxValue = localMax;
    }
    
    return maxValue * 1.2;
  }

  double _calculateInterval() {
    final maxY = _getMaxY();
    return maxY / 5;
  }
}
