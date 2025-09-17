import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';

class ClientAnalyticsChart extends StatelessWidget {
  final String timeRange;

  const ClientAnalyticsChart({
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
                'Client Analytics',
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
              _buildLegendItem('Active', Colors.green, _getClientData().active),
              _buildLegendItem('Trial', Colors.orange, _getClientData().trial),
              _buildLegendItem('Expired', Colors.red, _getClientData().expired),
              _buildLegendItem('Churned', Colors.grey, _getClientData().churned),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, int count) {
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
          '$label ($count)',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
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
    final data = _getClientData();
    final total = data.active + data.trial + data.expired + data.churned;
    
    return [
      PieChartSectionData(
        color: Colors.green,
        value: (data.active / total * 100),
        title: '${(data.active / total * 100).toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: (data.trial / total * 100),
        title: '${(data.trial / total * 100).toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: (data.expired / total * 100),
        title: '${(data.expired / total * 100).toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.grey,
        value: (data.churned / total * 100),
        title: '${(data.churned / total * 100).toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  ClientData _getClientData() {
    switch (timeRange) {
      case '7d':
        return ClientData(
          active: 45,
          trial: 8,
          expired: 3,
          churned: 2,
        );
      case '30d':
        return ClientData(
          active: 52,
          trial: 12,
          expired: 5,
          churned: 4,
        );
      case '90d':
        return ClientData(
          active: 67,
          trial: 15,
          expired: 8,
          churned: 7,
        );
      case '1y':
        return ClientData(
          active: 89,
          trial: 23,
          expired: 15,
          churned: 18,
        );
      default: // 'all'
        return ClientData(
          active: 124,
          trial: 34,
          expired: 28,
          churned: 45,
        );
    }
  }
}

class ClientData {
  final int active;
  final int trial;
  final int expired;
  final int churned;

  const ClientData({
    required this.active,
    required this.trial,
    required this.expired,
    required this.churned,
  });
}
