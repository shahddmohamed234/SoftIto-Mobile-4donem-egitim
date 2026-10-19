import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AddWorkoutDialog extends StatefulWidget {
  const AddWorkoutDialog({super.key});

  @override
  State<AddWorkoutDialog> createState() => _AddWorkoutDialogState();
}

class _AddWorkoutDialogState extends State<AddWorkoutDialog> {
  final List<Map<String, dynamic>> _presets = [
    {'name': 'Tempolu Koşu', 'duration': 30, 'calories': 320, 'icon': Icons.directions_run},
    {'name': 'Ağırlık Antrenmanı', 'duration': 45, 'calories': 260, 'icon': Icons.fitness_center},
    {'name': 'Bisiklet / Spin', 'duration': 40, 'calories': 380, 'icon': Icons.directions_bike},
    {'name': 'HIIT Kardiyo', 'duration': 25, 'calories': 300, 'icon': Icons.bolt},
    {'name': 'Yüzme', 'duration': 30, 'calories': 310, 'icon': Icons.pool},
  ];

  int _selectedPresetIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selected = _presets[_selectedPresetIndex];
    final int extraWater =
        ((selected['calories'] as int) * 1.5 + (selected['duration'] as int) * 5).round();

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogTitle(),
            const SizedBox(height: 16),
            _buildPresetSelector(),
            const SizedBox(height: 16),
            _buildPreviewBox(selected, extraWater),
            const SizedBox(height: 20),
            _buildActionButtons(context, selected),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogTitle() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.neonLime : const Color(0xFF16A34A);
    final titleColor = Theme.of(context).colorScheme.onSurface;

    return Row(
      children: [
        Icon(Icons.sports_gymnastics, color: accentColor),
        const SizedBox(width: 8),
        Text(
          'Antrenman Kaydet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: titleColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPresetSelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.neonLime : const Color(0xFF16A34A);
    final cardColor = Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface;
    final defaultBorder = isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final mutedColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return Column(
      children: List.generate(_presets.length, (index) {
        final item = _presets[index];
        final isSelected = index == _selectedPresetIndex;

        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _selectedPresetIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? accentColor.withValues(alpha: 0.15) : cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? accentColor : defaultBorder,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    item['icon'] as IconData,
                    color: isSelected ? accentColor : mutedColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    item['name'] as String,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? accentColor : textColor,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${item['duration']} dk • ${item['calories']} kcal',
                    style: TextStyle(fontSize: 11, color: mutedColor),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPreviewBox(Map<String, dynamic> selected, int extraWater) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtextColor = isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Önerilen Ek Su Miktarı:',
            style: TextStyle(fontSize: 12, color: subtextColor),
          ),
          Text(
            '+$extraWater ml',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Map<String, dynamic> selected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.neonLime : const Color(0xFF16A34A);
    final btnFg = isDark ? AppColors.darkBackground : Colors.white;
    final mutedColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Vazgeç', style: TextStyle(color: mutedColor)),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: btnFg,
          ),
          onPressed: () {
            Navigator.pop(context, selected);
          },
          child: const Text('Hedefe Ekle'),
        ),
      ],
    );
  }
}
