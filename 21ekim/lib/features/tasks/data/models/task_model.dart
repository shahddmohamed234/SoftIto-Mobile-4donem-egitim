/// Görev verilerini temsil eden model sınıfı
/// 
/// tasks.json dosyasına yazılıp okunurken serialize / deserialize edilir.
class TaskModel {
  // Görevin benzersiz kimliği (UUID veya milisaniye damgası)
  final String id;

  // Görevin başlığı veya açıklaması
  final String title;

  // DD.MM.YYYY formatında görev tarihi
  final String date;

  // Görevin tamamlanıp tamamlanmadığı durumu
  final bool isCompleted;

  const TaskModel({
    required this.id,
    required this.title,
    required this.date,
    this.isCompleted = false,
  });

  /// Bir kopyasını yeni değerlerle oluşturmak için yardımcı metot
  TaskModel copyWith({
    String? id,
    String? title,
    String? date,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// JSON haritasından TaskModel nesnesi üretir
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      date: json['date'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  /// TaskModel nesnesini JSON haritasına dönüştürür
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'isCompleted': isCompleted,
    };
  }
}
