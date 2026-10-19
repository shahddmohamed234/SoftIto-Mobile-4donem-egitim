import 'package:flutter/foundation.dart';
import '../models/diary_model.dart';

class DiaryController {
  final ValueNotifier<DateTime> selectedDate = ValueNotifier<DateTime>(
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
  );

  final ValueNotifier<List<DiaryEntry>> entries = ValueNotifier<List<DiaryEntry>>([
    DiaryEntry(
      id: '1',
      title: 'Bugün Yeni Bir Başlangıç',
      content: 'Dijital günlüğüme ilk sayfayı ekledim. Yeni hedefler belirledim ve kahve eşliğinde kitap okudum.',
      mood: 'Huzurlu',
      tags: const ['Fikirler', 'Kahve', 'Huzur'],
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    DiaryEntry(
      id: '2',
      title: 'Akşam Yürüyüşü ve İlham',
      content: 'Sonbahar rüzgarı eşliğinde parkta uzun bir yürüyüş yaptım. Düşüncelerimi toparlamak çok iyi geldi.',
      mood: 'Mutlu',
      tags: const ['Doğa', 'Sağlık'],
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    ),
  ]);

  void setSelectedDate(DateTime date) {
    selectedDate.value = DateTime(date.year, date.month, date.day);
  }

  void addEntry(
    String title,
    String content,
    String mood, [
    List<String> tags = const [],
    DateTime? targetDate,
  ]) {
    final entryDate = targetDate ?? selectedDate.value;
    final now = DateTime.now();
    // Seçilen günün tarihi ve güncel saat kombinasyonu
    final createdAt = DateTime(
      entryDate.year,
      entryDate.month,
      entryDate.day,
      now.hour,
      now.minute,
      now.second,
    );

    final newEntry = DiaryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      mood: mood,
      tags: tags,
      createdAt: createdAt,
    );

    // Yeni referans ataması ile ValueNotifier tetiklenir
    entries.value = [newEntry, ...entries.value];
  }

  void updateEntry(DiaryEntry updated) {
    entries.value = entries.value.map((e) => e.id == updated.id ? updated : e).toList();
  }

  void deleteEntry(String id) {
    entries.value = entries.value.where((entry) => entry.id != id).toList();
  }

  void dispose() {
    entries.dispose();
    selectedDate.dispose();
  }
}
