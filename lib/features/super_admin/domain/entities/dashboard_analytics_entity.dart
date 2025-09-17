import 'package:equatable/equatable.dart';

class DashboardAnalyticsEntity extends Equatable {
  final KPIMetrics kpiMetrics;
  final List<RevenueDataPoint> revenueData;
  final List<SubscriptionGrowthDataPoint> subscriptionGrowthData;
  final List<ChurnDataPoint> churnData;
  final List<PlanDistributionDataPoint> planDistributionData;
  final QuickInsights quickInsights;

  const DashboardAnalyticsEntity({
    required this.kpiMetrics,
    required this.revenueData,
    required this.subscriptionGrowthData,
    required this.churnData,
    required this.planDistributionData,
    required this.quickInsights,
  });

  @override
  List<Object?> get props => [
        kpiMetrics,
        revenueData,
        subscriptionGrowthData,
        churnData,
        planDistributionData,
        quickInsights,
      ];
}

class KPIMetrics extends Equatable {
  final int activeSubscriptions;
  final double monthlyRevenue;
  final double totalRevenue;
  final int totalClients;
  final int totalHotels;
  final int totalSubscriptionPlans;
  final int churnedClients;
  final String mostPopularPlan;
  final double monthlyGrowthRate;
  final double revenueGrowthRate;

  const KPIMetrics({
    required this.activeSubscriptions,
    required this.monthlyRevenue,
    required this.totalRevenue,
    required this.totalClients,
    required this.totalHotels,
    required this.totalSubscriptionPlans,
    required this.churnedClients,
    required this.mostPopularPlan,
    required this.monthlyGrowthRate,
    required this.revenueGrowthRate,
  });

  @override
  List<Object?> get props => [
        activeSubscriptions,
        monthlyRevenue,
        totalRevenue,
        totalClients,
        totalHotels,
        totalSubscriptionPlans,
        churnedClients,
        mostPopularPlan,
        monthlyGrowthRate,
        revenueGrowthRate,
      ];
}

class RevenueDataPoint extends Equatable {
  final DateTime date;
  final double revenue;
  final double mrr; // Monthly Recurring Revenue
  final double arr; // Annual Recurring Revenue

  const RevenueDataPoint({
    required this.date,
    required this.revenue,
    required this.mrr,
    required this.arr,
  });

  @override
  List<Object?> get props => [date, revenue, mrr, arr];
}

class SubscriptionGrowthDataPoint extends Equatable {
  final DateTime date;
  final int newSubscriptions;
  final int cancelledSubscriptions;
  final int netGrowth;
  final int totalActive;

  const SubscriptionGrowthDataPoint({
    required this.date,
    required this.newSubscriptions,
    required this.cancelledSubscriptions,
    required this.netGrowth,
    required this.totalActive,
  });

  @override
  List<Object?> get props => [
        date,
        newSubscriptions,
        cancelledSubscriptions,
        netGrowth,
        totalActive,
      ];
}

class ChurnDataPoint extends Equatable {
  final DateTime date;
  final int churnedClients;
  final int churnedHotels;
  final double churnRate;
  final List<String> churnReasons;

  const ChurnDataPoint({
    required this.date,
    required this.churnedClients,
    required this.churnedHotels,
    required this.churnRate,
    required this.churnReasons,
  });

  @override
  List<Object?> get props => [
        date,
        churnedClients,
        churnedHotels,
        churnRate,
        churnReasons,
      ];
}

class PlanDistributionDataPoint extends Equatable {
  final String planName;
  final int subscribers;
  final double revenue;
  final double percentage;

  const PlanDistributionDataPoint({
    required this.planName,
    required this.subscribers,
    required this.revenue,
    required this.percentage,
  });

  @override
  List<Object?> get props => [planName, subscribers, revenue, percentage];
}

class QuickInsights extends Equatable {
  final String bestSellingPlan;
  final double trialToPaidConversionRate;
  final double averageRevenuePerHotel;
  final double customerLifetimeValue;
  final int daysToChurn;
  final List<String> topChurnReasons;

  const QuickInsights({
    required this.bestSellingPlan,
    required this.trialToPaidConversionRate,
    required this.averageRevenuePerHotel,
    required this.customerLifetimeValue,
    required this.daysToChurn,
    required this.topChurnReasons,
  });

  @override
  List<Object?> get props => [
        bestSellingPlan,
        trialToPaidConversionRate,
        averageRevenuePerHotel,
        customerLifetimeValue,
        daysToChurn,
        topChurnReasons,
      ];
}
