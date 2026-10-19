import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dijital_gunluk/main.dart';
import 'package:dijital_gunluk/features/diary/controllers/diary_controller.dart';
import 'package:dijital_gunluk/features/mood_tracker/controllers/mood_tracker_controller.dart';
import 'package:dijital_gunluk/features/settings/controllers/settings_controller.dart';

void main() {
  group('DiaryController Tests', () {
    test('Başlangıç anıları mevcut ve addEntry anı ekler', () {
      final controller = DiaryController();
      expect(controller.entries.value.isNotEmpty, true);

      final initialCount = controller.entries.value.length;
      controller.addEntry('Test Başlık', 'Test İçerik', 'Mutlu', ['test']);
      expect(controller.entries.value.length, initialCount + 1);
      expect(controller.entries.value.first.title, 'Test Başlık');

      final addedId = controller.entries.value.first.id;
      controller.deleteEntry(addedId);
      expect(controller.entries.value.length, initialCount);

      // Takvimden gün seçme testi
      final pastDate = DateTime(2026, 10, 15);
      controller.setSelectedDate(pastDate);
      expect(controller.selectedDate.value.year, 2026);
      expect(controller.selectedDate.value.month, 10);
      expect(controller.selectedDate.value.day, 15);

      // Seçilen güne anı ekleme testi
      controller.addEntry('15 Ekim Anısı', 'O gün özeldi', 'Huzurlu', ['geçmiş'], pastDate);
      expect(controller.entries.value.first.createdAt.day, 15);

      controller.dispose();
    });
  });

  group('MoodTrackerController Tests', () {
    test('Duygu ekleme ve istatistik hesaplama doğru çalışır', () {
      final controller = MoodTrackerController();
      final initialCount = controller.moods.value.length;

      controller.addMood('Mutlu', 'Harika gün');
      expect(controller.moods.value.length, initialCount + 1);

      final counts = controller.getMoodCounts();
      expect(counts['Mutlu']! >= 1, true);

      final id = controller.moods.value.first.id;
      controller.deleteMood(id);
      expect(controller.moods.value.length, initialCount);

      controller.dispose();
    });
  });

  group('SettingsController Tests', () {
    test('Tema değiştirme işlevi beklendiği gibi çalışır', () {
      final controller = SettingsController();
      expect(controller.themeMode.value, ThemeMode.light);

      controller.toggleTheme();
      expect(controller.themeMode.value, ThemeMode.dark);

      controller.setThemeMode(ThemeMode.light);
      expect(controller.themeMode.value, ThemeMode.light);

      controller.dispose();
    });
  });

  group('Widget Tests', () {
    testWidgets('Uygulama açılır ve tablar arası geçiş yapılabilir', (tester) async {
      await tester.pumpWidget(const DijitalGunlukApp());
      await tester.pumpAndSettle();

      expect(find.text('Anı Defterim'), findsOneWidget);
      expect(find.text('Günlük'), findsOneWidget);
      expect(find.text('Duygular'), findsOneWidget);
      expect(find.text('Ayarlar'), findsOneWidget);

      // Ayarlar tabına tıkla
      await tester.tap(find.text('Ayarlar'));
      await tester.pumpAndSettle();

      expect(find.text('Görünüm Teması'), findsOneWidget);
      expect(find.text('Kağıt Dokusu'), findsOneWidget);
    });
  });
}
