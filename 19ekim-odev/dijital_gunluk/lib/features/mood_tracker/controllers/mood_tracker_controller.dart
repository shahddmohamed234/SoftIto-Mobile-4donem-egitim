import 'package:flutter/foundation.dart';
import '../models/mood_entry_model.dart';

class MoodTrackerController {
  final ValueNotifier<List<MoodEntry>> moods = ValueNotifier<List<MoodEntry>>([
    MoodEntry(
      id: 'm1',
      mood: 'Huzurlu',
      note: 'Sakin ve verimli bir sabah geçirdim.',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    MoodEntry(
      id: 'm2',
      mood: 'Mutlu',
      note: 'Arkadaşlarla güzel bir öğle yemeği.',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    ),
    MoodEntry(
      id: 'm3',
      mood: 'Enerjik',
      note: 'Sabah sporu harika hissettirdi!',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
    ),
  ]);

  void addMood(String mood, [String note = '']) {
    final entry = MoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mood: mood,
      note: note,
      timestamp: DateTime.now(),
    );

    moods.value = [entry, ...moods.value];
  }

  void deleteMood(String id) {
    moods.value = moods.value.where((m) => m.id != id).toList();
  }

  Map<String, int> getMoodCounts() {
    final Map<String, int> counts = {
      'Mutlu': 0,
      'Huzurlu': 0,
      'Enerjik': 0,
      'Düşünceli': 0,
      'Üzgün': 0,
      'Yorgun': 0,
    };

    for (final entry in moods.value) {
      counts[entry.mood] = (counts[entry.mood] ?? 0) + 1;
    }
    return counts;
  }

  void dispose() {
    moods.dispose();
  }
}
