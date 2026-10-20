// Flutter malzeme tasarım kütüphanesini ve ThemeMode enum'ını içeri aktarır
import 'package:flutter/material.dart';

/// ThemeController: Uygulama içerisinde Açık (Mavi) ve Koyu (Kırmızı) modlar arasındaki
/// dinamik geçişi ValueNotifier ile reaktif olarak yöneten Singleton sınıfıdır.
class ThemeController {
  // Sınıfın yalnızca kendi içerisinden örneklenmesini sağlayan özel (private) kurucu metot
  ThemeController._();

  // Tüm uygulama boyunca tek bir örnek (Singleton instance) üzerinden erişim sağlayan statik değişken
  static final ThemeController instance = ThemeController._();

  // Tema durumu bildirimcisi: Tema değişimlerini dinleyicilere anında bildiren reaktif yapı (Varsayılan: light)
  final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

  // Anlık olarak seçili olan tema modunu okuyan getter metot
  ThemeMode get themeMode => themeModeNotifier.value;

  // Koyu modun (Dark Mode) aktif olup olmadığını kontrol eden kolaylaştırıcı boolean getter
  bool get isDarkMode => themeModeNotifier.value == ThemeMode.dark;

  /// Açık (Light) ve Koyu (Dark) mod arasında anlık geçiş (toggle) yapar
  void toggleTheme() {
    // Mevcut mod açık tema ise
    if (themeModeNotifier.value == ThemeMode.light) {
      // Modu koyu tema (kırmızı vurgulu) olarak güncelle
      themeModeNotifier.value = ThemeMode.dark;
    } else {
      // Değilse modu açık tema (mavi ferah) olarak güncelle
      themeModeNotifier.value = ThemeMode.light;
    }
  }

  /// Parametre olarak verilen belirli bir tema modunu doğrudan atar
  void setTheme(ThemeMode mode) {
    // ValueNotifier değerini gelen mod ile güncelle ve dinleyen widget'ları tetikle
    themeModeNotifier.value = mode;
  }
}
