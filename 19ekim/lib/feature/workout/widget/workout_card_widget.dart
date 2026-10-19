import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_model.dart';

/// Egzersiz seansını listeleyen kart widget'ı.
class WorkoutCardWidget extends StatelessWidget {
  final WorkoutModel workout;
  final VoidCallback onDelete;

  const WorkoutCardWidget({
    super.key,
    required this.workout,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
          child: Icon(Icons.fitness_center, color: AppColors.neonLime, size: 20),
        ),
        title: Text(
          workout.title,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(
          '${workout.durationMinutes} dk  •  ${workout.caloriesBurned} kcal  •  ${workout.formattedTime}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.textMuted),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
