import 'package:flutter/material.dart';
import '../../domain/task_repository.dart';
import '../../data/models/task_model.dart';
import '../../data/task_repository_impl.dart';

/// Görevlerin durumunu (State) yöneten yerel ChangeNotifier kontrolcüsü
/// 
/// Kırmızı çizgi kuralı: Dış ağır paketler yerine Flutter'ın yerel API'si kullanılmıştır.
class TaskController extends ChangeNotifier {
  // Görev deposu referansı
  final TaskRepository _repository;

  // Bellekte tutulan görevler listesi
  List<TaskModel> _tasks = [];

  // Pomodoro için seçili olan aktif görev
  TaskModel? _selectedTask;

  // Veri yüklenme durumu
  bool _isLoading = false;

  TaskController({TaskRepository? repository})
      : _repository = repository ?? TaskRepositoryImpl() {
    loadTasks();
  }

  // Getters
  List<TaskModel> get tasks => _tasks;
  TaskModel? get selectedTask => _selectedTask;
  bool get isLoading => _isLoading;

  /// Görevleri tarihlerine göre klasörleyip gruplayan harita
  Map<String, List<TaskModel>> get tasksGroupedByDate {
    final Map<String, List<TaskModel>> grouped = {};
    for (final task in _tasks) {
      final String dateKey = task.date.trim().isNotEmpty ? task.date.trim() : 'Tarihsiz';
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(task);
    }
    return grouped;
  }

  /// Belleğe ve JSON'a ilk görevleri yükler
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _repository.getTasks();

    // Eğer önceden seçili görev varsa ve listede hala mevcutsa korur, yoksa ilk görevi seçer
    if (_tasks.isNotEmpty) {
      if (_selectedTask == null) {
        _selectedTask = _tasks.first;
      } else {
        final bool stillExists = _tasks.any((t) => t.id == _selectedTask!.id);
        if (!stillExists) {
          _selectedTask = _tasks.first;
        }
      }
    } else {
      _selectedTask = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Yeni görev ekleme
  Future<void> addTask(String title, String date) async {
    final String newId = DateTime.now().millisecondsSinceEpoch.toString();
    final TaskModel newTask = TaskModel(
      id: newId,
      title: title,
      date: date.isEmpty ? 'Bugün' : date,
      isCompleted: false,
    );

    // 1. Önce anında bellek listesine ekleyip arayüzü günceller
    _tasks.insert(0, newTask);
    _selectedTask = newTask;
    notifyListeners();

    // 2. Ardından asenkron olarak yerel JSON dosyasına kaydeder
    try {
      await _repository.addTask(newTask);
    } catch (e) {
      debugPrint('Görev kaydedilirken hata: $e');
    }
  }

  /// Görevin tamamlandı durumunu değiştirir
  Future<void> toggleTaskCompletion(TaskModel task) async {
    final TaskModel updated = task.copyWith(isCompleted: !task.isCompleted);
    await _repository.updateTask(updated);

    final int index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = updated;
      if (_selectedTask?.id == task.id) {
        _selectedTask = updated;
      }
      notifyListeners();
    }
  }

  /// Görevi tamamlandı olarak işaretler (Pomodoro bittiğinde tetiklenir)
  Future<void> markTaskAsCompleted(String taskId) async {
    final int index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1 && !_tasks[index].isCompleted) {
      final TaskModel updated = _tasks[index].copyWith(isCompleted: true);
      await _repository.updateTask(updated);
      _tasks[index] = updated;
      if (_selectedTask?.id == taskId) {
        _selectedTask = updated;
      }
      notifyListeners();
    }
  }

  /// Görevi siler
  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    _tasks.removeWhere((t) => t.id == id);

    if (_selectedTask?.id == id) {
      if (_tasks.isNotEmpty) {
        _selectedTask = _tasks.first;
      } else {
        _selectedTask = null;
      }
    }

    notifyListeners();
  }

  /// Pomodoro için aktif görevi belirler
  void selectTask(TaskModel task) {
    _selectedTask = task;
    notifyListeners();
  }

  /// O günün listesinde sırada ne varsa onu bulur (biten görevin yerine geçer)
  TaskModel? getNextTask(TaskModel? currentTask) {
    if (_tasks.isEmpty) return null;

    if (currentTask != null) {
      // 1. O günün (aynı tarihteki) tüm görevlerini al
      final sameDayTasks = _tasks
          .where((t) => t.date.trim() == currentTask.date.trim())
          .toList();
      final currentIndex = sameDayTasks.indexWhere((t) => t.id == currentTask.id);

      // O günkü listede bu görevden sonra gelen ve tamamlanmamış olan ilk görev
      if (currentIndex != -1) {
        for (int i = currentIndex + 1; i < sameDayTasks.length; i++) {
          if (!sameDayTasks[i].isCompleted && sameDayTasks[i].id != currentTask.id) {
            return sameDayTasks[i];
          }
        }
      }

      // Eğer sonrasında yoksa, aynı günün başından itibaren tamamlanmamış başka bir görev var mı bak
      for (final task in sameDayTasks) {
        if (!task.isCompleted && task.id != currentTask.id) {
          return task;
        }
      }
    }

    // O gün başka görev kalmadıysa, genel listedeki tamamlanmamış ilk görevi getir
    for (final task in _tasks) {
      if (!task.isCompleted && (currentTask == null || task.id != currentTask.id)) {
        return task;
      }
    }

    return null;
  }
}
