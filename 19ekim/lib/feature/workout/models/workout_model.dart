/// Yapılan tek bir egzersiz seansını temsil eden veri modeli.
class WorkoutModel {
  final String id;
  final String title;
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime timestamp;

  const WorkoutModel({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.timestamp,
  });

  /// Zamanı saat:dakika formatında verir (ör. 18:20).
  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
