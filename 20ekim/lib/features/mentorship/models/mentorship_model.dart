import 'package:flutter/foundation.dart';

@immutable
class MentorSlot {
  final String id;
  final String date; // Örn: '22 Ekim 2026, Perşembe'
  final String time; // Örn: '14:00 - 15:00'
  final bool isAvailable; // true: Boş, false: Dolu

  const MentorSlot({
    required this.id,
    required this.date,
    required this.time,
    required this.isAvailable,
  });

  factory MentorSlot.fromJson(Map<String, dynamic> json) {
    return MentorSlot(
      id: json['id'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      isAvailable: json['isAvailable'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'isAvailable': isAvailable,
    };
  }
}

@immutable
class MentorProfile {
  final String id;
  final String name;
  final String title;
  final String expertise;
  final double rating;
  final int sessionCount;
  final bool isAvailable;
  final List<MentorSlot> slots;
  final bool isSmsSubscribed;

  const MentorProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.expertise,
    required this.rating,
    required this.sessionCount,
    required this.isAvailable,
    required this.slots,
    this.isSmsSubscribed = false,
  });

  factory MentorProfile.fromJson(Map<String, dynamic> json) {
    return MentorProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      expertise: json['expertise'] as String,
      rating: (json['rating'] as num).toDouble(),
      sessionCount: json['sessionCount'] as int,
      isAvailable: json['isAvailable'] as bool,
      slots: (json['slots'] as List<dynamic>?)
              ?.map((e) => MentorSlot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isSmsSubscribed: json['isSmsSubscribed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'expertise': expertise,
      'rating': rating,
      'sessionCount': sessionCount,
      'isAvailable': isAvailable,
      'slots': slots.map((e) => e.toJson()).toList(),
      'isSmsSubscribed': isSmsSubscribed,
    };
  }

  MentorProfile copyWith({
    String? id,
    String? name,
    String? title,
    String? expertise,
    double? rating,
    int? sessionCount,
    bool? isAvailable,
    List<MentorSlot>? slots,
    bool? isSmsSubscribed,
  }) {
    return MentorProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      expertise: expertise ?? this.expertise,
      rating: rating ?? this.rating,
      sessionCount: sessionCount ?? this.sessionCount,
      isAvailable: isAvailable ?? this.isAvailable,
      slots: slots ?? this.slots,
      isSmsSubscribed: isSmsSubscribed ?? this.isSmsSubscribed,
    );
  }
}
