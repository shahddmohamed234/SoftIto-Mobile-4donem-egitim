import 'package:flutter/material.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../tasks/data/models/task_model.dart';
import '../controllers/pomodoro_controller.dart';
import 'timer_display_widget.dart';

/// Mola ekranı özel arayüzü (Yumuşak Pembe rahatlatıcı tema)
class BreakViewWidget extends StatelessWidget {
  final PomodoroController controller;
  final TaskModel? nextTask;

  const BreakViewWidget({
    super.key,
    required this.controller,
    this.nextTask,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.darkPlum : AppColors.softPink.withValues(alpha: 0.35),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBreakHeader(theme),
          const SizedBox(height: 24),
          TimerDisplayWidget(
            remainingSeconds: controller.remainingSeconds,
            totalSeconds: controller.breakDurationMinutes * 60,
            isBreak: true,
          ),
          const SizedBox(height: 24),
          _buildNextTaskCard(theme),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.fast_forward_rounded),
            label: Text(AppStrings.get('earlyFinish')),
            onPressed: () => controller.finishBreakEarly(),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakHeader(ThemeData theme) {
    return Column(
      children: [
        const Icon(Icons.coffee_rounded, size: 48, color: AppColors.roseDust),
        const SizedBox(height: 8),
        Text(AppStrings.get('breakSession'), style: theme.textTheme.displayMedium),
      ],
    );
  }

  Widget _buildNextTaskCard(ThemeData theme) {
    final next = nextTask ?? controller.nextTask;
    final String title = next != null
        ? next.title
        : AppStrings.get('noMoreTasks');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              next != null ? Icons.next_plan_outlined : Icons.task_alt_rounded,
              color: AppColors.burgundy,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.get('nextTask'), style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: next == null ? AppColors.roseDust : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
