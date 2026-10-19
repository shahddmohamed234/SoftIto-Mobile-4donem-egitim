import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/water_intake_model.dart';

/// Günlük su tüketim geçmişini listeleyen modüler widget.
class WaterHistoryListWidget extends StatelessWidget {
  final List<WaterIntakeModel> intakes;
  final void Function(String id) onDelete;

  const WaterHistoryListWidget({
    super.key,
    required this.intakes,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (intakes.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: intakes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = intakes[index];
        return _buildHistoryItem(context, item);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Text(
        'Bugün henüz su tüketimi kaydedilmedi.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, WaterIntakeModel item) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.surfaceVariant,
          child: Icon(Icons.water_drop, color: AppColors.neonCyan, size: 20),
        ),
        title: Text(
          '${item.amountMl} ml (${item.label})',
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(
          item.formattedTime,
          style: theme.textTheme.bodySmall,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.textMuted),
          onPressed: () => onDelete(item.id),
        ),
      ),
    );
  }
}
