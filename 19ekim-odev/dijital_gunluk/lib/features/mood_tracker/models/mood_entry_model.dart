import 'package:flutter/foundation.dart';

@immutable
class MoodEntry {
  final String id;
  final String mood; // 'Mutlu', 'Huzurlu', 'Enerjik', 'Düşünceli', 'Üzgün', 'Yorgun'
  final String note;
  final DateTime timestamp;

  const MoodEntry({
    required this.id,
    required this.mood,
    required this.note,
    required this.timestamp,
  });

  MoodEntry copyWith({
    String? id,
    String? mood,
    String? note,
    DateTime? timestamp,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      note: note ?? this.note,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'] as String? ?? '',
      mood: json['mood'] as String? ?? 'Mutlu',
      note: json['note'] as String? ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mood': mood,
      'note': note,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
