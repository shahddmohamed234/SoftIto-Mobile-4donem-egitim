import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Yakılan kaloriye göre hesaplanan dinamik su ihtiyacını gösteren akıllı bilgi kartı.
class WaterCalorieSyncCardWidget extends StatelessWidget {
  final int baseGoalMl;
  final int burnedCalories;
  final int extraWaterMl;
  final int dynamicGoalMl;

  const WaterCalorieSyncCardWidget({
    super.key,
    required this.baseGoalMl,
    required this.burnedCalories,
    required this.extraWaterMl,
    required this.dynamicGoalMl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: burnedCalories > 0
              ? AppColors.neonOrange.withAlpha(120)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 12),
          _buildDetailRow(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.bolt, color: AppColors.neonOrange, size: 22),
        const SizedBox(width: 8),
        Text(
          'Akıllı Hidrasyon Dengesi',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMetric(
          theme: theme,
          title: 'Temel Hedef',
          value: '$baseGoalMl ml',
          color: AppColors.textSecondary,
        ),
        const Text('+', style: TextStyle(color: AppColors.textMuted, fontSize: 18)),
        _buildMetric(
          theme: theme,
          title: 'Yakılan ($burnedCalories kcal)',
          value: '+$extraWaterMl ml',
          color: AppColors.neonOrange,
        ),
        const Text('=', style: TextStyle(color: AppColors.textMuted, fontSize: 18)),
        _buildMetric(
          theme: theme,
          title: 'Yeni Hedef',
          value: '$dynamicGoalMl ml',
          color: AppColors.neonCyan,
        ),
      ],
    );
  }

  Widget _buildMetric({
    required ThemeData theme,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
