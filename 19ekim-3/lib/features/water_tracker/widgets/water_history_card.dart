import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/water_tracker_model.dart';

class WaterHistoryCard extends StatelessWidget {
  final List<WaterLogEntry> history;
  final ValueChanged<String> onDeleteEntry;

  const WaterHistoryCard({
    super.key,
    required this.history,
    required this.onDeleteEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            history.isEmpty
                ? const _EmptyState()
                : _HistoryList(history: history, onDelete: onDeleteEntry),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final titleColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Bugünün Su Günlüğü',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
        Text(
          '${history.length} Kayıt',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
}

class _HistoryList extends StatelessWidget {
  final List<WaterLogEntry> history;
  final ValueChanged<String> onDelete;

  const _HistoryList({required this.history, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final mutedColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    final displayList = history.take(5).toList();

    return Column(
      children: displayList.map((entry) {
        final timeStr =
            '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}';

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.water_drop_rounded,
                  color: primaryColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '+${entry.amountMl} ml',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Text(
                timeStr,
                style: TextStyle(
                  fontSize: 12,
                  color: mutedColor,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close_rounded, size: 16, color: mutedColor),
                onPressed: () => onDelete(entry.id),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          'Henüz su kaydı yok. İlk bardağını iç ve ekle! 💧',
          style: TextStyle(fontSize: 13, color: mutedColor),
        ),
      ),
    );
  }
}
