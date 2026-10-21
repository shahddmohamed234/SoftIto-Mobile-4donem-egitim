import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:full_concentrate/features/pomodoro/domain/pomodoro_repository.dart';
import 'package:full_concentrate/features/pomodoro/data/pomodoro_repository_impl.dart';
import 'package:full_concentrate/features/pomodoro/data/models/pomodoro_session_model.dart';
import 'package:full_concentrate/features/analytics/domain/analytics_calculator.dart';
import '../widgets/summary_stat_card.dart';
import '../widgets/analytics_chart_widget.dart';
import 'package:full_concentrate/core/localization/app_strings.dart';
import 'package:full_concentrate/core/theme/app_colors.dart';

/// Gelişmiş Odak Analitiği ve Raporlama Ekranı (Sayfa 3)
class AnalyticsScreen extends StatefulWidget {
  final PomodoroRepository? repository;

  const AnalyticsScreen({super.key, this.repository});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late final PomodoroRepository _repo;
  List<PomodoroSessionModel> _sessions = [];
  bool _isLoading = true;
  int _selectedTabIndex = 0; // 0: Günlük, 1: Haftalık, 2: Aylık
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _repo = widget.repository ?? PomodoroRepositoryImpl();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final list = await _repo.getSessions();
    setState(() {
      _sessions = list;
      _isLoading = false;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('analyticsTab')),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            tooltip: AppStrings.get('taskDate'),
            onPressed: _pickDate,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTabRow(),
                  const SizedBox(height: 14),
                  _buildStatsGrid(),
                  const SizedBox(height: 14),
                  _buildInsightCard(),
                  const SizedBox(height: 14),
                  _buildChartSection(),
                  const SizedBox(height: 16),
                  _buildHistoryHeader(),
                  _buildHistoryList(),
                ],
              ),
            ),
    );
  }

  Widget _buildTabRow() {
    return Row(
      children: [
        _buildTabButton(0, AppStrings.get('daily')),
        const SizedBox(width: 8),
        _buildTabButton(1, AppStrings.get('weekly')),
        const SizedBox(width: 8),
        _buildTabButton(2, AppStrings.get('monthly')),
      ],
    );
  }

  Widget _buildTabButton(int index, String label) {
    final bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.burgundy : AppColors.lightPowder,
          foregroundColor: isSelected ? AppColors.white : AppColors.darkAnthracite,
          elevation: isSelected ? 2 : 0,
        ),
        onPressed: () => setState(() => _selectedTabIndex = index),
        child: Text(label),
      ),
    );
  }

  Widget _buildStatsGrid() {
    final filtered = AnalyticsCalculator.filterSessions(_sessions, _selectedTabIndex, _selectedDate);
    final totalMinutes = AnalyticsCalculator.calculateTotalWorkMinutes(filtered);
    final totalViolations = AnalyticsCalculator.calculateTotalViolations(filtered);
    final avgMinutes = AnalyticsCalculator.calculateAverageWorkMinutes(filtered);
    final successRate = AnalyticsCalculator.calculateSuccessRate(filtered);
    final totalBreak = AnalyticsCalculator.calculateTotalBreakMinutes(filtered);

    return Column(
      children: [
        Row(
          children: [
            SummaryStatCard(
              title: AppStrings.get('totalFocusTime'),
              value: AnalyticsCalculator.formatMinutes(totalMinutes),
              icon: Icons.timer,
              iconColor: AppColors.burgundy,
            ),
            SummaryStatCard(
              title: AppStrings.get('completedSessions'),
              value: '${filtered.length}',
              icon: Icons.check_circle_outline,
              iconColor: AppColors.roseDust,
            ),
            SummaryStatCard(
              title: AppStrings.get('violationsCount'),
              value: '$totalViolations',
              icon: Icons.error_outline,
              iconColor: AppColors.violationRed,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            SummaryStatCard(
              title: AppStrings.get('averageSession'),
              value: '$avgMinutes ${AppStrings.get('minutes')}',
              icon: Icons.trending_up,
              iconColor: Colors.teal,
            ),
            SummaryStatCard(
              title: AppStrings.get('successRate'),
              value: '%$successRate',
              icon: Icons.pie_chart_outline,
              iconColor: Colors.deepOrange,
            ),
            SummaryStatCard(
              title: AppStrings.get('totalBreak'),
              value: '$totalBreak ${AppStrings.get('minutes')}',
              icon: Icons.coffee_outlined,
              iconColor: AppColors.roseDust,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInsightCard() {
    final filtered = AnalyticsCalculator.filterSessions(_sessions, _selectedTabIndex, _selectedDate);
    final insight = AnalyticsCalculator.getInsightMessage(filtered);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.pastelPink.withValues(alpha: 0.3) : AppColors.subtleDivider,
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.roseDust, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.get('productivityInsight'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDark ? AppColors.pastelPink : AppColors.burgundy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: isDark ? AppColors.white : AppColors.darkAnthracite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    Map<int, double> dataMap;
    List<String> titles;

    if (_selectedTabIndex == 0) {
      dataMap = AnalyticsCalculator.getDailyHourlyDistribution(_sessions);
      titles = const ['00-04', '04-08', '08-12', '12-16', '16-20', '20-24'];
    } else if (_selectedTabIndex == 1) {
      dataMap = AnalyticsCalculator.getWeeklyDistribution(_sessions);
      titles = AnalyticsCalculator.getWeeklyTitles();
    } else {
      dataMap = AnalyticsCalculator.getMonthlyWeeklyDistribution(_sessions);
      titles = AnalyticsCalculator.getMonthlyTitles();
    }

    return AnalyticsChartWidget(dataMap: dataMap, titles: titles);
  }

  Widget _buildHistoryHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        AppStrings.get('sessionHistory'),
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildHistoryList() {
    if (_sessions.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(child: Text(AppStrings.get('noSessionsYet'))),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _sessions.length > 5 ? 5 : _sessions.length,
      itemBuilder: (context, index) {
        final session = _sessions[index];
        final dt = DateTime.tryParse(session.timestamp) ?? DateTime.now();
        final formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(dt);

        return Card(
          child: ListTile(
            leading: Icon(
              session.wasViolated ? Icons.warning_rounded : Icons.verified_rounded,
              color: session.wasViolated ? AppColors.violationRed : AppColors.burgundy,
              size: 28,
            ),
            title: Text(
              '${session.workDuration} ${AppStrings.get('minutes')} ${AppStrings.get('focusWork')}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '$formattedDate  •  ${session.breakDuration} ${AppStrings.get('minutes')} ${AppStrings.get('breakWord')}',
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.pastelPink.withValues(alpha: 0.15)
                    : AppColors.burgundy.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? AppColors.pastelPink : AppColors.burgundy,
                  width: 1,
                ),
              ),
              child: Text(
                '🎯 ${session.workDuration} ${AppStrings.get('minutes')}',
                style: TextStyle(
                  color: isDark ? AppColors.pastelPink : AppColors.burgundy,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
