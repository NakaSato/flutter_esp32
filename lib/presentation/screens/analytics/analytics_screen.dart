import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/neumorphic_widgets.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Week';
  final List<String> _periods = ['Day', 'Week', 'Month', 'Year'];

  // Sample data for charts
  final List<Map<String, dynamic>> _powerData = [];
  final List<Map<String, dynamic>> _temperatureData = [];
  final List<Map<String, dynamic>> _humidityData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Generate sample data
    _generateSampleData();
  }

  void _generateSampleData() {
    final random = Random();

    // Power usage data (kWh)
    for (int i = 0; i < 24; i++) {
      _powerData.add({
        'time': i,
        'value': 0.5 + random.nextDouble() * 1.5, // Between 0.5 and 2.0 kWh
      });
    }

    // Temperature data (°C)
    for (int i = 0; i < 24; i++) {
      _temperatureData.add({
        'time': i,
        'value': 19 + random.nextDouble() * 5, // Between 19 and 24 °C
      });
    }

    // Humidity data (%)
    for (int i = 0; i < 24; i++) {
      _humidityData.add({
        'time': i,
        'value': 40 + random.nextDouble() * 20, // Between 40% and 60%
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          labelColor:
              isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
          unselectedLabelColor:
              isDarkMode
                  ? AppTheme.darkTextSecondary
                  : AppTheme.lightTextSecondary,
          tabs: [
            Tab(text: 'Power'),
            Tab(text: 'Temperature'),
            Tab(text: 'Humidity'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDarkMode
                    ? [AppTheme.darkBackground, Color(0xFF1A1A1A)]
                    : [AppTheme.lightBackground, Color(0xFFEAEAEA)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing_md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time period selector
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.spacing_md,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Period: ',
                      style: TextStyle(
                        color:
                            isDarkMode
                                ? AppTheme.darkTextSecondary
                                : AppTheme.lightTextSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    NeumorphicContainer(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedPeriod,
                          isDense: true,
                          dropdownColor:
                              isDarkMode
                                  ? AppTheme.darkCardColor
                                  : AppTheme.lightCardColor,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color:
                                isDarkMode
                                    ? AppTheme.darkTextSecondary
                                    : AppTheme.lightTextSecondary,
                          ),
                          items:
                              _periods.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color:
                                          isDarkMode
                                              ? AppTheme.darkTextPrimary
                                              : AppTheme.lightTextPrimary,
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedPeriod = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Chart area
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Power usage chart
                    _buildChartView(
                      chartData: _powerData,
                      title: 'Power Usage',
                      unit: 'kWh',
                      color: theme.colorScheme.primary,
                      stats: [
                        {
                          'title': 'Today',
                          'value': '21.5 kWh',
                          'change': '+2.3%',
                          'isUp': true,
                        },
                        {
                          'title': 'This Week',
                          'value': '147.8 kWh',
                          'change': '-4.1%',
                          'isUp': false,
                        },
                        {
                          'title': 'Average',
                          'value': '19.8 kWh',
                          'change': '',
                          'isUp': null,
                        },
                      ],
                    ),

                    // Temperature chart
                    _buildChartView(
                      chartData: _temperatureData,
                      title: 'Temperature',
                      unit: '°C',
                      color: Colors.orange,
                      stats: [
                        {
                          'title': 'Now',
                          'value': '22.5 °C',
                          'change': '+0.5°',
                          'isUp': true,
                        },
                        {
                          'title': 'Today Avg',
                          'value': '21.2 °C',
                          'change': '-1.1°',
                          'isUp': false,
                        },
                        {
                          'title': 'Optimal',
                          'value': '21.0 °C',
                          'change': '',
                          'isUp': null,
                        },
                      ],
                    ),

                    // Humidity chart
                    _buildChartView(
                      chartData: _humidityData,
                      title: 'Humidity',
                      unit: '%',
                      color: Colors.blue,
                      stats: [
                        {
                          'title': 'Now',
                          'value': '45%',
                          'change': '-2%',
                          'isUp': false,
                        },
                        {
                          'title': 'Today Avg',
                          'value': '48%',
                          'change': '+3%',
                          'isUp': true,
                        },
                        {
                          'title': 'Optimal',
                          'value': '45%',
                          'change': '',
                          'isUp': null,
                        },
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartView({
    required List<Map<String, dynamic>> chartData,
    required String title,
    required String unit,
    required Color color,
    required List<Map<String, dynamic>> stats,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color:
                  isDarkMode
                      ? AppTheme.darkTextPrimary
                      : AppTheme.lightTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: AppTheme.spacing_md),

          // Stats summary
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  stats.map((stat) => _buildStatBox(stat, color)).toList(),
            ),
          ),

          const SizedBox(height: AppTheme.spacing_lg),

          // Chart
          NeumorphicContainer(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing_md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title Over Time',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode
                              ? AppTheme.darkTextPrimary
                              : AppTheme.lightTextPrimary,
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacing_sm),

                  Expanded(child: _buildChart(chartData, color, unit)),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacing_lg),

          // Savings tips
          NeumorphicContainer(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing_md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.tips_and_updates, color: color),
                      const SizedBox(width: 8),
                      Text(
                        'Optimization Tips',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              isDarkMode
                                  ? AppTheme.darkTextPrimary
                                  : AppTheme.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacing_md),

                  _buildTipItem(
                    icon: Icons.access_time,
                    tip:
                        'Schedule usage during off-peak hours to reduce costs.',
                    color: color,
                  ),

                  const SizedBox(height: AppTheme.spacing_sm),

                  _buildTipItem(
                    icon: Icons.autorenew,
                    tip:
                        'Set up automations to optimize ${title.toLowerCase()} usage when you\'re away.',
                    color: color,
                  ),

                  const SizedBox(height: AppTheme.spacing_sm),

                  _buildTipItem(
                    icon: Icons.compare_arrows,
                    tip:
                        'Your ${title.toLowerCase()} is ${_generateComparisonText(title)}',
                    color: color,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(Map<String, dynamic> stat, Color color) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return NeumorphicContainer(
      width: MediaQuery.of(context).size.width / 3.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stat['title'],
            style: TextStyle(
              fontSize: 12,
              color:
                  isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat['value'],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color:
                  isDarkMode
                      ? AppTheme.darkTextPrimary
                      : AppTheme.lightTextPrimary,
            ),
          ),
          if (stat['change'] != null && stat['change'].toString().isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  stat['isUp'] ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                  color: stat['isUp'] ? Colors.red : Colors.green,
                ),
                Text(
                  stat['change'],
                  style: TextStyle(
                    fontSize: 12,
                    color: stat['isUp'] ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildChart(
    List<Map<String, dynamic>> data,
    Color color,
    String unit,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final double maxValue =
        data.map((point) => point['value'] as double).reduce(max) * 1.2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height =
            constraints.maxHeight - 30; // Leave space for labels
        final double barWidth = width / data.length * 0.6;

        return Column(
          children: [
            Expanded(
              child: CustomPaint(
                size: Size(width, height),
                painter: _ChartPainter(
                  data: data,
                  color: color,
                  maxValue: maxValue,
                  barWidth: barWidth,
                  isDarkMode: isDarkMode,
                ),
              ),
            ),

            SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '0:00',
                    style: TextStyle(
                      fontSize: 10,
                      color:
                          isDarkMode
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary,
                    ),
                  ),
                  Text(
                    '12:00',
                    style: TextStyle(
                      fontSize: 10,
                      color:
                          isDarkMode
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary,
                    ),
                  ),
                  Text(
                    '23:00',
                    style: TextStyle(
                      fontSize: 10,
                      color:
                          isDarkMode
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTipItem({
    required IconData icon,
    required String tip,
    required Color color,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color.withOpacity(0.7)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            tip,
            style: TextStyle(
              color:
                  isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.lightTextSecondary,
            ),
          ),
        ),
      ],
    );
  }

  String _generateComparisonText(String metric) {
    switch (metric) {
      case 'Power Usage':
        return '15% higher than similar homes in your area.';
      case 'Temperature':
        return 'within the optimal range for energy efficiency.';
      case 'Humidity':
        return 'at an ideal level for comfort and health.';
      default:
        return 'comparable to average metrics in your area.';
    }
  }
}

class _ChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final Color color;
  final double maxValue;
  final double barWidth;
  final bool isDarkMode;

  _ChartPainter({
    required this.data,
    required this.color,
    required this.maxValue,
    required this.barWidth,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint =
        Paint()
          ..color = color.withOpacity(0.8)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final Paint barPaint =
        Paint()
          ..color = color.withOpacity(0.2)
          ..style = PaintingStyle.fill;

    final Paint gridPaint =
        Paint()
          ..color = (isDarkMode ? Colors.white : Colors.black).withOpacity(0.1)
          ..strokeWidth = 1;

    // Draw horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final double y = size.height - (size.height / 4 * i);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Create path for the line chart
    final Path linePath = Path();
    bool isFirstPoint = true;

    // Draw bars and line
    for (int i = 0; i < data.length; i++) {
      final double x = (i / (data.length - 1)) * size.width;
      final double normalizedValue = (data[i]['value'] as double) / maxValue;
      final double y = size.height - (normalizedValue * size.height);

      // Draw bar
      final Rect barRect = Rect.fromLTWH(
        x - barWidth / 2,
        y,
        barWidth,
        size.height - y,
      );
      canvas.drawRect(barRect, barPaint);

      // Add point to line path
      if (isFirstPoint) {
        linePath.moveTo(x, y);
        isFirstPoint = false;
      } else {
        linePath.lineTo(x, y);
      }
    }

    // Draw the line
    canvas.drawPath(linePath, linePaint);

    // Draw points at data positions
    final Paint pointPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      final double x = (i / (data.length - 1)) * size.width;
      final double normalizedValue = (data[i]['value'] as double) / maxValue;
      final double y = size.height - (normalizedValue * size.height);

      canvas.drawCircle(Offset(x, y), 3, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
