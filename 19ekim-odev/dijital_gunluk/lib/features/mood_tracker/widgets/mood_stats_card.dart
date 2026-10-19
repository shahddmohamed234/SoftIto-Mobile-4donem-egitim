import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class MoodStatsCard extends StatelessWidget {
  final Map<String, int> counts;

  const MoodStatsCard({
    super.key,
    required this.counts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = counts.values.fold<int>(0, (sum, val) => sum + val);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Duygu Durum Dağılımı',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$total Kayıt',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatBars(theme, total),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBars(ThemeData theme, int total) {
    final items = [
      {'mood': 'Mutlu', 'color': AppColors.moodHappy},
      {'mood': 'Huzurlu', 'color': AppColors.moodPeaceful},
      {'mood': 'Enerjik', 'color': AppColors.moodEnergetic},
      {'mood': 'Düşünceli', 'color': AppColors.moodThoughtful},
      {'mood': 'Üzgün', 'color': AppColors.moodSad},
      {'mood': 'Yorgun', 'color': AppColors.moodTired},
    ];

    return Column(
      children: items.map((item) {
        final mood = item['mood'] as String;
        final color = item['color'] as Color;
        final count = counts[mood] ?? 0;
        final ratio = total > 0 ? count / total : 0.0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 70,
                child: Text(
                  mood,
                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 24,
                child: Text(
                  '$count',
                  textAlign: TextAlign.end,
                  style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
