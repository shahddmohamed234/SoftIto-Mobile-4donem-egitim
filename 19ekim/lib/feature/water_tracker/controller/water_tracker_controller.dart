import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/water_intake_model.dart';

/// Su takibi durumunu ve yakılan kaloriye göre dinamik su ihtiyacını
/// Flutter çekirdek ChangeNotifier ile yöneten controller.
class WaterTrackerController extends ChangeNotifier {
  int _baseDailyGoalMl = 2500;
  int _burnedCalories = 0;
  final List<WaterIntakeModel> _intakes = [];

  WaterTrackerController({int? initialGoalMl}) {
    if (initialGoalMl != null && initialGoalMl > 0) {
      _baseDailyGoalMl = initialGoalMl;
    }
  }

  /// Temel günlük su hedefi (ml)
  int get baseDailyGoalMl => _baseDailyGoalMl;

  /// Yakılan kalori miktarı (kcal)
  int get burnedCalories => _burnedCalories;

  /// Yakılan kaloriye bağlı ek su ihtiyacı (1 kcal başına 1 ml ter/hidrasyon telafisi)
  int get extraWaterFromCaloriesMl => _burnedCalories;

  /// Dinamik toplam su hedefi (Temel Hedef + Kaloriden Gelen İhtiyaç)
  int get dynamicGoalMl => _baseDailyGoalMl + extraWaterFromCaloriesMl;

  /// Geriye dönük uyumluluk için günlük hedef
  int get dailyGoalMl => dynamicGoalMl;

  /// Değiştirilemez kayıt listesi
  UnmodifiableListView<WaterIntakeModel> get intakes =>
      UnmodifiableListView(_intakes);

  /// Günlük toplam içilen su (ml)
  int get totalIntakeMl {
    return _intakes.fold(0, (sum, item) => sum + item.amountMl);
  }

  /// Dinamik hedefe ulaşma oranı (0.0 - 1.0+)
  double get completionRatio {
    if (dynamicGoalMl <= 0) return 0.0;
    return (totalIntakeMl / dynamicGoalMl).clamp(0.0, 1.5);
  }

  /// Yüzdelik gösterim (ör. 75)
  int get completionPercentage {
    if (dynamicGoalMl <= 0) return 0;
    return ((totalIntakeMl / dynamicGoalMl) * 100).toInt();
  }

  /// Kalan su miktarı (ml)
  int get remainingMl {
    final remaining = dynamicGoalMl - totalIntakeMl;
    return remaining > 0 ? remaining : 0;
  }

  /// Egzersizden yakılan kaloriyi günceller ve hedefi dinamik olarak yeniler
  void updateBurnedCalories(int calories) {
    final validCalories = calories < 0 ? 0 : calories;
    if (_burnedCalories != validCalories) {
      _burnedCalories = validCalories;
      notifyListeners();
    }
  }

  /// Yeni su tüketimi ekler
  void addWater(int amountMl, {String label = 'Su'}) {
    if (amountMl <= 0) return;

    final entry = WaterIntakeModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      amountMl: amountMl,
      timestamp: DateTime.now(),
      label: label,
    );

    _intakes.insert(0, entry);
    notifyListeners();
  }

  /// Belirli bir kaydı siler
  void removeWater(String id) {
    _intakes.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  /// Günlük kaydı sıfırlar
  void resetDaily() {
    _intakes.clear();
    notifyListeners();
  }

  /// Temel hedefi günceller
  void setDailyGoal(int newGoalMl) {
    if (newGoalMl > 0 && newGoalMl != _baseDailyGoalMl) {
      _baseDailyGoalMl = newGoalMl;
      notifyListeners();
    }
  }
}
