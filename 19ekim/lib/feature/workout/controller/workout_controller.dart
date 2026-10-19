import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/workout_model.dart';

/// Egzersiz ve yakılan kalori durumunu yöneten yerel ChangeNotifier controller.
class WorkoutController extends ChangeNotifier {
  int _dailyCalorieGoal = 600;
  final List<WorkoutModel> _workouts = [];

  WorkoutController({int? initialCalorieGoal}) {
    if (initialCalorieGoal != null && initialCalorieGoal > 0) {
      _dailyCalorieGoal = initialCalorieGoal;
    }
  }

  int get dailyCalorieGoal => _dailyCalorieGoal;

  UnmodifiableListView<WorkoutModel> get workouts =>
      UnmodifiableListView(_workouts);

  /// Toplam yakılan kalori (kcal)
  int get totalCaloriesBurned {
    return _workouts.fold(0, (sum, item) => sum + item.caloriesBurned);
  }

  /// Toplam egzersiz süresi (dakika)
  int get totalDurationMinutes {
    return _workouts.fold(0, (sum, item) => sum + item.durationMinutes);
  }

  /// Hedefe ulaşma oranı (0.0 - 1.0+)
  double get completionRatio {
    if (_dailyCalorieGoal <= 0) return 0.0;
    return (totalCaloriesBurned / _dailyCalorieGoal).clamp(0.0, 1.5);
  }

  /// Yüzdelik gösterim
  int get completionPercentage {
    if (_dailyCalorieGoal <= 0) return 0;
    return ((totalCaloriesBurned / _dailyCalorieGoal) * 100).toInt();
  }

  /// Yeni egzersiz seansı ekler
  void addWorkout({
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
  }) {
    if (durationMinutes <= 0 || caloriesBurned <= 0) return;

    final workout = WorkoutModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      timestamp: DateTime.now(),
    );

    _workouts.insert(0, workout);
    notifyListeners();
  }

  /// Egzersiz seansını siler
  void removeWorkout(String id) {
    _workouts.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  /// Günlük egzersizleri sıfırlar
  void resetDaily() {
    _workouts.clear();
    notifyListeners();
  }

  /// Günlük kalori hedefini günceller
  void setDailyCalorieGoal(int newGoal) {
    if (newGoal > 0 && newGoal != _dailyCalorieGoal) {
      _dailyCalorieGoal = newGoal;
      notifyListeners();
    }
  }
}
