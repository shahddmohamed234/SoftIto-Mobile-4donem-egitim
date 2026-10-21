import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';
import 'task_card_widget.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

/// Belirli bir tarihteki görevleri bir klasör (folder) altında toplayıp listeleyen bileşen
class TaskDateFolderWidget extends StatelessWidget {
  final String date;
  final List<TaskModel> tasks;
  final TaskModel? selectedTask;
  final ValueChanged<TaskModel> onSelect;
  final ValueChanged<TaskModel> onToggleComplete;
  final ValueChanged<String> onDelete;

  const TaskDateFolderWidget({
    super.key,
    required this.date,
    required this.tasks,
    required this.selectedTask,
    required this.onSelect,
    required this.onToggleComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final int completedCount = tasks.where((t) => t.isCompleted).length;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark
              ? AppColors.pastelPink.withValues(alpha: 0.3)
              : AppColors.subtleDivider,
          width: 1.2,
        ),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          leading: Icon(
            Icons.folder_rounded,
            color: isDark ? AppColors.pastelPink : AppColors.burgundy,
            size: 30,
          ),
          title: Text(
            date,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${tasks.length} ${AppStrings.get('tasksCount')} • $completedCount ${AppStrings.get('completed')}',
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.roseDust),
          ),
          children: _buildTaskCards(),
        ),
      ),
    );
  }

  List<Widget> _buildTaskCards() {
    return tasks.map((task) {
      final isSelected = selectedTask?.id == task.id;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: TaskCardWidget(
          task: task,
          isSelected: isSelected,
          onSelect: () => onSelect(task),
          onToggleComplete: () => onToggleComplete(task),
          onDelete: () => onDelete(task.id),
        ),
      );
    }).toList();
  }
}
