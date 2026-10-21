

/// Uygulama genelinde kullanılacak temel sabitler ve hesaplama denklemleri
class AppConstants {
  // Pomodoro için izin verilen en küçük çalışma süresi (dakika cinsinden)
  static const int minWorkDurationMinutes = 25;

  // Temel pomodoro döngüsü çalışma süresi referansı (25 dakika)
  static const int baseWorkReferenceMinutes = 25;

  // Temel mola süresi referansı (5 dakika)
  static const int baseBreakReferenceMinutes = 5;

  // Yerel depolamada saklanacak JSON dosyalarının temel adları
  static const String tasksFileName = 'tasks';
  static const String sessionsFileName = 'sessions';
  static const String settingsFileName = 'settings';

  // Desteklenen sistem dilleri
  static const String langTr = 'tr';
  static const String langEn = 'en';

  /// Dinamik mola süresi hesaplama denklemi (Equation)
  /// 
  /// Kurallar:
  /// - En az 25 dakika çalışma zorunludur.
  /// - Her 25 dakikalık çalışma için 5 dakika mola eklenir.
  /// - Örneğin 50 dakika çalışma için 10 dakika mola verilir.
  static int calculateBreakDuration(int workDurationInMinutes) {
    // Çalışma süresinin minimum 25 dakikadan az olup olmadığı kontrol edilir
    if (workDurationInMinutes >= minWorkDurationMinutes) {
      // 25 dakikaya oran katsayısı hesaplanır (örn. 50 / 25 = 2.0)
      final double multiplier = workDurationInMinutes / baseWorkReferenceMinutes;
      // Katsayı 5 dakika ile çarpılarak yuvarlanır
      return (baseBreakReferenceMinutes * multiplier).round();
    } else {
      // Minimum süre kuralı ihlal edilirse güvenlik amacıyla varsayılan 5 dakika mola döndürülür
      return baseBreakReferenceMinutes;
    }
  }
}
