import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';

class SubscriptionAnalyticsChart extends StatelessWidget {
  final String timeRange;

  const SubscriptionAnalyticsChart({
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
                'Subscription Analytics',
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
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 10,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[300]!,
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey[300]!,
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
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            _getBottomTitle(value.toInt()),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        );
                      },
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey[300]!),
                ),
                minX: 0,
                maxX: _getMaxX(),
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  // New Subscriptions Line
                  LineChartBarData(
                    spots: _getNewSubscriptionsData(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.8),
                        Colors.blue,
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withOpacity(0.3),
                          Colors.blue.withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Cancelled Subscriptions Line
                  LineChartBarData(
                    spots: _getCancelledSubscriptionsData(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.red.withOpacity(0.8),
                        Colors.red,
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.withOpacity(0.3),
                          Colors.red.withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('New Subscriptions', Colors.blue),
              const SizedBox(width: 24),
              _buildLegendItem('Cancelled Subscriptions', Colors.red),
            ],
          ),
        ],
      ),
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
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
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

  double _getMaxX() {
    switch (timeRange) {
      case '7d':
        return 6;
      case '30d':
        return 29;
      case '90d':
        return 11; // 12 weeks
      case '1y':
        return 11; // 12 months
      default:
        return 11;
    }
  }

  String _getBottomTitle(int value) {
    switch (timeRange) {
      case '7d':
        final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return value < days.length ? days[value] : '';
      case '30d':
        return value % 5 == 0 ? '${value + 1}' : '';
      case '90d':
        return 'W${value + 1}';
      case '1y':
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        return value < months.length ? months[value] : '';
      default:
        return value.toString();
    }
  }

  List<FlSpot> _getNewSubscriptionsData() {
    switch (timeRange) {
      case '7d':
        return [
          const FlSpot(0, 12),
          const FlSpot(1, 18),
          const FlSpot(2, 15),
          const FlSpot(3, 22),
          const FlSpot(4, 28),
          const FlSpot(5, 25),
          const FlSpot(6, 32),
        ];
      case '30d':
        return List.generate(30, (index) {
          return FlSpot(index.toDouble(), 15 + (index % 7) * 5 + (index / 10).floor() * 3);
        });
      case '90d':
        return List.generate(12, (index) {
          return FlSpot(index.toDouble(), 45 + (index % 4) * 15 + (index / 3).floor() * 8);
        });
      case '1y':
        return [
          const FlSpot(0, 45),
          const FlSpot(1, 52),
          const FlSpot(2, 48),
          const FlSpot(3, 65),
          const FlSpot(4, 72),
          const FlSpot(5, 68),
          const FlSpot(6, 78),
          const FlSpot(7, 85),
          const FlSpot(8, 82),
          const FlSpot(9, 88),
          const FlSpot(10, 92),
          const FlSpot(11, 95),
        ];
      default:
        return [
          const FlSpot(0, 30),
          const FlSpot(1, 45),
          const FlSpot(2, 52),
          const FlSpot(3, 68),
          const FlSpot(4, 75),
          const FlSpot(5, 82),
          const FlSpot(6, 88),
          const FlSpot(7, 92),
          const FlSpot(8, 95),
          const FlSpot(9, 98),
          const FlSpot(10, 100),
          const FlSpot(11, 102),
        ];
    }
  }

  List<FlSpot> _getCancelledSubscriptionsData() {
    switch (timeRange) {
      case '7d':
        return [
          const FlSpot(0, 3),
          const FlSpot(1, 2),
          const FlSpot(2, 4),
          const FlSpot(3, 1),
          const FlSpot(4, 3),
          const FlSpot(5, 2),
          const FlSpot(6, 1),
        ];
      case '30d':
        return List.generate(30, (index) {
          return FlSpot(index.toDouble(), 2 + (index % 5) * 1.5);
        });
      case '90d':
        return List.generate(12, (index) {
          return FlSpot(index.toDouble(), 8 + (index % 3) * 3);
        });
      case '1y':
        return [
          const FlSpot(0, 8),
          const FlSpot(1, 12),
          const FlSpot(2, 10),
          const FlSpot(3, 15),
          const FlSpot(4, 18),
          const FlSpot(5, 16),
          const FlSpot(6, 20),
          const FlSpot(7, 22),
          const FlSpot(8, 19),
          const FlSpot(9, 24),
          const FlSpot(10, 26),
          const FlSpot(11, 28),
        ];
      default:
        return [
          const FlSpot(0, 5),
          const FlSpot(1, 8),
          const FlSpot(2, 12),
          const FlSpot(3, 15),
          const FlSpot(4, 18),
          const FlSpot(5, 22),
          const FlSpot(6, 25),
          const FlSpot(7, 28),
          const FlSpot(8, 30),
          const FlSpot(9, 32),
          const FlSpot(10, 35),
          const FlSpot(11, 38),
        ];
    }
  }
}
