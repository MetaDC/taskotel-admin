import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features2/reports/presentation/widgets/report_cards.dart';
import 'package:taskoteladmin/features2/reports/presentation/widgets/subscription_analytics_chart.dart';
import 'package:taskoteladmin/features2/reports/presentation/widgets/hotel_usage_analytics_chart.dart';
import 'package:taskoteladmin/features2/reports/presentation/widgets/client_analytics_chart.dart';
import 'package:taskoteladmin/features2/reports/presentation/widgets/revenue_breakdown_chart.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  bool _isLoading = true;
  String _selectedTimeRange = '30d';
  String _selectedReportType = 'overview';

  @override
  void initState() {
    super.initState();
    _loadReportsData();
  }

  Future<void> _loadReportsData() async {
    // TODO: Replace with actual repository call
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() {
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
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildFilters(),
          const SizedBox(height: 24),
          if (_isLoading) ...[
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          ] else ...[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ReportCards(
                      timeRange: _selectedTimeRange,
                      reportType: _selectedReportType,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: SubscriptionAnalyticsChart(
                            timeRange: _selectedTimeRange,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: HotelUsageAnalyticsChart(
                            timeRange: _selectedTimeRange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ClientAnalyticsChart(
                            timeRange: _selectedTimeRange,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: RevenueBreakdownChart(
                            timeRange: _selectedTimeRange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildFilters(),
          const SizedBox(height: 16),
          if (_isLoading) ...[
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          ] else ...[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ReportCards(
                      timeRange: _selectedTimeRange,
                      reportType: _selectedReportType,
                    ),
                    const SizedBox(height: 16),
                    SubscriptionAnalyticsChart(
                      timeRange: _selectedTimeRange,
                    ),
                    const SizedBox(height: 16),
                    HotelUsageAnalyticsChart(
                      timeRange: _selectedTimeRange,
                    ),
                    const SizedBox(height: 16),
                    ClientAnalyticsChart(
                      timeRange: _selectedTimeRange,
                    ),
                    const SizedBox(height: 16),
                    RevenueBreakdownChart(
                      timeRange: _selectedTimeRange,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analytics & Reports',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Comprehensive insights into your hotel management platform performance.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _exportReport,
              icon: const Icon(Icons.download, color: Colors.white),
              label: const Text(
                'Export Report',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _scheduleReport,
              icon: const Icon(Icons.schedule, color: Colors.white),
              label: const Text(
                'Schedule Report',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedTimeRange,
              onChanged: (value) {
                setState(() {
                  _selectedTimeRange = value!;
                });
                _loadReportsData();
              },
              decoration: const InputDecoration(
                labelText: 'Time Range',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: '7d', child: Text('Last 7 days')),
                DropdownMenuItem(value: '30d', child: Text('Last 30 days')),
                DropdownMenuItem(value: '90d', child: Text('Last 90 days')),
                DropdownMenuItem(value: '1y', child: Text('Last year')),
                DropdownMenuItem(value: 'all', child: Text('All time')),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedReportType,
              onChanged: (value) {
                setState(() {
                  _selectedReportType = value!;
                });
                _loadReportsData();
              },
              decoration: const InputDecoration(
                labelText: 'Report Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'overview', child: Text('Overview')),
                DropdownMenuItem(value: 'financial', child: Text('Financial')),
                DropdownMenuItem(value: 'usage', child: Text('Usage Analytics')),
                DropdownMenuItem(value: 'clients', child: Text('Client Analytics')),
                DropdownMenuItem(value: 'subscriptions', child: Text('Subscription Analytics')),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _selectedTimeRange = '30d';
                _selectedReportType = 'overview';
              });
              _loadReportsData();
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[100],
              foregroundColor: Colors.grey[700],
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _exportReport() {
    // TODO: Implement report export functionality
    print('Export report');
  }

  void _scheduleReport() {
    // TODO: Implement report scheduling functionality
    print('Schedule report');
  }
}
