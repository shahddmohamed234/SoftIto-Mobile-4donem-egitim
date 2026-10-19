import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_model.dart';

class WorkoutCard extends StatelessWidget {
  final List<WorkoutItem> workouts;
  final VoidCallback onAddWorkout;
  final ValueChanged<String> onRemoveWorkout;

  const WorkoutCard({
    super.key,
    required this.workouts,
    required this.onAddWorkout,
    required this.onRemoveWorkout,
  });

  @override
  Widget build(BuildContext context) {
    final int totalCalories = workouts.fold(0, (sum, w) => sum + w.burnedCalories);
    final int totalBonusWater = workouts.fold(0, (sum, w) => sum + w.recommendedWaterMl);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, onAddWorkout),
            const SizedBox(height: 14),
            _SummaryStats(totalCalories: totalCalories, totalBonusWater: totalBonusWater),
            if (workouts.isNotEmpty) ...[
              const SizedBox(height: 14),
              _WorkoutList(workouts: workouts, onRemove: onRemoveWorkout),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, VoidCallback onAdd) {
    final titleColor = Theme.of(context).colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final btnBg = isDark ? AppColors.neonLime : const Color(0xFF16A34A);
    final btnFg = isDark ? AppColors.darkBackground : Colors.white;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.fitness_center_rounded, color: btnBg, size: 20),
            const SizedBox(width: 8),
            Text(
              'Egzersiz & Kalori',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: onAdd,
          style: ElevatedButton.styleFrom(
            backgroundColor: btnBg,
            foregroundColor: btnFg,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Antrenman Ekle'),
        ),
      ],
    );
  }
}

class _SummaryStats extends StatelessWidget {
  final int totalCalories;
  final int totalBonusWater;

  const _SummaryStats({required this.totalCalories, required this.totalBonusWater});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final borderColor = isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatColumn(
            label: 'Yakılan Kalori',
            value: '$totalCalories kcal',
            color: AppColors.calorieOrange,
            icon: Icons.local_fire_department_rounded,
          ),
          Container(width: 1, height: 32, color: borderColor),
          _StatColumn(
            label: 'Gereken Ek Su',
            value: '+$totalBonusWater ml',
            color: primaryColor,
            icon: Icons.add_circle_outline_rounded,
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatColumn({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 11, color: labelColor)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _WorkoutList extends StatelessWidget {
  final List<WorkoutItem> workouts;
  final ValueChanged<String> onRemove;

  const _WorkoutList({required this.workouts, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final limeColor = isDark ? AppColors.neonLime : const Color(0xFF16A34A);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final subtextColor = isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
    final mutedColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return Column(
      children: workouts.map((w) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: limeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.flash_on_rounded, color: limeColor, size: 16),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    w.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: textColor,
                    ),
                  ),
                  Text(
                    '${w.durationMinutes} dk • ${w.burnedCalories} kcal',
                    style: TextStyle(fontSize: 11, color: subtextColor),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '+${w.recommendedWaterMl} ml',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: primaryColor,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close_rounded, size: 16, color: mutedColor),
                onPressed: () => onRemove(w.id),
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
