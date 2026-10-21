import 'package:flutter/material.dart';
import '../controllers/pomodoro_controller.dart';
import 'package:full_concentrate/features/tasks/presentation/controllers/task_controller.dart';
import '../widgets/timer_display_widget.dart';
import '../widgets/session_control_buttons.dart';
import '../widgets/before_start_info_widget.dart';
import '../widgets/violation_warning_widget.dart';
import '../widgets/break_view_widget.dart';
import '../widgets/duration_picker_dialog.dart';
import 'package:full_concentrate/core/localization/app_strings.dart';
import 'package:full_concentrate/core/theme/app_colors.dart';

/// Ana Pomodoro Sayacı ve Mola Ekranı (Sayfa 1)
class PomodoroScreen extends StatelessWidget {
  final PomodoroController controller;
  final TaskController taskController;
  final VoidCallback onNavigateToTasks;

  const PomodoroScreen({
    super.key,
    required this.controller,
    required this.taskController,
    required this.onNavigateToTasks,
  });

  void _showDurationPicker(BuildContext context) {
    if (controller.status == PomodoroStatus.idle) {
      showDialog(
        context: context,
        builder: (ctx) => DurationPickerDialog(
          currentMinutes: controller.workDurationMinutes,
          onDurationSelected: (minutes) {
            controller.setWorkDuration(minutes);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (controller.status == PomodoroStatus.breaking) {
          final nextTask = controller.nextTask ?? taskController.getNextTask(controller.currentTask);
          return Scaffold(
            appBar: AppBar(title: Text(AppStrings.get('breakSession'))),
            body: BreakViewWidget(
              controller: controller,
              nextTask: nextTask,
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.get('appName')),
            actions: [
              if (controller.status == PomodoroStatus.idle)
                IconButton(
                  icon: const Icon(Icons.tune),
                  tooltip: 'Süreyi Ayarla',
                  onPressed: () => _showDurationPicker(context),
                ),
            ],
          ),
          body: _buildMainBody(context),
        );
      },
    );
  }

  Widget _buildMainBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          _buildActiveTaskCard(context),
          if (controller.isViolationDetected)
            ViolationWarningWidget(
              onDismiss: () => controller.acknowledgeViolation(),
            ),
          if (controller.status == PomodoroStatus.idle)
            const BeforeStartInfoWidget(),
          const SizedBox(height: 20),
          TimerDisplayWidget(
            remainingSeconds: controller.remainingSeconds,
            totalSeconds: controller.workDurationMinutes * 60,
            onTap: controller.status == PomodoroStatus.idle
                ? () => _showDurationPicker(context)
                : null,
          ),
          const SizedBox(height: 12),
          _buildEquationInfo(context),
          const SizedBox(height: 30),
          SessionControlButtons(
            controller: controller,
            taskController: taskController,
            onNavigateToTasks: onNavigateToTasks,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTaskCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isRunning = controller.status != PomodoroStatus.idle;
    // Seans devam ediyorsa kontrolcünün kilitli görevini gösterir
    final currentTask = isRunning
        ? controller.currentTask
        : (controller.currentTask ?? taskController.selectedTask);
    final isCompleted = currentTask?.isCompleted ?? false;

    return Card(
      elevation: isRunning ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isRunning
            ? BorderSide(
                color: isDark ? AppColors.pastelPink : AppColors.burgundy,
                width: 1.5,
              )
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(
          isCompleted
              ? Icons.check_circle_rounded
              : (isRunning ? Icons.play_circle_fill_rounded : Icons.assignment_outlined),
          color: isCompleted
              ? AppColors.roseDust
              : (isRunning
                  ? (isDark ? AppColors.pastelPink : AppColors.burgundy)
                  : AppColors.burgundy),
          size: 30,
        ),
        title: Text(
          isRunning ? AppStrings.get('workSession') : AppStrings.get('activeTask'),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isRunning ? (isDark ? AppColors.pastelPink : AppColors.burgundy) : null,
            fontWeight: isRunning ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          currentTask?.title ?? AppStrings.get('noTaskSelected'),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: isRunning
            ? _buildRunningBadge(context, theme, isDark, isCompleted)
            : OutlinedButton(
                onPressed: onNavigateToTasks,
                child: Text(
                  currentTask != null
                      ? AppStrings.get('changeTask')
                      : AppStrings.get('selectTask'),
                ),
              ),
      ),
    );
  }

  Widget _buildRunningBadge(
      BuildContext context, ThemeData theme, bool isDark, bool isCompleted) {
    if (isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.roseDust.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.roseDust.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_rounded, size: 16, color: AppColors.roseDust),
            const SizedBox(width: 4),
            Text(
              AppStrings.get('completed'),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.roseDust,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.pastelPink : AppColors.burgundy)
            .withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isDark ? AppColors.pastelPink : AppColors.burgundy)
              .withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 15,
            color: isDark ? AppColors.pastelPink : AppColors.burgundy,
          ),
          const SizedBox(width: 4),
          Text(
            AppStrings.get('focusing'),
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.pastelPink : AppColors.burgundy,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquationInfo(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: controller.status == PomodoroStatus.idle
          ? () => _showDurationPicker(context)
          : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Text(
          '${controller.workDurationMinutes} ${AppStrings.get('minutes')} ${AppStrings.get('focusWork')} = ${controller.breakDurationMinutes} ${AppStrings.get('minutes')} ${AppStrings.get('breakWord')} (${AppStrings.get('automaticCalc')})',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.roseDust,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
