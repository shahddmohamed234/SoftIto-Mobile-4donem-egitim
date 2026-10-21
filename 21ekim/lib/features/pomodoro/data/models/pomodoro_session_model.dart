/// Tamamlanan veya gerçekleşen Pomodoro oturumunu temsil eden model
/// 
/// sessions.json dosyasında saklanır ve analitik ekranında grafiklere dönüştürülür.
class PomodoroSessionModel {
  // Seansın benzersiz kimliği
  final String id;

  // Seansın hangi göreve ait olduğunu belirten görev kimliği
  final String taskId;

  // Gerçekleşen çalışma süresi (dakika cinsinden)
  final int workDuration;

  // Gerçekleşen veya hak edilen mola süresi (dakika cinsinden)
  final int breakDuration;

  // Seansın gerçekleştiği tarih ve saat zaman damgası (ISO-8601 string)
  final String timestamp;

  // Seans sırasında çıkış ihlali yapılıp yapılmadığı
  final bool wasViolated;

  const PomodoroSessionModel({
    required this.id,
    required this.taskId,
    required this.workDuration,
    required this.breakDuration,
    required this.timestamp,
    this.wasViolated = false,
  });

  /// JSON haritasından PomodoroSessionModel nesnesi üretir
  factory PomodoroSessionModel.fromJson(Map<String, dynamic> json) {
    return PomodoroSessionModel(
      id: json['id'] as String? ?? '',
      taskId: json['taskId'] as String? ?? '',
      workDuration: json['workDuration'] as int? ?? 25,
      breakDuration: json['breakDuration'] as int? ?? 5,
      timestamp: json['timestamp'] as String? ?? DateTime.now().toIso8601String(),
      wasViolated: json['wasViolated'] as bool? ?? false,
    );
  }

  /// PomodoroSessionModel nesnesini JSON haritasına dönüştürür
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'workDuration': workDuration,
      'breakDuration': breakDuration,
      'timestamp': timestamp,
      'wasViolated': wasViolated,
    };
  }
}
