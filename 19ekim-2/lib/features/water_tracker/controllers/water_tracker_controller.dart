import 'package:flutter/foundation.dart';
import '../models/water_tracker_model.dart';

class WaterTrackerController {
  final ValueNotifier<WaterTrackerState> state = ValueNotifier<WaterTrackerState>(
    const WaterTrackerState(),
  );

  void addWater(int amountMl) {
    if (amountMl <= 0) return;
    final entry = WaterLogEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      amountMl: amountMl,
      timestamp: DateTime.now(),
    );

    final current = state.value;
    state.value = current.copyWith(
      consumedMl: current.consumedMl + amountMl,
      history: [entry, ...current.history],
    );
  }

  void removeEntry(String id) {
    final current = state.value;
    final entry = current.history.firstWhere(
      (e) => e.id == id,
      orElse: () => WaterLogEntry(id: '', amountMl: 0, timestamp: DateTime.now()),
    );
    if (entry.id.isEmpty) return;

    final updatedHistory = current.history.where((e) => e.id != id).toList();
    final updatedConsumed = (current.consumedMl - entry.amountMl).clamp(0, 99999);

    state.value = current.copyWith(
      consumedMl: updatedConsumed,
      history: updatedHistory,
    );
  }

  void updateWorkoutBonus(int bonusMl) {
    final current = state.value;
    if (current.workoutBonusMl == bonusMl) return;
    state.value = current.copyWith(workoutBonusMl: bonusMl);
  }

  void setBaseGoal(int goalMl) {
    if (goalMl < 500) return;
    final current = state.value;
    state.value = current.copyWith(baseGoalMl: goalMl);
  }

  void resetWater() {
    final current = state.value;
    state.value = current.copyWith(
      consumedMl: 0,
      history: [],
    );
  }

  void dispose() {
    state.dispose();
  }
}
