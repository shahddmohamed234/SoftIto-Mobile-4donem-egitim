/// Kullanıcı ayarlarını temsil eden model sınıfı
/// 
/// settings.json dosyasında saklanır ve tema/dil/ses ayarlarını yönetir.
class SettingsModel {
  // Seçilen dil kodu ('tr' veya 'en')
  final String languageCode;

  // Karanlık modun açık olup olmadığı
  final bool isDarkMode;

  // Alarm ses seviyesi (0.0 ile 1.0 arasında)
  final double pomodoroVolume;

  // Pomodoro bitiminde çalacak ses tonu adı ('Klasik Çan', 'Dijital Bip', 'Doğa Kuş')
  final String pomodoroSoundType;

  // Mola bitiminde çalacak ses tonu adı ('Yumuşak Melodi', 'Su Şırıltısı', 'Ksilofon')
  final String breakSoundType;

  const SettingsModel({
    this.languageCode = 'tr',
    this.isDarkMode = false,
    this.pomodoroVolume = 0.8,
    this.pomodoroSoundType = 'Klasik Çan',
    this.breakSoundType = 'Yumuşak Melodi',
  });

  /// Bir kopyasını yeni değerlerle oluşturmak için yardımcı metot
  SettingsModel copyWith({
    String? languageCode,
    bool? isDarkMode,
    double? pomodoroVolume,
    String? pomodoroSoundType,
    String? breakSoundType,
  }) {
    return SettingsModel(
      languageCode: languageCode ?? this.languageCode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      pomodoroVolume: pomodoroVolume ?? this.pomodoroVolume,
      pomodoroSoundType: pomodoroSoundType ?? this.pomodoroSoundType,
      breakSoundType: breakSoundType ?? this.breakSoundType,
    );
  }

  /// JSON haritasından SettingsModel nesnesi üretir
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      languageCode: json['languageCode'] as String? ?? 'tr',
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      pomodoroVolume: (json['pomodoroVolume'] as num?)?.toDouble() ?? 0.8,
      pomodoroSoundType: json['pomodoroSoundType'] as String? ?? 'Klasik Çan',
      breakSoundType: json['breakSoundType'] as String? ?? 'Yumuşak Melodi',
    );
  }

  /// SettingsModel nesnesini JSON haritasına dönüştürür
  Map<String, dynamic> toJson() {
    return {
      'languageCode': languageCode,
      'isDarkMode': isDarkMode,
      'pomodoroVolume': pomodoroVolume,
      'pomodoroSoundType': pomodoroSoundType,
      'breakSoundType': breakSoundType,
    };
  }
}
