import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Hızlı egzersiz şablonlarını sunan modüler widget.
class WorkoutQuickAddWidget extends StatelessWidget {
  final void Function({
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
  }) onAdd;

  const WorkoutQuickAddWidget({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTemplateButton(
                title: 'Koşu',
                minutes: 30,
                calories: 280,
                icon: Icons.directions_run,
                accentColor: AppColors.neonOrange,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTemplateButton(
                title: 'Ağırlık',
                minutes: 45,
                calories: 320,
                icon: Icons.fitness_center,
                accentColor: AppColors.neonLime,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTemplateButton(
                title: 'Bisiklet',
                minutes: 25,
                calories: 200,
                icon: Icons.directions_bike,
                accentColor: AppColors.neonCyan,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTemplateButton(
                title: 'HIIT Kardiyo',
                minutes: 20,
                calories: 240,
                icon: Icons.bolt,
                accentColor: AppColors.neonPurple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTemplateButton({
    required String title,
    required int minutes,
    required int calories,
    required IconData icon,
    required Color accentColor,
  }) {
    return OutlinedButton(
      onPressed: () => onAdd(
        title: title,
        durationMinutes: minutes,
        caloriesBurned: calories,
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: BorderSide(color: accentColor.withAlpha(150), width: 1.2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.surfaceVariant.withAlpha(100),
      ),
      child: Row(
        children: [
          Icon(icon, color: accentColor, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$minutes dk • $calories kcal',
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
