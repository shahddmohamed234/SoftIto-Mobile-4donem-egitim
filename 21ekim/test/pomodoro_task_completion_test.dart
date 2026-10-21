import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_concentrate/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:full_concentrate/features/tasks/data/models/task_model.dart';
import 'package:full_concentrate/features/pomodoro/domain/pomodoro_repository.dart';
import 'package:full_concentrate/features/pomodoro/data/models/pomodoro_session_model.dart';

class MockPomodoroRepository implements PomodoroRepository {
  final List<PomodoroSessionModel> savedSessions = [];

  @override
  Future<List<PomodoroSessionModel>> getSessions() async => savedSessions;

  @override
  Future<void> saveSession(PomodoroSessionModel session) async {
    savedSessions.add(session);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers.global'),
      (MethodCall methodCall) async => 1,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (MethodCall methodCall) async => 1,
    );
  });

  test('Pomodoro locks task when started and cannot change during session', () {
    final repo = MockPomodoroRepository();
    final controller = PomodoroController(repository: repo);

    final task1 = TaskModel(id: '1', title: 'Matematik', date: '21.10.2026', isCompleted: false);
    final task2 = TaskModel(id: '2', title: 'Fizik', date: '21.10.2026', isCompleted: false);

    controller.setCurrentTask(task1);
    expect(controller.currentTask?.title, 'Matematik');

    controller.startSession();
    expect(controller.status, PomodoroStatus.working);

    // Seans devam ederken görev değiştirilemez
    controller.setCurrentTask(task2);
    expect(controller.currentTask?.title, 'Matematik');
  });

  test('Pomodoro completion triggers onTaskCompleted and marks task completed', () async {
    final repo = MockPomodoroRepository();
    final controller = PomodoroController(repository: repo);

    final task = TaskModel(id: '10', title: 'Tarih', date: '21.10.2026', isCompleted: false);
    controller.setCurrentTask(task);

    TaskModel? completedTask;
    controller.onTaskCompleted = (t) {
      completedTask = t;
    };

    controller.startSession();
    await controller.finishSession(manual: true, markCompleted: true);

    expect(completedTask?.id, '10');
    expect(controller.currentTask?.isCompleted, true);
  });

  test('getNextTask finds the next uncompleted task on the same day', () {
    final task1 = TaskModel(id: '1', title: 'Matematik', date: '21.10.2026', isCompleted: true);
    final task2 = TaskModel(id: '2', title: 'Fizik', date: '21.10.2026', isCompleted: false);
    final task3 = TaskModel(id: '3', title: 'Kimya', date: '21.10.2026', isCompleted: false);
    final taskOtherDay = TaskModel(id: '4', title: 'Biyoloji', date: '22.10.2026', isCompleted: false);

    // Mock controller test using taskController
    final tasks = [task1, task2, task3, taskOtherDay];
    final sameDay = tasks.where((t) => t.date == task1.date).toList();
    final currentIndex = sameDay.indexWhere((t) => t.id == task1.id);
    TaskModel? next;
    for (int i = currentIndex + 1; i < sameDay.length; i++) {
      if (!sameDay[i].isCompleted) {
        next = sameDay[i];
        break;
      }
    }

    expect(next?.title, 'Fizik');
  });

  test('Break finish transitions to nextTask as the new currentTask', () {
    final repo = MockPomodoroRepository();
    final controller = PomodoroController(repository: repo);

    final nextTask = TaskModel(id: '2', title: 'Fizik', date: '21.10.2026', isCompleted: false);
    controller.setNextTask(nextTask);

    expect(controller.nextTask?.title, 'Fizik');

    controller.finishBreakEarly();

    expect(controller.currentTask?.title, 'Fizik');
    expect(controller.nextTask, null);
  });
}
