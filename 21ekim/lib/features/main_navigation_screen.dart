import 'package:flutter/material.dart';
import 'pomodoro/presentation/screens/pomodoro_screen.dart';
import 'pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'tasks/presentation/screens/task_list_screen.dart';
import 'tasks/presentation/controllers/task_controller.dart';
import 'analytics/presentation/screens/analytics_screen.dart';
import 'settings/presentation/screens/settings_screen.dart';
import 'settings/presentation/controllers/settings_controller.dart';
import '../core/localization/app_strings.dart';
import '../core/theme/app_colors.dart';

/// 4 Ana Ekranı barındıran alt gezinti (Bottom Navigation) ana ekranı
class MainNavigationScreen extends StatefulWidget {
  final TaskController taskController;
  final PomodoroController pomodoroController;
  final SettingsController settingsController;

  const MainNavigationScreen({
    super.key,
    required this.taskController,
    required this.pomodoroController,
    required this.settingsController,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateToPomodoro() {
    widget.pomodoroController.setCurrentTask(widget.taskController.selectedTask);
    setState(() {
      _currentIndex = 0;
    });
  }

  void _navigateToTasks() {
    setState(() {
      _currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final screens = [
      PomodoroScreen(
        controller: widget.pomodoroController,
        taskController: widget.taskController,
        onNavigateToTasks: _navigateToTasks,
      ),
      TaskListScreen(
        controller: widget.taskController,
        onNavigateToPomodoro: _navigateToPomodoro,
      ),
      AnalyticsScreen(
        key: ValueKey('${widget.settingsController.languageCode}_$_currentIndex'),
      ),
      SettingsScreen(controller: widget.settingsController),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDark ? AppColors.cardDark : AppColors.white,
        selectedItemColor: isDark ? AppColors.pastelPink : AppColors.burgundy,
        unselectedItemColor: AppColors.roseDust.withValues(alpha: 0.6),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.timer_outlined),
            activeIcon: const Icon(Icons.timer),
            label: AppStrings.get('pomodoroTab'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.task_alt_outlined),
            activeIcon: const Icon(Icons.task_alt),
            label: AppStrings.get('tasksTab'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart_outlined),
            activeIcon: const Icon(Icons.bar_chart),
            label: AppStrings.get('analyticsTab'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: AppStrings.get('settingsTab'),
          ),
        ],
      ),
    );
  }
}
