import 'package:flutter/foundation.dart';

@immutable
class LegalRequest {
  final String id;
  final String topic;
  final String details;
  final String lawyerAssigned;
  final String status; // 'İnceleniyor', 'Avukat Atandı', 'Tamamlandı'
  final DateTime date;

  const LegalRequest({
    required this.id,
    required this.topic,
    required this.details,
    required this.lawyerAssigned,
    required this.status,
    required this.date,
  });

  factory LegalRequest.fromJson(Map<String, dynamic> json) {
    return LegalRequest(
      id: json['id'] as String,
      topic: json['topic'] as String,
      details: json['details'] as String,
      lawyerAssigned: json['lawyerAssigned'] as String,
      status: json['status'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic': topic,
      'details': details,
      'lawyerAssigned': lawyerAssigned,
      'status': status,
      'date': date.toIso8601String(),
    };
  }

  LegalRequest copyWith({
    String? id,
    String? topic,
    String? details,
    String? lawyerAssigned,
    String? status,
    DateTime? date,
  }) {
    return LegalRequest(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      details: details ?? this.details,
      lawyerAssigned: lawyerAssigned ?? this.lawyerAssigned,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }
}
