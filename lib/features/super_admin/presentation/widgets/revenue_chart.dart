import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/features/super_admin/domain/entities/dashboard_analytics_entity.dart';
import 'package:intl/intl.dart';

class RevenueChart extends StatelessWidget {
  final List<RevenueDataPoint> revenueData;
  final String title;
  final double height;

  const RevenueChart({
    super.key,
    required this.revenueData,
    this.title = 'Revenue Trend',
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
            child: revenueData.isEmpty
                ? _buildEmptyState()
                : LineChart(_buildLineChartData()),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        _buildLegendItem('Revenue', Colors.blue),
        const SizedBox(width: 16),
        _buildLegendItem('MRR', Colors.green),
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
            shape: BoxShape.circle,
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
            Icons.show_chart,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No revenue data available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildLineChartData() {
    return LineChartData(
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
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: _buildBottomTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: _calculateInterval(),
            reservedSize: 60,
            getTitlesWidget: _buildLeftTitles,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey[200]!),
      ),
      minX: 0,
      maxX: revenueData.length.toDouble() - 1,
      minY: 0,
      maxY: _getMaxY(),
      lineBarsData: [
        _buildRevenueLineBarData(),
        _buildMRRLineBarData(),
      ],
    );
  }

  LineChartBarData _buildRevenueLineBarData() {
    return LineChartBarData(
      spots: revenueData
          .asMap()
          .entries
          .map((entry) => FlSpot(
                entry.key.toDouble(),
                entry.value.revenue,
              ))
          .toList(),
      isCurved: true,
      color: Colors.blue,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: Colors.blue.withOpacity(0.1),
      ),
    );
  }

  LineChartBarData _buildMRRLineBarData() {
    return LineChartBarData(
      spots: revenueData
          .asMap()
          .entries
          .map((entry) => FlSpot(
                entry.key.toDouble(),
                entry.value.mrr,
              ))
          .toList(),
      isCurved: true,
      color: Colors.green,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
    );
  }

  Widget _buildBottomTitles(double value, TitleMeta meta) {
    if (value.toInt() >= revenueData.length) return const Text('');
    
    final date = revenueData[value.toInt()].date;
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
        _formatCurrency(value),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
    );
  }

  double _getMaxY() {
    if (revenueData.isEmpty) return 100;
    
    final maxRevenue = revenueData
        .map((e) => e.revenue)
        .reduce((a, b) => a > b ? a : b);
    final maxMRR = revenueData
        .map((e) => e.mrr)
        .reduce((a, b) => a > b ? a : b);
    
    return (maxRevenue > maxMRR ? maxRevenue : maxMRR) * 1.2;
  }

  double _calculateInterval() {
    final maxY = _getMaxY();
    return maxY / 5;
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return '\$${value.toStringAsFixed(0)}';
    }
  }
}
