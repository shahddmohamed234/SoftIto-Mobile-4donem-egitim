import 'package:flutter/material.dart';

/// ThemeController: Uygulama içerisinde Açık (Mavi) ve Koyu (Kırmızı) modlar arasındaki
/// dinamik geçişi ValueNotifier ile reaktif olarak yöneten Singleton sınıfıdır.
class ThemeController {
  ThemeController._();
  // Singleton örneği
  static final ThemeController instance = ThemeController._();

  // Tema durumu bildirimcisi (Varsayılan: light)
  final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

  // Anlık tema modu
  ThemeMode get themeMode => themeModeNotifier.value;

  // Koyu modun aktif olup olmadığı
  bool get isDarkMode => themeModeNotifier.value == ThemeMode.dark;

  /// Açık ve Koyu mod arasında anlık geçiş yapar
  void toggleTheme() {
    if (themeModeNotifier.value == ThemeMode.light) {
      themeModeNotifier.value = ThemeMode.dark;
    } else {
      themeModeNotifier.value = ThemeMode.light;
    }
  }

  /// Belirli bir tema modunu doğrudan atar
  void setTheme(ThemeMode mode) {
    themeModeNotifier.value = mode;
  }
}
