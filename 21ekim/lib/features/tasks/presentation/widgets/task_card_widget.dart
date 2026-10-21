import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';
import '../../../../core/theme/app_colors.dart';

/// Görev listesinde her bir görevi gösteren kart bileşeni
/// 
/// Kırmızı çizgi kuralı: 40 satırı geçmeyen modüler build metodu.
class TaskCardWidget extends StatelessWidget {
  final TaskModel task;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;

  const TaskCardWidget({
    super.key,
    required this.task,
    required this.isSelected,
    required this.onSelect,
    required this.onToggleComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSelected
            ? BorderSide(color: isDark ? AppColors.pastelPink : AppColors.burgundy, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildLeadingCheckbox(isDark),
        title: _buildTitle(theme),
        subtitle: _buildSubtitle(theme),
        trailing: _buildTrailingActions(isDark),
        onTap: onSelect,
      ),
    );
  }

  Widget _buildLeadingCheckbox(bool isDark) {
    return IconButton(
      icon: Icon(
        task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
        color: task.isCompleted
            ? AppColors.roseDust
            : (isDark ? AppColors.pastelPink : AppColors.burgundy),
      ),
      onPressed: onToggleComplete,
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      task.title,
      style: theme.textTheme.titleMedium?.copyWith(
        decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
      ),
    );
  }

  Widget _buildSubtitle(ThemeData theme) {
    return Row(
      children: [
        const Icon(Icons.calendar_today, size: 14, color: AppColors.roseDust),
        const SizedBox(width: 4),
        Text(task.date, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildTrailingActions(bool isDark) {
    return IconButton(
      icon: const Icon(Icons.delete_outline, color: AppColors.violationRed),
      onPressed: onDelete,
    );
  }
}
