import 'package:flutter/material.dart';
import '../controllers/settings_controller.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

/// Ayarlar Ekranı (Sayfa 4)
class SettingsScreen extends StatelessWidget {
  final SettingsController controller;

  const SettingsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.get('settingsTab'))),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              _buildLanguageTile(context),
              _buildDarkModeTile(),
              _buildVolumeTile(context),
              _buildSoundToneTile(
                title: AppStrings.get('pomodoroSound'),
                currentValue: controller.settings.pomodoroSoundType,
                options: const ['Klasik Çan', 'Dijital Bip', 'Doğa Kuş'],
                onChanged: (val) {
                  if (val != null) controller.setPomodoroSoundType(val);
                },
              ),
              _buildSoundToneTile(
                title: AppStrings.get('breakSound'),
                currentValue: controller.settings.breakSoundType,
                options: const ['Yumuşak Melodi', 'Su Şırıltısı', 'Ksilofon'],
                onChanged: (val) {
                  if (val != null) controller.setBreakSoundType(val);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.language, color: AppColors.burgundy),
        title: Text(AppStrings.get('language')),
        trailing: DropdownButton<String>(
          value: controller.languageCode,
          underline: const SizedBox.shrink(),
          items: const [
            DropdownMenuItem(value: 'tr', child: Text('Türkçe (TR)')),
            DropdownMenuItem(value: 'en', child: Text('English (EN)')),
          ],
          onChanged: (val) {
            if (val != null) controller.setLanguage(val);
          },
        ),
      ),
    );
  }

  Widget _buildDarkModeTile() {
    return Card(
      child: SwitchListTile(
        secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.roseDust),
        title: Text(AppStrings.get('darkMode')),
        value: controller.isDarkMode,
        activeThumbColor: AppColors.burgundy,
        onChanged: (val) => controller.toggleDarkMode(val),
      ),
    );
  }

  Widget _buildVolumeTile(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.volume_up_outlined, color: AppColors.burgundy),
                const SizedBox(width: 12),
                Text(
                  '${AppStrings.get('soundLevel')}: %${(controller.settings.pomodoroVolume * 100).round()}',
                ),
              ],
            ),
            Slider(
              value: controller.settings.pomodoroVolume,
              min: 0.0,
              max: 1.0,
              activeColor: AppColors.burgundy,
              inactiveColor: AppColors.roseDust.withValues(alpha: 0.3),
              onChanged: (val) => controller.setVolume(val),
            ),
          ],
        ),
      ),
    );
  }

  String _getSoundOptionTitle(String opt) {
    if (opt == 'Klasik Çan') return AppStrings.get('classicBell');
    if (opt == 'Dijital Bip') return AppStrings.get('digitalBeep');
    if (opt == 'Doğa Kuş') return AppStrings.get('natureBird');
    if (opt == 'Yumuşak Melodi') return AppStrings.get('softMelody');
    if (opt == 'Su Şırıltısı') return AppStrings.get('waterStream');
    if (opt == 'Ksilofon') return AppStrings.get('xylophone');
    return opt;
  }

  Widget _buildSoundToneTile({
    required String title,
    required String currentValue,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.music_note, color: AppColors.roseDust),
        title: Text(title),
        trailing: DropdownButton<String>(
          value: currentValue,
          underline: const SizedBox.shrink(),
          items: options
              .map((opt) => DropdownMenuItem(value: opt, child: Text(_getSoundOptionTitle(opt))))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
