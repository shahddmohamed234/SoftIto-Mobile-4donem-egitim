import 'package:flutter/material.dart';
import '../controllers/pomodoro_controller.dart';
import '../../../tasks/presentation/controllers/task_controller.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

/// Seans kontrol butonları (Başlat, Duraklat, Devam Et, Bitir)
class SessionControlButtons extends StatelessWidget {
  final PomodoroController controller;
  final TaskController? taskController;
  final VoidCallback? onNavigateToTasks;

  const SessionControlButtons({
    super.key,
    required this.controller,
    this.taskController,
    this.onNavigateToTasks,
  });

  void _handleStart(BuildContext context) {
    // Aktif görevi belirle veya taskController'daki seçili görevi bağla
    var task = controller.currentTask ?? taskController?.selectedTask;
    if (task == null && taskController != null && taskController!.tasks.isNotEmpty) {
      task = taskController!.tasks.first;
      taskController!.selectTask(task);
    }

    if (task == null) {
      // Görev seçilmemişse uyarı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.get('pleaseSelectTaskFirst')),
          backgroundColor: AppColors.burgundy,
          behavior: SnackBarBehavior.floating,
          action: onNavigateToTasks != null
              ? SnackBarAction(
                  label: AppStrings.get('selectTask'),
                  textColor: Colors.white,
                  onPressed: onNavigateToTasks!,
                )
              : null,
        ),
      );
      return;
    }

    // Görevi kilitli olarak başlat
    controller.startSession(task);
  }

  void _handleFinish(BuildContext context) {
    final task = controller.currentTask;
    if (task == null) {
      controller.finishSession(manual: true);
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(AppStrings.get('confirmFinishSessionTitle')),
        content: Text(AppStrings.get('confirmFinishSessionDesc')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppStrings.get('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              controller.finishSession(manual: true, markCompleted: false);
            },
            child: Text(AppStrings.get('justFinish')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              controller.finishSession(manual: true, markCompleted: true);
            },
            child: Text(AppStrings.get('finishAndCompleteTask')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (controller.status == PomodoroStatus.idle) {
      return _buildIdleButtons(context);
    } else if (controller.status == PomodoroStatus.working) {
      return _buildWorkingButtons(context);
    } else if (controller.status == PomodoroStatus.paused) {
      return _buildPausedButtons(context);
    } else {
      return _buildBreakButtons();
    }
  }

  Widget _buildIdleButtons(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.play_arrow_rounded, size: 24),
        label: Text(AppStrings.get('start')),
        onPressed: () => _handleStart(context),
      ),
    );
  }

  Widget _buildWorkingButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.pause_rounded),
          label: Text(AppStrings.get('pause')),
          onPressed: () => controller.pauseSession(),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          icon: const Icon(Icons.stop_rounded),
          label: Text(AppStrings.get('finish')),
          onPressed: () => _handleFinish(context),
        ),
      ],
    );
  }

  Widget _buildPausedButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.play_arrow_rounded),
          label: Text(AppStrings.get('resume')),
          onPressed: () => controller.resumeSession(),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          icon: const Icon(Icons.stop_rounded),
          label: Text(AppStrings.get('finish')),
          onPressed: () => _handleFinish(context),
        ),
      ],
    );
  }

  Widget _buildBreakButtons() {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.fast_forward_rounded),
        label: Text(AppStrings.get('earlyFinish')),
        onPressed: () => controller.finishBreakEarly(),
      ),
    );
  }
}
