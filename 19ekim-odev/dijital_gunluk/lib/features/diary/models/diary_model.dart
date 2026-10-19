import 'package:flutter/foundation.dart';

@immutable
class DiaryEntry {
  final String id;
  final String title;
  final String content;
  final String mood;
  final List<String> tags;
  final DateTime createdAt;

  const DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.mood,
    this.tags = const [],
    required this.createdAt,
  });

  DiaryEntry copyWith({
    String? id,
    String? title,
    String? content,
    String? mood,
    List<String>? tags,
    DateTime? createdAt,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      mood: json['mood'] as String? ?? 'Mutlu',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'mood': mood,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
