import '../domain/task_repository.dart';
import 'models/task_model.dart';
import 'package:full_concentrate/core/utils/json_storage_service.dart';

/// TaskRepository arayüzünün yerel JSON dosyasını kullanan somut uygulaması
class TaskRepositoryImpl implements TaskRepository {
  // Yerel depolama servisi referansı
  final JsonStorageService _storageService;

  TaskRepositoryImpl({JsonStorageService? storageService})
      : _storageService = storageService ?? JsonStorageService();

  @override
  Future<List<TaskModel>> getTasks() async {
    // JSON dosyasından tüm görevleri okur
    return await _storageService.loadTasks();
  }

  @override
  Future<void> addTask(TaskModel task) async {
    // Mevcut görevleri okur
    final List<TaskModel> currentTasks = await _storageService.loadTasks();
    // Yeni görevi listenin en başına ekler
    currentTasks.insert(0, task);
    // Güncel listeyi JSON dosyasına kaydeder
    await _storageService.saveTasks(currentTasks);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final List<TaskModel> currentTasks = await _storageService.loadTasks();
    // İlgili görevin dizin indeksini bulur
    final int index = currentTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      currentTasks[index] = task;
      await _storageService.saveTasks(currentTasks);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    final List<TaskModel> currentTasks = await _storageService.loadTasks();
    // Belirtilen kimliğe sahip görevi listeden çıkarır
    currentTasks.removeWhere((t) => t.id == id);
    await _storageService.saveTasks(currentTasks);
  }
}
