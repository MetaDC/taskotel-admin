import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';

class RevenueBreakdownChart extends StatelessWidget {
  final String timeRange;

  const RevenueBreakdownChart({
    super.key,
    required this.timeRange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
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
              const Text(
                'Revenue Breakdown by Plan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getTimeRangeLabel(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    // Handle touch events if needed
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: _getPieChartSections(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildLegendItem('Starter', Colors.blue, _getRevenueData().starter),
              _buildLegendItem('Professional', Colors.green, _getRevenueData().professional),
              _buildLegendItem('Enterprise', Colors.purple, _getRevenueData().enterprise),
              _buildLegendItem('Legacy', Colors.orange, _getRevenueData().legacy),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, double amount) {
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
        const SizedBox(width: 6),
        Text(
          '$label (\$${_formatNumber(amount)})',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }

  String _getTimeRangeLabel() {
    switch (timeRange) {
      case '7d':
        return 'Last 7 days';
      case '30d':
        return 'Last 30 days';
      case '90d':
        return 'Last 90 days';
      case '1y':
        return 'Last year';
      case 'all':
        return 'All time';
      default:
        return 'Selected period';
    }
  }

  List<PieChartSectionData> _getPieChartSections() {
    final data = _getRevenueData();
    final total = data.starter + data.professional + data.enterprise + data.legacy;
    
    return [
      PieChartSectionData(
        color: Colors.blue,
        value: (data.starter / total * 100),
        title: '${(data.starter / total * 100).toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: (data.professional / total * 100),
        title: '${(data.professional / total * 100).toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.purple,
        value: (data.enterprise / total * 100),
        title: '${(data.enterprise / total * 100).toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: (data.legacy / total * 100),
        title: '${(data.legacy / total * 100).toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  RevenueData _getRevenueData() {
    switch (timeRange) {
      case '7d':
        return RevenueData(
          starter: 3250.0,
          professional: 7350.0,
          enterprise: 14850.0,
          legacy: 1050.0,
        );
      case '30d':
        return RevenueData(
          starter: 12800.0,
          professional: 28600.0,
          enterprise: 58200.0,
          legacy: 4200.0,
        );
      case '90d':
        return RevenueData(
          starter: 38400.0,
          professional: 85800.0,
          enterprise: 174600.0,
          legacy: 12600.0,
        );
      case '1y':
        return RevenueData(
          starter: 156000.0,
          professional: 348000.0,
          enterprise: 708000.0,
          legacy: 51000.0,
        );
      default: // 'all'
        return RevenueData(
          starter: 324500.0,
          professional: 724800.0,
          enterprise: 1475200.0,
          legacy: 106200.0,
        );
    }
  }
}

class RevenueData {
  final double starter;
  final double professional;
  final double enterprise;
  final double legacy;

  const RevenueData({
    required this.starter,
    required this.professional,
    required this.enterprise,
    required this.legacy,
  });
}
