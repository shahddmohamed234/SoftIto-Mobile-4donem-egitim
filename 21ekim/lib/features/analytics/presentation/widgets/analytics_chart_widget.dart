import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:full_concentrate/core/theme/app_colors.dart';

/// fl_chart kütüphanesini kullanarak odaklanma sürelerini sütun grafik olarak çizen bileşen
class AnalyticsChartWidget extends StatelessWidget {
  final Map<int, double> dataMap;
  final List<String> titles;

  const AnalyticsChartWidget({
    super.key,
    required this.dataMap,
    required this.titles,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 220,
          child: BarChart(_buildBarChartData(context, isDark)),
        ),
      ),
    );
  }

  BarChartData _buildBarChartData(BuildContext context, bool isDark) {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: _calculateMaxY(),
      barTouchData: BarTouchData(enabled: true),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (val, meta) => _getBottomTitleWidget(val, meta, isDark),
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: _buildBarGroups(),
    );
  }

  double _calculateMaxY() {
    double max = 30.0;
    dataMap.forEach((_, val) {
      if (val > max) {
        max = val + 15;
      }
    });
    return max;
  }

  List<BarChartGroupData> _buildBarGroups() {
    return dataMap.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: AppColors.roseDust,
            width: 18,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ],
      );
    }).toList();
  }

  Widget _getBottomTitleWidget(double value, TitleMeta meta, bool isDark) {
    final int index = value.toInt();
    if (index >= 0 && index < titles.length) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          titles[index],
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.white : AppColors.darkAnthracite,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
