import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/main_navigation_screen.dart';
import 'features/tasks/presentation/controllers/task_controller.dart';
import 'features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'features/settings/presentation/controllers/settings_controller.dart';

/// Uygulamanın ana giriş noktası
void main() async {
  // Flutter motoru ve widget bağlayıcılarının başlatıldığından emin olunur
  WidgetsFlutterBinding.ensureInitialized();

  // Uygulama genelinde kullanılacak kontrolcüler oluşturulur
  final settingsController = SettingsController();
  final taskController = TaskController();
  final pomodoroController = PomodoroController();

  // İlk veri yüklemeleri tamamlanır
  await settingsController.loadSettings();
  await taskController.loadTasks();

  // İlk seçili görev varsa Pomodoro kontrolcüsüne aktarılır
  if (taskController.selectedTask != null) {
    pomodoroController.setCurrentTask(taskController.selectedTask);
  }

  // Ana uygulama başlatılır
  runApp(FullConcentrateApp(
    settingsController: settingsController,
    taskController: taskController,
    pomodoroController: pomodoroController,
  ));
}

/// Ana Uygulama Kök Widget'ı
class FullConcentrateApp extends StatelessWidget {
  final SettingsController settingsController;
  final TaskController taskController;
  final PomodoroController pomodoroController;

  const FullConcentrateApp({
    super.key,
    required this.settingsController,
    required this.taskController,
    required this.pomodoroController,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Full Concentrate',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settingsController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: MainNavigationScreen(
            taskController: taskController,
            pomodoroController: pomodoroController,
            settingsController: settingsController,
          ),
        );
      },
    );
  }
}
