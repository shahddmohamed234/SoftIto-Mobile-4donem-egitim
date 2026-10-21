import '../data/models/task_model.dart';

/// Görev işlemlerinin soyut arayüzü (Clean Architecture Domain Katmanı)
abstract class TaskRepository {
  /// Tüm görevleri getirir
  Future<List<TaskModel>> getTasks();

  /// Yeni bir görev ekler
  Future<void> addTask(TaskModel task);

  /// Mevcut bir görevi günceller (örn: tamamlandı durumu)
  Future<void> updateTask(TaskModel task);

  /// Bir görevi siler
  Future<void> deleteTask(String id);
}
