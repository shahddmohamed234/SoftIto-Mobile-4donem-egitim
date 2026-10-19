import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class QuickAddBar extends StatelessWidget {
  final ValueChanged<int> onAddWater;

  const QuickAddBar({
    super.key,
    required this.onAddWater,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Hızlı Su Ekle',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _QuickAddButton(
              amount: 200,
              label: 'Bardak',
              icon: Icons.local_drink_rounded,
              onTap: () => onAddWater(200),
            ),
            const SizedBox(width: 8),
            _QuickAddButton(
              amount: 330,
              label: 'Şişe',
              icon: Icons.water_drop_outlined,
              onTap: () => onAddWater(330),
            ),
            const SizedBox(width: 8),
            _QuickAddButton(
              amount: 500,
              label: 'Matara',
              icon: Icons.sports_gymnastics,
              onTap: () => onAddWater(500),
            ),
            const SizedBox(width: 8),
            _QuickAddButton(
              amount: 750,
              label: 'Shaker',
              icon: Icons.fitness_center_rounded,
              onTap: () => onAddWater(750),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final int amount;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.amount,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final borderColor = isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final subtextColor = isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: primaryColor, size: 22),
              const SizedBox(height: 6),
              Text(
                '+$amount',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: subtextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
