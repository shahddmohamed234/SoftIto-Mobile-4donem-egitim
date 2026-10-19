import 'package:flutter/foundation.dart';
import '../models/workout_model.dart';

class WorkoutController {
  final ValueNotifier<List<WorkoutItem>> workouts = ValueNotifier<List<WorkoutItem>>([]);

  int get totalBurnedCalories {
    return workouts.value.fold<int>(0, (sum, item) => sum + item.burnedCalories);
  }

  int get totalRecommendedWaterMl {
    return workouts.value.fold<int>(0, (sum, item) => sum + item.recommendedWaterMl);
  }

  void addWorkout({
    required String name,
    required int durationMinutes,
    required int burnedCalories,
    String iconType = 'fitness',
  }) {
    // Yakılan kaloriye ve süreye göre telafi su miktarı hesabı:
    // Her 100 kcal için ~150 ml + her 10 dk için ~50 ml terleme telafisi
    final int waterBonus = ((burnedCalories * 1.5) + (durationMinutes * 5)).round();

    final newItem = WorkoutItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      durationMinutes: durationMinutes,
      burnedCalories: burnedCalories,
      recommendedWaterMl: waterBonus,
      timestamp: DateTime.now(),
      iconType: iconType,
    );

    workouts.value = [newItem, ...workouts.value];
  }

  void removeWorkout(String id) {
    workouts.value = workouts.value.where((item) => item.id != id).toList();
  }

  void resetWorkouts() {
    workouts.value = [];
  }

  void dispose() {
    workouts.dispose();
  }
}
