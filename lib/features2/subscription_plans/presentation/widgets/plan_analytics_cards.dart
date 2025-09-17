import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/features2/super_admin/domain/entities/subscription_plan_entity.dart';

class PlanAnalyticsCards extends StatelessWidget {
  final List<SubscriptionPlanEntity> subscriptionPlans;

  const PlanAnalyticsCards({
    super.key,
    required this.subscriptionPlans,
  });

  @override
  Widget build(BuildContext context) {
    final totalPlans = subscriptionPlans.length;
    final activePlans = subscriptionPlans.where((p) => p.isActive).length;
    final totalSubscribers = subscriptionPlans.fold(0, (sum, p) => sum + p.totalSubscribers);
    final totalRevenue = subscriptionPlans.fold(0.0, (sum, p) => sum + p.totalRevenue);
    final averagePrice = subscriptionPlans.isNotEmpty 
        ? subscriptionPlans.fold(0.0, (sum, p) => sum + p.pricing.monthly) / subscriptionPlans.length
        : 0.0;

    return Row(
      children: [
        Expanded(
          child: _buildAnalyticsCard(
            'Total Plans',
            totalPlans.toString(),
            Icons.layers,
            Colors.blue,
            subtitle: '$activePlans active',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAnalyticsCard(
            'Total Subscribers',
            _formatNumber(totalSubscribers.toDouble()),
            Icons.people,
            Colors.green,
            subtitle: 'Across all plans',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAnalyticsCard(
            'Total Revenue',
            '\$${_formatNumber(totalRevenue)}',
            Icons.attach_money,
            Colors.orange,
            subtitle: 'Monthly recurring',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAnalyticsCard(
            'Average Price',
            '\$${averagePrice.toStringAsFixed(0)}',
            Icons.trending_up,
            Colors.purple,
            subtitle: 'Per month',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAnalyticsCard(
            'Most Popular',
            _getMostPopularPlan(),
            Icons.star,
            Colors.amber,
            subtitle: 'By subscribers',
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
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }

  String _getMostPopularPlan() {
    if (subscriptionPlans.isEmpty) return 'N/A';
    
    final sortedPlans = List<SubscriptionPlanEntity>.from(subscriptionPlans)
      ..sort((a, b) => b.totalSubscribers.compareTo(a.totalSubscribers));
    
    return sortedPlans.first.title;
  }
}
