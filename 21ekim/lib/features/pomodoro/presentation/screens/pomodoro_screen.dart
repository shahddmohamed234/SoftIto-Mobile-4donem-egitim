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
          return Scaffold(
            appBar: AppBar(title: Text(AppStrings.get('breakSession'))),
            body: BreakViewWidget(controller: controller),
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
          SessionControlButtons(controller: controller),
        ],
      ),
    );
  }

  Widget _buildActiveTaskCard(BuildContext context) {
    final theme = Theme.of(context);
    final currentTask = controller.currentTask ?? taskController.selectedTask;

    return Card(
      child: ListTile(
        leading: const Icon(Icons.assignment_outlined, color: AppColors.burgundy),
        title: Text(AppStrings.get('activeTask'), style: theme.textTheme.bodyMedium),
        subtitle: Text(
          currentTask?.title ?? AppStrings.get('noTaskSelected'),
          style: theme.textTheme.titleMedium,
        ),
        trailing: OutlinedButton(
          onPressed: onNavigateToTasks,
          child: Text(AppStrings.get('selectTask')),
        ),
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
