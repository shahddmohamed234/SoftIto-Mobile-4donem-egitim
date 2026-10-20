import 'package:flutter/material.dart';
import 'package:easy_rent/core/theme/theme_controller.dart';

/// ThemeSwitchTile: Kullanıcının Açık (Mavi) ve Koyu (Kırmızı) temalar arasında
/// ValueNotifier ile anlık ve kesintisiz geçiş yapmasını sağlayan ayar bileşenidir.
class ThemeSwitchTile extends StatelessWidget {
  const ThemeSwitchTile({super.key});

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return Card(
          child: SwitchListTile.adaptive(
            title: const Text('Koyu Mod (Kırmızı Tema)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              isDark ? 'Kırmızı vurgulu koyu mod devrede' : 'Mavi ağırlıklı açık mod devrede',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            secondary: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).colorScheme.primary,
            ),
            value: isDark,
            onChanged: (val) {
              ThemeController.instance.toggleTheme();
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
