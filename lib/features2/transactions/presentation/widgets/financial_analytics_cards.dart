import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/features2/super_admin/domain/entities/transaction_entity.dart';

class FinancialAnalyticsCards extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const FinancialAnalyticsCards({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final analytics = _calculateAnalytics();

    return Row(
      children: [
        Expanded(
          child: _buildAnalyticsCard(
            'Total Revenue',
            '\$${_formatNumber(analytics.totalRevenue)}',
            Icons.attach_money,
            Colors.green,
            subtitle: 'All time',
            trend: analytics.revenueTrend,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAnalyticsCard(
            'Monthly Recurring Revenue',
            '\$${_formatNumber(analytics.mrr)}',
            Icons.trending_up,
            Colors.blue,
            subtitle: 'MRR',
            trend: analytics.mrrTrend,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAnalyticsCard(
            'Annual Recurring Revenue',
            '\$${_formatNumber(analytics.arr)}',
            Icons.calendar_today,
            Colors.purple,
            subtitle: 'ARR',
            trend: analytics.arrTrend,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAnalyticsCard(
            'Success Rate',
            '${analytics.successRate.toStringAsFixed(1)}%',
            Icons.check_circle,
            Colors.orange,
            subtitle: 'Payment success',
            trend: analytics.successRateTrend,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAnalyticsCard(
            'Pending Payments',
            '${analytics.pendingCount}',
            Icons.pending,
            Colors.amber,
            subtitle: '\$${_formatNumber(analytics.pendingAmount)}',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAnalyticsCard(
            'Failed Transactions',
            '${analytics.failedCount}',
            Icons.error,
            Colors.red,
            subtitle: '\$${_formatNumber(analytics.failedAmount)}',
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard(
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isPositive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            size: 12,
            color: isPositive ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 2),
          Text(
            '${trend.abs().toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isPositive ? Colors.green : Colors.red,
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

  FinancialAnalytics _calculateAnalytics() {
    final completedTransactions = transactions.where((t) => t.status == TransactionStatus.completed).toList();
    final pendingTransactions = transactions.where((t) => t.status == TransactionStatus.pending).toList();
    final failedTransactions = transactions.where((t) => t.status == TransactionStatus.failed).toList();
    
    final totalRevenue = completedTransactions.fold(0.0, (sum, t) => sum + t.amount);
    final pendingAmount = pendingTransactions.fold(0.0, (sum, t) => sum + t.amount);
    final failedAmount = failedTransactions.fold(0.0, (sum, t) => sum + t.amount);
    
    final totalTransactions = transactions.length;
    final successfulTransactions = completedTransactions.length;
    final successRate = totalTransactions > 0 ? (successfulTransactions / totalTransactions) * 100 : 0.0;
    
    // Calculate MRR (Monthly Recurring Revenue) - simplified calculation
    final mrr = totalRevenue; // In a real app, this would be more sophisticated
    final arr = mrr * 12; // Annual Recurring Revenue
    
    return FinancialAnalytics(
      totalRevenue: totalRevenue,
      mrr: mrr,
      arr: arr,
      successRate: successRate,
      pendingCount: pendingTransactions.length,
      pendingAmount: pendingAmount,
      failedCount: failedTransactions.length,
      failedAmount: failedAmount,
      revenueTrend: 12.5, // Mock trend data
      mrrTrend: 8.3,
      arrTrend: 15.2,
      successRateTrend: 2.1,
    );
  }
}

class FinancialAnalytics {
  final double totalRevenue;
  final double mrr;
  final double arr;
  final double successRate;
  final int pendingCount;
  final double pendingAmount;
  final int failedCount;
  final double failedAmount;
  final double revenueTrend;
  final double mrrTrend;
  final double arrTrend;
  final double successRateTrend;

  const FinancialAnalytics({
    required this.totalRevenue,
    required this.mrr,
    required this.arr,
    required this.successRate,
    required this.pendingCount,
    required this.pendingAmount,
    required this.failedCount,
    required this.failedAmount,
    required this.revenueTrend,
    required this.mrrTrend,
    required this.arrTrend,
    required this.successRateTrend,
  });
}
