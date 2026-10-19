import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/mood_entry_model.dart';

class MoodCard extends StatelessWidget {
  final MoodEntry entry;
  final VoidCallback onDelete;

  const MoodCard({
    super.key,
    required this.entry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final moodInfo = _getMoodInfo(entry.mood);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: moodInfo.color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(moodInfo.icon, color: moodInfo.color, size: 24),
        ),
        title: Row(
          children: [
            Text(
              entry.mood,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Text(
              _formatTime(entry.timestamp),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
        subtitle: entry.note.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  entry.note,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              )
            : null,
        trailing: IconButton(
          icon: Icon(Icons.close_rounded, size: 18, color: theme.colorScheme.error),
          onPressed: onDelete,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }

  ({Color color, IconData icon}) _getMoodInfo(String mood) {
    switch (mood) {
      case 'Mutlu':
        return (color: AppColors.moodHappy, icon: Icons.sentiment_very_satisfied_rounded);
      case 'Huzurlu':
        return (color: AppColors.moodPeaceful, icon: Icons.spa_rounded);
      case 'Enerjik':
        return (color: AppColors.moodEnergetic, icon: Icons.bolt_rounded);
      case 'Düşünceli':
        return (color: AppColors.moodThoughtful, icon: Icons.psychology_rounded);
      case 'Üzgün':
        return (color: AppColors.moodSad, icon: Icons.sentiment_dissatisfied_rounded);
      case 'Yorgun':
        return (color: AppColors.moodTired, icon: Icons.bedtime_rounded);
      default:
        return (color: AppColors.moodHappy, icon: Icons.sentiment_satisfied_rounded);
    }
  }

  String _formatTime(DateTime dt) {
    final minute = dt.minute.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    return '${dt.day}/${dt.month} $hour:$minute';
  }
}
