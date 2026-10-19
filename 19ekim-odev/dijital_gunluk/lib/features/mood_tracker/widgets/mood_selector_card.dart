import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class MoodSelectorCard extends StatefulWidget {
  final void Function(String mood, String note) onMoodSelected;

  const MoodSelectorCard({
    super.key,
    required this.onMoodSelected,
  });

  @override
  State<MoodSelectorCard> createState() => _MoodSelectorCardState();
}

class _MoodSelectorCardState extends State<MoodSelectorCard> {
  final TextEditingController _noteController = TextEditingController();
  String? _selectedMood;

  final List<Map<String, dynamic>> _moodTypes = const [
    {'name': 'Mutlu', 'icon': Icons.sentiment_very_satisfied_rounded, 'color': AppColors.moodHappy},
    {'name': 'Huzurlu', 'icon': Icons.spa_rounded, 'color': AppColors.moodPeaceful},
    {'name': 'Enerjik', 'icon': Icons.bolt_rounded, 'color': AppColors.moodEnergetic},
    {'name': 'Düşünceli', 'icon': Icons.psychology_rounded, 'color': AppColors.moodThoughtful},
    {'name': 'Üzgün', 'icon': Icons.sentiment_dissatisfied_rounded, 'color': AppColors.moodSad},
    {'name': 'Yorgun', 'icon': Icons.bedtime_rounded, 'color': AppColors.moodTired},
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Şu an nasıl hissediyorsun?',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildMoodOptions(),
            if (_selectedMood != null) ...[
              const SizedBox(height: 12),
              _buildNoteInput(theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMoodOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _moodTypes.map((item) {
        final name = item['name'] as String;
        final icon = item['icon'] as IconData;
        final color = item['color'] as Color;
        final isSelected = _selectedMood == name;

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              _selectedMood = isSelected ? null : name;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? color.withValues(alpha: 0.25) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 26),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNoteInput(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              hintText: 'Kısa bir his notu bırak...',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: _saveCurrentMood,
          icon: const Icon(Icons.send_rounded, size: 18),
        ),
      ],
    );
  }

  void _saveCurrentMood() {
    if (_selectedMood == null) return;
    widget.onMoodSelected(_selectedMood!, _noteController.text.trim());
    _noteController.clear();
    setState(() => _selectedMood = null);
  }
}
