import 'package:flutter/material.dart';
import '../controllers/settings_controller.dart';

class ThemeSwitchCard extends StatelessWidget {
  final SettingsController controller;

  const ThemeSwitchCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: controller.themeMode,
          builder: (context, currentMode, _) {
            final isDark = currentMode == ThemeMode.dark;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme, isDark),
                const SizedBox(height: 16),
                _buildModeSelectors(theme, isDark),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 10),
            Text(
              'Görünüm Teması',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Switch.adaptive(
          value: isDark,
          onChanged: (_) => controller.toggleTheme(),
        ),
      ],
    );
  }

  Widget _buildModeSelectors(ThemeData theme, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _ThemeOptionTile(
            title: 'Açık Tema',
            subtitle: 'Kağıt Dokusu',
            icon: Icons.wb_sunny_outlined,
            isSelected: !isDark,
            onTap: () => controller.setThemeMode(ThemeMode.light),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ThemeOptionTile(
            title: 'Koyu Tema',
            subtitle: 'Gece Okuma',
            icon: Icons.nightlight_round_outlined,
            isSelected: isDark,
            onTap: () => controller.setThemeMode(ThemeMode.dark),
          ),
        ),
      ],
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = isSelected ? theme.colorScheme.primary : theme.colorScheme.outline;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          color: isSelected
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.2)
              : Colors.transparent,
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface),
            const SizedBox(height: 6),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              subtitle,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
