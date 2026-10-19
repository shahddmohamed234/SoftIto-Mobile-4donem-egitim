import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/diary_model.dart';

class DiaryCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const DiaryCard({
    super.key,
    required this.entry,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              const SizedBox(height: 8),
              Text(
                entry.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  height: 1.4,
                ),
              ),
              if (entry.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildTagRow(theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMoodBadge(entry.mood),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatDate(entry.createdAt),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete_outline, size: 20, color: theme.colorScheme.error),
          onPressed: onDelete,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  Widget _buildTagRow(ThemeData theme) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: entry.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '#$tag',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMoodBadge(String mood) {
    Color bg = AppColors.moodHappy;
    IconData icon = Icons.sentiment_satisfied_rounded;

    switch (mood) {
      case 'Mutlu':
        bg = AppColors.moodHappy;
        icon = Icons.sentiment_very_satisfied_rounded;
        break;
      case 'Huzurlu':
        bg = AppColors.moodPeaceful;
        icon = Icons.spa_rounded;
        break;
      case 'Enerjik':
        bg = AppColors.moodEnergetic;
        icon = Icons.bolt_rounded;
        break;
      case 'Düşünceli':
        bg = AppColors.moodThoughtful;
        icon = Icons.psychology_rounded;
        break;
      case 'Üzgün':
        bg = AppColors.moodSad;
        icon = Icons.sentiment_dissatisfied_rounded;
        break;
      case 'Yorgun':
        bg = AppColors.moodTired;
        icon = Icons.bedtime_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: bg),
    );
  }

  String _formatDate(DateTime dt) {
    final months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    final minute = dt.minute.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year} • $hour:$minute';
  }
}
