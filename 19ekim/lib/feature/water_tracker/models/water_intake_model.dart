/// Tek bir su tüketim kaydını temsil eden değişmez veri modeli.
class WaterIntakeModel {
  final String id;
  final int amountMl;
  final DateTime timestamp;
  final String label;

  const WaterIntakeModel({
    required this.id,
    required this.amountMl,
    required this.timestamp,
    required this.label,
  });

  /// Zamanı saat:dakika formatında verir (ör. 14:35).
  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
