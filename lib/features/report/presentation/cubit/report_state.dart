part of 'report_cubit.dart';

enum ReportTimeFilter { yearly, monthly }

class ReportState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final ReportTimeFilter timeFilter;
  final int selectedYear;
  final int selectedMonth;
  
  // Revenue data
  final double totalRevenue;
  final List<Map<String, dynamic>> revenueByMonth;
  
  // Subscription data
  final int activeSubscribers;
  final int totalSubscribers;
  final double churnRate;
  final double avgRevenuePerUser;
  
  // Plan distribution
  final Map<String, int> planDistribution;
  final Map<String, double> planRevenue;
  
  // Client data
  final int newClientsThisMonth;
  final int churnedClientsThisMonth;
  final List<Map<String, dynamic>> clientAcquisitionByMonth;
  final List<Map<String, dynamic>> churnVsRetention;
  
  // Transaction data
  final int successfulTransactions;
  final int failedTransactions;
  final int pendingTransactions;
  final double totalTransactionAmount;

  const ReportState({
    this.isLoading = false,
    this.errorMessage,
    this.timeFilter = ReportTimeFilter.yearly,
    required this.selectedYear,
    required this.selectedMonth,
    this.totalRevenue = 0,
    this.revenueByMonth = const [],
    this.activeSubscribers = 0,
    this.totalSubscribers = 0,
    this.churnRate = 0,
    this.avgRevenuePerUser = 0,
    this.planDistribution = const {},
    this.planRevenue = const {},
    this.newClientsThisMonth = 0,
    this.churnedClientsThisMonth = 0,
    this.clientAcquisitionByMonth = const [],
    this.churnVsRetention = const [],
    this.successfulTransactions = 0,
    this.failedTransactions = 0,
    this.pendingTransactions = 0,
    this.totalTransactionAmount = 0,
  });

  factory ReportState.initial() {
    final now = DateTime.now();
    return ReportState(
      selectedYear: now.year,
      selectedMonth: now.month,
    );
  }

  ReportState copyWith({
    bool? isLoading,
    String? errorMessage,
    ReportTimeFilter? timeFilter,
    int? selectedYear,
    int? selectedMonth,
    double? totalRevenue,
    List<Map<String, dynamic>>? revenueByMonth,
    int? activeSubscribers,
    int? totalSubscribers,
    double? churnRate,
    double? avgRevenuePerUser,
    Map<String, int>? planDistribution,
    Map<String, double>? planRevenue,
    int? newClientsThisMonth,
    int? churnedClientsThisMonth,
    List<Map<String, dynamic>>? clientAcquisitionByMonth,
    List<Map<String, dynamic>>? churnVsRetention,
    int? successfulTransactions,
    int? failedTransactions,
    int? pendingTransactions,
    double? totalTransactionAmount,
  }) {
    return ReportState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      timeFilter: timeFilter ?? this.timeFilter,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      revenueByMonth: revenueByMonth ?? this.revenueByMonth,
      activeSubscribers: activeSubscribers ?? this.activeSubscribers,
      totalSubscribers: totalSubscribers ?? this.totalSubscribers,
      churnRate: churnRate ?? this.churnRate,
      avgRevenuePerUser: avgRevenuePerUser ?? this.avgRevenuePerUser,
      planDistribution: planDistribution ?? this.planDistribution,
      planRevenue: planRevenue ?? this.planRevenue,
      newClientsThisMonth: newClientsThisMonth ?? this.newClientsThisMonth,
      churnedClientsThisMonth: churnedClientsThisMonth ?? this.churnedClientsThisMonth,
      clientAcquisitionByMonth: clientAcquisitionByMonth ?? this.clientAcquisitionByMonth,
      churnVsRetention: churnVsRetention ?? this.churnVsRetention,
      successfulTransactions: successfulTransactions ?? this.successfulTransactions,
      failedTransactions: failedTransactions ?? this.failedTransactions,
      pendingTransactions: pendingTransactions ?? this.pendingTransactions,
      totalTransactionAmount: totalTransactionAmount ?? this.totalTransactionAmount,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        timeFilter,
        selectedYear,
        selectedMonth,
        totalRevenue,
        revenueByMonth,
        activeSubscribers,
        totalSubscribers,
        churnRate,
        avgRevenuePerUser,
        planDistribution,
        planRevenue,
        newClientsThisMonth,
        churnedClientsThisMonth,
        clientAcquisitionByMonth,
        churnVsRetention,
        successfulTransactions,
        failedTransactions,
        pendingTransactions,
        totalTransactionAmount,
      ];
}

