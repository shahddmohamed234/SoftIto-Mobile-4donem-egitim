// Flutter malzeme tasarımı ve liste elemanı kütüphanesini içeri aktarır
import 'package:flutter/material.dart';
// Reaktif tema kontrolcüsünü içeri aktarır
import 'package:easy_rent/core/theme/theme_controller.dart';

/// ThemeSwitchTile: Kullanıcının Açık (Mavi) ve Koyu (Kırmızı) temalar arasında
/// ValueNotifier ile anlık ve kesintisiz geçiş yapmasını sağlayan ayar bileşenidir.
class ThemeSwitchTile extends StatelessWidget {
  // Sabit kurucu metot
  const ThemeSwitchTile({super.key});

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    // Tema modunun değişimini anlık dinleyen reaktif yapı
    return ValueListenableBuilder<ThemeMode>(
      // ThemeController singleton'ının ValueNotifier bildirimcisi
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (context, mode, _) {
        // Koyu temanın aktif olup olmadığını belirleyen kontrol bayrağı
        final isDark = mode == ThemeMode.dark;
        return Card(
          // Platforma duyarlı (iOS/Android) anahtarlama liste elemanı
          child: SwitchListTile.adaptive(
            // Ana başlık
            title: const Text('Koyu Mod (Kırmızı Tema)', style: TextStyle(fontWeight: FontWeight.bold)),
            // Aktif tema durumuna göre değişen alt başlık açıklaması
            subtitle: Text(
              isDark ? 'Kırmızı vurgulu koyu mod devrede' : 'Mavi ağırlıklı açık mod devrede',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            // Sol baştaki tema ikonu (Ay veya Güneş)
            secondary: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).colorScheme.primary,
            ),
            // Anahtarın açık/kapalı durumu (Koyu mod ise açık)
            value: isDark,
            // Anahtar değiştirildiğinde çalışacak fonksiyon
            onChanged: (val) {
              // Temayı tersine çevirir (Light -> Dark veya Dark -> Light)
              ThemeController.instance.toggleTheme();
              // Kullanıcıya bilgi amaçlı kısa süreli SnackBar gösterir
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(val ? 'Koyu Kırmızı Tema aktif edildi' : 'Açık Mavi Tema aktif edildi'),
                  duration: const Duration(seconds: 1),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
