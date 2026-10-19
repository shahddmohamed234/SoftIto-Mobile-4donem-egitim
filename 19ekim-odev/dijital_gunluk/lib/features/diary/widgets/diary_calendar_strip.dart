import 'package:flutter/material.dart';
import '../models/diary_model.dart';

class DiaryCalendarStrip extends StatelessWidget {
  final DateTime selectedDate;
  final List<DiaryEntry> entries;
  final ValueChanged<DateTime> onDateSelected;

  const DiaryCalendarStrip({
    super.key,
    required this.selectedDate,
    required this.entries,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = _generateDaysAround(selectedDate);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, theme),
          const SizedBox(height: 8),
          _buildDaysList(days, theme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    final months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    final title = '${months[selectedDate.month - 1]} ${selectedDate.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined, size: 20),
            tooltip: 'Tarih Seç',
            visualDensity: VisualDensity.compact,
            onPressed: () => _pickDate(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysList(List<DateTime> days, ThemeData theme) {
    return SizedBox(
      height: 70,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = _isSameDay(day, selectedDate);
          final hasEntries = entries.any((e) => _isSameDay(e.createdAt, day));
          return _DayItem(
            date: day,
            isSelected: isSelected,
            hasEntries: hasEntries,
            onTap: () => onDateSelected(day),
          );
        },
      ),
    );
  }

  List<DateTime> _generateDaysAround(DateTime center) {
    final list = <DateTime>[];
    for (int i = -7; i <= 7; i++) {
      list.add(center.add(Duration(days: i)));
    }
    return list;
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _DayItem extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool hasEntries;
  final VoidCallback onTap;

  const _DayItem({
    required this.date,
    required this.isSelected,
    required this.hasEntries,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final dayName = dayNames[date.weekday - 1];

    final bgColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    final textColor = isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 48,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: TextStyle(
                fontSize: 10,
                color: textColor.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasEntries
                    ? (isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.primary)
                    : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
