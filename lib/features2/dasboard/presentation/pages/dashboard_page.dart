import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features2/super_admin/presentation/widgets/kpi_card.dart';
import 'package:taskoteladmin/features2/super_admin/presentation/widgets/revenue_chart.dart';
import 'package:taskoteladmin/features2/super_admin/presentation/widgets/subscription_growth_chart.dart';
import 'package:taskoteladmin/features2/super_admin/presentation/widgets/plan_distribution_chart.dart';
import 'package:taskoteladmin/features2/super_admin/domain/entities/dashboard_analytics_entity.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isLoading = true;
  DashboardAnalyticsEntity? _analytics;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    // TODO: Replace with actual data loading from repository
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _analytics = _getMockAnalytics();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: ResponsiveWid(
        mobile: _buildMobileLayout(),
        desktop: _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildKPICards(),
          const SizedBox(height: 24),
          _buildChartsSection(),
          const SizedBox(height: 24),
          _buildQuickInsights(),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildKPICards(),
          const SizedBox(height: 16),
          _buildChartsSection(),
          const SizedBox(height: 16),
          _buildQuickInsights(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Super Admin Dashboard',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome back! Here\'s what\'s happening with your SaaS platform.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildKPICards() {
    if (_isLoading) {
      return _buildKPICardsSkeleton();
    }

    if (_analytics == null) {
      return const SizedBox.shrink();
    }

    final kpi = _analytics!.kpiMetrics;

    return ResponsiveWid(
      mobile: Column(
        children: [
          _buildKPICard(
            'Active Subscriptions',
            kpi.activeSubscriptions.toString(),
            Icons.subscriptions,
            Colors.blue,
            trend: '${kpi.monthlyGrowthRate.toStringAsFixed(1)}%',
            isPositiveTrend: kpi.monthlyGrowthRate > 0,
          ),
          const SizedBox(height: 16),
          _buildKPICard(
            'Monthly Revenue',
            '\$${_formatNumber(kpi.monthlyRevenue)}',
            Icons.attach_money,
            Colors.green,
            trend: '${kpi.revenueGrowthRate.toStringAsFixed(1)}%',
            isPositiveTrend: kpi.revenueGrowthRate > 0,
          ),
          const SizedBox(height: 16),
          _buildKPICard(
            'Total Clients',
            kpi.totalClients.toString(),
            Icons.people,
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildKPICard(
            'Total Hotels',
            kpi.totalHotels.toString(),
            Icons.hotel,
            Colors.purple,
          ),
        ],
      ),
      desktop: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: [
          _buildKPICard(
            'Active Subscriptions',
            kpi.activeSubscriptions.toString(),
            Icons.subscriptions,
            Colors.blue,
            trend: '${kpi.monthlyGrowthRate.toStringAsFixed(1)}%',
            isPositiveTrend: kpi.monthlyGrowthRate > 0,
          ),
          _buildKPICard(
            'Monthly Revenue',
            '\$${_formatNumber(kpi.monthlyRevenue)}',
            Icons.attach_money,
            Colors.green,
            trend: '${kpi.revenueGrowthRate.toStringAsFixed(1)}%',
            isPositiveTrend: kpi.revenueGrowthRate > 0,
          ),
          _buildKPICard(
            'Total Clients',
            kpi.totalClients.toString(),
            Icons.people,
            Colors.orange,
          ),
          _buildKPICard(
            'Total Hotels',
            kpi.totalHotels.toString(),
            Icons.hotel,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildKPICardsSkeleton() {
    return ResponsiveWid(
      mobile: Column(
        children: List.generate(
          4,
          (index) => const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: KPICardSkeleton(),
          ),
        ),
      ),
      desktop: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: List.generate(4, (index) => const KPICardSkeleton()),
      ),
    );
  }

  Widget _buildKPICard(
    String title,
    String value,
    IconData icon,
    Color iconColor, {
    String? trend,
    bool isPositiveTrend = true,
  }) {
    return KPICard(
      title: title,
      value: value,
      icon: icon,
      iconColor: iconColor,
      trend: trend,
      isPositiveTrend: isPositiveTrend,
    );
  }

  Widget _buildChartsSection() {
    if (_isLoading || _analytics == null) {
      return _buildChartsSkeleton();
    }

    return ResponsiveWid(
      mobile: Column(
        children: [
          RevenueChart(revenueData: _analytics!.revenueData),
          const SizedBox(height: 16),
          SubscriptionGrowthChart(
            growthData: _analytics!.subscriptionGrowthData,
          ),
          const SizedBox(height: 16),
          PlanDistributionChart(
            distributionData: _analytics!.planDistributionData,
          ),
        ],
      ),
      desktop: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: RevenueChart(revenueData: _analytics!.revenueData),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PlanDistributionChart(
                  distributionData: _analytics!.planDistributionData,
                  height: 350,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SubscriptionGrowthChart(
            growthData: _analytics!.subscriptionGrowthData,
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSkeleton() {
    return Column(
      children: [
        Container(
          height: 300,
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
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
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
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickInsights() {
    if (_isLoading || _analytics == null) {
      return const SizedBox.shrink();
    }

    final insights = _analytics!.quickInsights;

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
          const Text(
            'Quick Insights',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          ResponsiveWid(
            mobile: Column(
              children: [
                _buildInsightItem(
                  'Best Selling Plan',
                  insights.bestSellingPlan,
                  Icons.star,
                  Colors.amber,
                ),
                const SizedBox(height: 12),
                _buildInsightItem(
                  'Trial to Paid Conversion',
                  '${insights.trialToPaidConversionRate.toStringAsFixed(1)}%',
                  Icons.trending_up,
                  Colors.green,
                ),
                const SizedBox(height: 12),
                _buildInsightItem(
                  'Avg Revenue per Hotel',
                  '\$${_formatNumber(insights.averageRevenuePerHotel)}',
                  Icons.hotel,
                  Colors.blue,
                ),
              ],
            ),
            desktop: Row(
              children: [
                Expanded(
                  child: _buildInsightItem(
                    'Best Selling Plan',
                    insights.bestSellingPlan,
                    Icons.star,
                    Colors.amber,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInsightItem(
                    'Trial to Paid Conversion',
                    '${insights.trialToPaidConversionRate.toStringAsFixed(1)}%',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInsightItem(
                    'Avg Revenue per Hotel',
                    '\$${_formatNumber(insights.averageRevenuePerHotel)}',
                    Icons.hotel,
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
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

  // Mock data for demonstration - replace with actual repository calls
  DashboardAnalyticsEntity _getMockAnalytics() {
    return DashboardAnalyticsEntity(
      kpiMetrics: const KPIMetrics(
        activeSubscriptions: 1247,
        monthlyRevenue: 89500.0,
        totalRevenue: 2450000.0,
        totalClients: 342,
        totalHotels: 1247,
        totalSubscriptionPlans: 5,
        churnedClients: 23,
        mostPopularPlan: 'Professional',
        monthlyGrowthRate: 12.5,
        revenueGrowthRate: 18.3,
      ),
      revenueData: _getMockRevenueData(),
      subscriptionGrowthData: _getMockSubscriptionGrowthData(),
      churnData: [],
      planDistributionData: _getMockPlanDistributionData(),
      quickInsights: const QuickInsights(
        bestSellingPlan: 'Professional Plan',
        trialToPaidConversionRate: 23.5,
        averageRevenuePerHotel: 71.8,
        customerLifetimeValue: 2450.0,
        daysToChurn: 45,
        topChurnReasons: ['Price too high', 'Missing features', 'Poor support'],
      ),
    );
  }

  List<RevenueDataPoint> _getMockRevenueData() {
    final now = DateTime.now();
    return List.generate(12, (index) {
      final date = DateTime(now.year, now.month - 11 + index, 1);
      final baseRevenue = 50000.0 + (index * 5000);
      return RevenueDataPoint(
        date: date,
        revenue: baseRevenue + (index * 1000),
        mrr: baseRevenue,
        arr: baseRevenue * 12,
      );
    });
  }

  List<SubscriptionGrowthDataPoint> _getMockSubscriptionGrowthData() {
    final now = DateTime.now();
    return List.generate(12, (index) {
      final date = DateTime(now.year, now.month - 11 + index, 1);
      return SubscriptionGrowthDataPoint(
        date: date,
        newSubscriptions: 45 + (index * 2),
        cancelledSubscriptions: 12 + index,
        netGrowth: 33 + index,
        totalActive: 500 + (index * 33),
      );
    });
  }

  List<PlanDistributionDataPoint> _getMockPlanDistributionData() {
    return const [
      PlanDistributionDataPoint(
        planName: 'Starter',
        subscribers: 450,
        revenue: 13500.0,
        percentage: 36.1,
      ),
      PlanDistributionDataPoint(
        planName: 'Professional',
        subscribers: 520,
        revenue: 31200.0,
        percentage: 41.7,
      ),
      PlanDistributionDataPoint(
        planName: 'Enterprise',
        subscribers: 180,
        revenue: 27000.0,
        percentage: 14.4,
      ),
      PlanDistributionDataPoint(
        planName: 'Premium',
        subscribers: 97,
        revenue: 17460.0,
        percentage: 7.8,
      ),
    ];
  }
}
