class WaterLogEntry {
  final String id;
  final int amountMl;
  final DateTime timestamp;

  const WaterLogEntry({
    required this.id,
    required this.amountMl,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amountMl': amountMl,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory WaterLogEntry.fromJson(Map<String, dynamic> json) {
    return WaterLogEntry(
      id: json['id'] as String? ?? '',
      amountMl: json['amountMl'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class WaterTrackerState {
  final int baseGoalMl;
  final int workoutBonusMl;
  final int consumedMl;
  final List<WaterLogEntry> history;

  const WaterTrackerState({
    this.baseGoalMl = 2000,
    this.workoutBonusMl = 0,
    this.consumedMl = 0,
    this.history = const [],
  });

  int get totalTargetMl => baseGoalMl + workoutBonusMl;

  double get progressRatio {
    if (totalTargetMl <= 0) return 0.0;
    return (consumedMl / totalTargetMl).clamp(0.0, 1.0);
  }

  int get remainingMl {
    final diff = totalTargetMl - consumedMl;
    return diff > 0 ? diff : 0;
  }

  WaterTrackerState copyWith({
    int? baseGoalMl,
    int? workoutBonusMl,
    int? consumedMl,
    List<WaterLogEntry>? history,
  }) {
    return WaterTrackerState(
      baseGoalMl: baseGoalMl ?? this.baseGoalMl,
      workoutBonusMl: workoutBonusMl ?? this.workoutBonusMl,
      consumedMl: consumedMl ?? this.consumedMl,
      history: history ?? this.history,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baseGoalMl': baseGoalMl,
      'workoutBonusMl': workoutBonusMl,
      'consumedMl': consumedMl,
      'history': history.map((e) => e.toJson()).toList(),
    };
  }

  factory WaterTrackerState.fromJson(Map<String, dynamic> json) {
    final list = json['history'] as List<dynamic>? ?? [];
    return WaterTrackerState(
      baseGoalMl: json['baseGoalMl'] as int? ?? 2000,
      workoutBonusMl: json['workoutBonusMl'] as int? ?? 0,
      consumedMl: json['consumedMl'] as int? ?? 0,
      history: list
          .map((e) => WaterLogEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
