import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';

class ReportCards extends StatelessWidget {
  final String timeRange;
  final String reportType;

  const ReportCards({
    super.key,
    required this.timeRange,
    required this.reportType,
  });

  @override
  Widget build(BuildContext context) {
    final analytics = _getAnalyticsData();

    return Row(
      children: [
        Expanded(
          child: _buildReportCard(
            'Total Revenue',
            '\$${_formatNumber(analytics.totalRevenue)}',
            Icons.attach_money,
            Colors.green,
            subtitle: _getTimeRangeLabel(),
            trend: analytics.revenueTrend,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildReportCard(
            'Active Clients',
            '${analytics.activeClients}',
            Icons.people,
            Colors.blue,
            subtitle: '${analytics.newClients} new this period',
            trend: analytics.clientsTrend,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildReportCard(
            'Total Hotels',
            '${analytics.totalHotels}',
            Icons.hotel,
            Colors.purple,
            subtitle: '${analytics.activeHotels} active',
            trend: analytics.hotelsTrend,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildReportCard(
            'Avg. Revenue per Client',
            '\$${_formatNumber(analytics.arpc)}',
            Icons.trending_up,
            Colors.orange,
            subtitle: 'ARPC',
            trend: analytics.arpcTrend,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildReportCard(
            'Churn Rate',
            '${analytics.churnRate.toStringAsFixed(1)}%',
            Icons.trending_down,
            Colors.red,
            subtitle: 'Monthly churn',
            trend: analytics.churnTrend,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildReportCard(
            'Platform Usage',
            '${analytics.platformUsage.toStringAsFixed(1)}%',
            Icons.analytics,
            Colors.teal,
            subtitle: 'Daily active rate',
            trend: analytics.usageTrend,
          ),
        ),
      ],
    );
  }

  Widget _buildReportCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
    double? trend,
  }) {
    return Container(
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              if (trend != null) _buildTrendIndicator(trend),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrendIndicator(double trend) {
    final isPositive = trend >= 0;
    final isChurnRate = trend < 0; // For churn rate, negative is good
    final displayColor = isChurnRate ? (isPositive ? Colors.red : Colors.green) : (isPositive ? Colors.green : Colors.red);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: displayColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            size: 12,
            color: displayColor,
          ),
          const SizedBox(width: 2),
          Text(
            '${trend.abs().toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: displayColor,
            ),
          ),
        ],
      ),
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

  ReportAnalytics _getAnalyticsData() {
    // Mock data based on time range and report type
    switch (timeRange) {
      case '7d':
        return ReportAnalytics(
          totalRevenue: 12500.0,
          activeClients: 45,
          newClients: 3,
          totalHotels: 78,
          activeHotels: 72,
          arpc: 277.8,
          churnRate: 2.1,
          platformUsage: 87.5,
          revenueTrend: 8.5,
          clientsTrend: 12.3,
          hotelsTrend: 5.7,
          arpcTrend: 3.2,
          churnTrend: -0.5, // Negative is good for churn
          usageTrend: 4.1,
        );
      case '30d':
        return ReportAnalytics(
          totalRevenue: 48750.0,
          activeClients: 52,
          newClients: 8,
          totalHotels: 89,
          activeHotels: 84,
          arpc: 937.5,
          churnRate: 3.8,
          platformUsage: 82.3,
          revenueTrend: 15.2,
          clientsTrend: 18.5,
          hotelsTrend: 12.4,
          arpcTrend: 7.8,
          churnTrend: -1.2,
          usageTrend: 6.7,
        );
      case '90d':
        return ReportAnalytics(
          totalRevenue: 142300.0,
          activeClients: 67,
          newClients: 23,
          totalHotels: 112,
          activeHotels: 105,
          arpc: 2124.6,
          churnRate: 4.5,
          platformUsage: 79.8,
          revenueTrend: 22.1,
          clientsTrend: 34.3,
          hotelsTrend: 28.9,
          arpcTrend: 12.5,
          churnTrend: 0.8,
          usageTrend: 8.9,
        );
      case '1y':
        return ReportAnalytics(
          totalRevenue: 567800.0,
          activeClients: 89,
          newClients: 67,
          totalHotels: 156,
          activeHotels: 142,
          arpc: 6379.8,
          churnRate: 6.2,
          platformUsage: 76.4,
          revenueTrend: 45.7,
          clientsTrend: 67.4,
          hotelsTrend: 52.3,
          arpcTrend: 28.9,
          churnTrend: 2.1,
          usageTrend: 12.6,
        );
      default: // 'all'
        return ReportAnalytics(
          totalRevenue: 1234500.0,
          activeClients: 124,
          newClients: 124,
          totalHotels: 234,
          activeHotels: 198,
          arpc: 9955.6,
          churnRate: 8.7,
          platformUsage: 73.2,
          revenueTrend: 78.9,
          clientsTrend: 124.0,
          hotelsTrend: 89.7,
          arpcTrend: 45.2,
          churnTrend: 3.4,
          usageTrend: 18.5,
        );
    }
  }
}

class ReportAnalytics {
  final double totalRevenue;
  final int activeClients;
  final int newClients;
  final int totalHotels;
  final int activeHotels;
  final double arpc; // Average Revenue Per Client
  final double churnRate;
  final double platformUsage;
  final double revenueTrend;
  final double clientsTrend;
  final double hotelsTrend;
  final double arpcTrend;
  final double churnTrend;
  final double usageTrend;

  const ReportAnalytics({
    required this.totalRevenue,
    required this.activeClients,
    required this.newClients,
    required this.totalHotels,
    required this.activeHotels,
    required this.arpc,
    required this.churnRate,
    required this.platformUsage,
    required this.revenueTrend,
    required this.clientsTrend,
    required this.hotelsTrend,
    required this.arpcTrend,
    required this.churnTrend,
    required this.usageTrend,
  });
}
