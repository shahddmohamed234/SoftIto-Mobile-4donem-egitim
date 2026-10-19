class WorkoutItem {
  final String id;
  final String name;
  final int durationMinutes;
  final int burnedCalories;
  final int recommendedWaterMl;
  final DateTime timestamp;
  final String iconType;

  const WorkoutItem({
    required this.id,
    required this.name,
    required this.durationMinutes,
    required this.burnedCalories,
    required this.recommendedWaterMl,
    required this.timestamp,
    required this.iconType,
  });

  WorkoutItem copyWith({
    String? id,
    String? name,
    int? durationMinutes,
    int? burnedCalories,
    int? recommendedWaterMl,
    DateTime? timestamp,
    String? iconType,
  }) {
    return WorkoutItem(
      id: id ?? this.id,
      name: name ?? this.name,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      burnedCalories: burnedCalories ?? this.burnedCalories,
      recommendedWaterMl: recommendedWaterMl ?? this.recommendedWaterMl,
      timestamp: timestamp ?? this.timestamp,
      iconType: iconType ?? this.iconType,
    );
  }

  factory WorkoutItem.fromJson(Map<String, dynamic> json) {
    return WorkoutItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      burnedCalories: json['burnedCalories'] as int? ?? 0,
      recommendedWaterMl: json['recommendedWaterMl'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      iconType: json['iconType'] as String? ?? 'gym',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'durationMinutes': durationMinutes,
      'burnedCalories': burnedCalories,
      'recommendedWaterMl': recommendedWaterMl,
      'timestamp': timestamp.toIso8601String(),
      'iconType': iconType,
    };
  }
}
