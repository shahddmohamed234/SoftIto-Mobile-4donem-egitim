import 'package:flutter_test/flutter_test.dart';
import 'package:full_concentrate/main.dart';
import 'package:full_concentrate/features/settings/presentation/controllers/settings_controller.dart';
import 'package:full_concentrate/features/tasks/presentation/controllers/task_controller.dart';
import 'package:full_concentrate/features/pomodoro/presentation/controllers/pomodoro_controller.dart';

void main() {
  testWidgets('FullConcentrateApp smoke test', (WidgetTester tester) async {
    final settingsController = SettingsController();
    final taskController = TaskController();
    final pomodoroController = PomodoroController();

    await tester.pumpWidget(FullConcentrateApp(
      settingsController: settingsController,
      taskController: taskController,
      pomodoroController: pomodoroController,
    ));

    expect(find.byType(FullConcentrateApp), findsOneWidget);
  });
}
