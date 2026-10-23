import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/presentation/layouts/base_layout_with_cat.dart';
import '../../../core/state/app_state.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final mascot = AppState.instance.selectedMascot;
        final habits = AppState.instance.habits;
        final topHabit = _findTopHabit(habits);

        return BaseLayoutWithCat(
          catAsset: mascot.assetPath,
          catLottieAsset: mascot.lottieAssetPath,
          message: '${mascot.name}: ${AppStrings.tr('cat_stats_great')}',
          catAlignment: Alignment.bottomRight,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 18),
                  _buildTopHabitCard(context, topHabit),
                  const SizedBox(height: 20),
                  _buildHabitsStatsList(context, habits),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Map<String, dynamic>? _findTopHabit(List<Map<String, dynamic>> habits) {
    if (habits.isEmpty) {
      return null;
    }
    Map<String, dynamic> top = habits.first;
    for (final habit in habits) {
      final int count = habit['totalCount'] ?? 0;
      final int topCount = top['totalCount'] ?? 0;
      if (count > topCount) {
        top = habit;
      }
    }
    return top;
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.tr('stats_title'),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.tr('stats_subtitle'),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildTopHabitCard(BuildContext context, Map<String, dynamic>? topHabit) {
    if (topHabit == null) {
      return const SizedBox.shrink();
    }

    final String name = AppStrings.getLocalizedHabitName(topHabit);
    final String emoji = topHabit['emoji'] ?? '🏆';
    final int totalCount = topHabit['totalCount'] ?? 0;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withAlpha(isDark ? 90 : 120), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withAlpha(isDark ? 15 : 25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withAlpha(40),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 32)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      AppStrings.tr('top_habit_badge'),
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.tr('top_habit_completed').replaceAll('{count}', '$totalCount'),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitsStatsList(BuildContext context, List<Map<String, dynamic>> habits) {
    if (habits.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Text(
          AppStrings.tr('no_stats'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppStrings.tr('all_habits_title')} (${habits.length})',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];
            return _buildStatRow(context, habit);
          },
        ),
      ],
    );
  }

  Widget _buildStatRow(BuildContext context, Map<String, dynamic> habit) {
    final String name = AppStrings.getLocalizedHabitName(habit);
    final String emoji = habit['emoji'] ?? '✨';
    final int count = habit['totalCount'] ?? 0;
    final String category = AppStrings.getLocalizedCategory(habit);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF373A47) : const Color(0xFFE4DFD6),
        ),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  category,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.white60 : Colors.black45,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2E38) : const Color(0xFFF1EDE6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count ${AppStrings.tr('times_unit')}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF3A3A3A),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
