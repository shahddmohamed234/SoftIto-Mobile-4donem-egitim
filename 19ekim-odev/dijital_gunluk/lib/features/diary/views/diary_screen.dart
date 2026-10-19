import 'package:flutter/material.dart';
import '../controllers/diary_controller.dart';
import '../models/diary_model.dart';
import '../widgets/diary_calendar_strip.dart';
import '../widgets/diary_card.dart';
import '../widgets/diary_editor_sheet.dart';
import '../widgets/diary_empty_view.dart';

class DiaryScreen extends StatefulWidget {
  final DiaryController controller;

  const DiaryScreen({
    super.key,
    required this.controller,
  });

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anı Defterim'),
      ),
      body: ValueListenableBuilder<List<DiaryEntry>>(
        valueListenable: widget.controller.entries,
        builder: (context, entries, _) {
          return ValueListenableBuilder<DateTime>(
            valueListenable: widget.controller.selectedDate,
            builder: (context, selectedDate, _) {
              final filtered = entries.where((e) => _isSameDay(e.createdAt, selectedDate)).toList();
              return Column(
                children: [
                  DiaryCalendarStrip(
                    selectedDate: selectedDate,
                    entries: entries,
                    onDateSelected: (d) => widget.controller.setSelectedDate(d),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: filtered.isEmpty
                        ? DiaryEmptyView(
                            selectedDate: selectedDate,
                            onAddPressed: () => _openAddSheet(selectedDate),
                          )
                        : _buildEntryList(filtered),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddSheet(widget.controller.selectedDate.value),
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Yeni Anı'),
      ),
    );
  }

  Widget _buildEntryList(List<DiaryEntry> entries) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 88),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return DiaryCard(
          entry: entry,
          onDelete: () => widget.controller.deleteEntry(entry.id),
          onTap: () => _openEditSheet(entry),
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _openAddSheet(DateTime date) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DiaryEditorSheet(
          targetDate: date,
          onSave: (title, content, mood, tags) {
            widget.controller.addEntry(title, content, mood, tags, date);
          },
        );
      },
    );
  }

  void _openEditSheet(DiaryEntry entry) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DiaryEditorSheet(
          initialEntry: entry,
          targetDate: entry.createdAt,
          onSave: (title, content, mood, tags) {
            widget.controller.updateEntry(
              entry.copyWith(
                title: title,
                content: content,
                mood: mood,
                tags: tags,
              ),
            );
          },
        );
      },
    );
  }
}
