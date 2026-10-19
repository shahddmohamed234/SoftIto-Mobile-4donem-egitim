import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/feature/water_tracker/water_tracker.dart';
import 'package:susadim/feature/workout/workout.dart';
import 'package:susadim/main.dart';

void main() {
  group('Uygulama Widget Testleri', () {
    testWidgets('SusadimApp başarıyla yüklenir ve sekmeleri gösterir',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SusadimApp());

      // Başlık ve alt gezinme butonlarının varlığını doğrula
      expect(find.text('Susadım - Su Takibi'), findsOneWidget);
      expect(find.text('Su Takibi'), findsOneWidget);
      expect(find.text('Egzersiz'), findsOneWidget);
    });
  });

  group('WaterTrackerController Birim Testleri', () {
    test('Su ekleme ve sıfırlama doğru çalışmalı', () {
      final controller = WaterTrackerController(initialGoalMl: 2000);

      expect(controller.totalIntakeMl, 0);
      expect(controller.completionPercentage, 0);

      controller.addWater(250, label: 'Bardak');
      expect(controller.totalIntakeMl, 250);
      expect(controller.intakes.length, 1);

      controller.addWater(500, label: 'Matara');
      expect(controller.totalIntakeMl, 750);
      expect(controller.intakes.length, 2);

      controller.resetDaily();
      expect(controller.totalIntakeMl, 0);
      expect(controller.intakes.isEmpty, true);

      controller.dispose();
    });

    test('Yakılan kaloriye göre dinamik su ihtiyacı doğru hesaplanmalı', () {
      final controller = WaterTrackerController(initialGoalMl: 2000);

      // Başlangıçta ek kalori yok
      expect(controller.baseDailyGoalMl, 2000);
      expect(controller.dynamicGoalMl, 2000);
      expect(controller.extraWaterFromCaloriesMl, 0);

      // 400 kcal yakıldığında +400 ml ek su hedeflenmeli
      controller.updateBurnedCalories(400);
      expect(controller.burnedCalories, 400);
      expect(controller.extraWaterFromCaloriesMl, 400);
      expect(controller.dynamicGoalMl, 2400);

      // 1200 ml su içildiğinde %50 tamamlanmalı (1200 / 2400)
      controller.addWater(1200, label: 'Şişe');
      expect(controller.completionPercentage, 50);

      controller.dispose();
    });
  });

  group('WorkoutController Birim Testleri', () {
    test('Egzersiz ekleme ve kalori hesabı doğru çalışmalı', () {
      final controller = WorkoutController(initialCalorieGoal: 500);

      expect(controller.totalCaloriesBurned, 0);
      expect(controller.totalDurationMinutes, 0);

      controller.addWorkout(
        title: 'Koşu',
        durationMinutes: 30,
        caloriesBurned: 250,
      );

      expect(controller.totalCaloriesBurned, 250);
      expect(controller.totalDurationMinutes, 30);
      expect(controller.completionPercentage, 50);

      controller.dispose();
    });
  });
}
