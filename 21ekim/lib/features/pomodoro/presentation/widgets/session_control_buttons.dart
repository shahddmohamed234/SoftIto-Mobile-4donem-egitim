import 'package:flutter/material.dart';
import '../controllers/pomodoro_controller.dart';
import '../../../../core/localization/app_strings.dart';

/// Seans kontrol butonları (Başlat, Duraklat, Devam Et, Bitir)
class SessionControlButtons extends StatelessWidget {
  final PomodoroController controller;

  const SessionControlButtons({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.status == PomodoroStatus.idle) {
      return _buildIdleButtons();
    } else if (controller.status == PomodoroStatus.working) {
      return _buildWorkingButtons();
    } else if (controller.status == PomodoroStatus.paused) {
      return _buildPausedButtons();
    } else {
      return _buildBreakButtons();
    }
  }

  Widget _buildIdleButtons() {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.play_arrow),
        label: Text(AppStrings.get('start')),
        onPressed: () => controller.startSession(),
      ),
    );
  }

  Widget _buildWorkingButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.pause),
          label: Text(AppStrings.get('pause')),
          onPressed: () => controller.pauseSession(),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          icon: const Icon(Icons.stop),
          label: Text(AppStrings.get('finish')),
          onPressed: () => controller.finishSession(manual: true),
        ),
      ],
    );
  }

  Widget _buildPausedButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.play_arrow),
          label: Text(AppStrings.get('resume')),
          onPressed: () => controller.resumeSession(),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          icon: const Icon(Icons.stop),
          label: Text(AppStrings.get('finish')),
          onPressed: () => controller.finishSession(manual: true),
        ),
      ],
    );
  }

  Widget _buildBreakButtons() {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.fast_forward),
        label: Text(AppStrings.get('earlyFinish')),
        onPressed: () => controller.finishBreakEarly(),
      ),
    );
  }
}
