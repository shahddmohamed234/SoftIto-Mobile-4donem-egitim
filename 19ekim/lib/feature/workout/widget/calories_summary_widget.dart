import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Egzersiz ve yakılan kalori özetini neon kart yapısıyla sunan widget.
class CaloriesSummaryWidget extends StatelessWidget {
  final int totalCalories;
  final int goalCalories;
  final int totalMinutes;
  final double ratio;

  const CaloriesSummaryWidget({
    super.key,
    required this.totalCalories,
    required this.goalCalories,
    required this.totalMinutes,
    required this.ratio,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildStatRow(context),
            const SizedBox(height: 16),
            _buildLinearIndicator(),
            if (totalCalories > 0) ...[
              const SizedBox(height: 14),
              _buildHydrationTip(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          context: context,
          icon: Icons.local_fire_department,
          iconColor: AppColors.neonOrange,
          title: '$totalCalories / $goalCalories',
          subtitle: 'Yakılan Kalori (kcal)',
        ),
        Container(width: 1, height: 40, color: AppColors.border),
        _buildStatItem(
          context: context,
          icon: Icons.timer,
          iconColor: AppColors.neonLime,
          title: '$totalMinutes dk',
          subtitle: 'Toplam Egzersiz',
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 6),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildLinearIndicator() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: ratio.clamp(0.0, 1.0),
        minHeight: 10,
        backgroundColor: AppColors.surfaceVariant,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonLime),
      ),
    );
  }

  Widget _buildHydrationTip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.neonCyan.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neonCyan.withAlpha(70)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.water_drop, color: AppColors.neonCyan, size: 16),
          const SizedBox(width: 6),
          Text(
            'Telafi için: +$totalCalories ml ek su hedefinize eklendi',
            style: const TextStyle(
              color: AppColors.neonCyan,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
