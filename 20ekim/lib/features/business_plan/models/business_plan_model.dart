import 'package:flutter/foundation.dart';

@immutable
class BusinessPlanItem {
  final String id;
  final String title;
  final String industry;
  final String targetMarket;
  final double budget;
  final String status; // 'Taslak', 'İncelemede', 'Onaylandı', 'Revize İsteniyor'
  final DateTime createdAt;

  const BusinessPlanItem({
    required this.id,
    required this.title,
    required this.industry,
    required this.targetMarket,
    required this.budget,
    required this.status,
    required this.createdAt,
  });

  factory BusinessPlanItem.fromJson(Map<String, dynamic> json) {
    return BusinessPlanItem(
      id: json['id'] as String,
      title: json['title'] as String,
      industry: json['industry'] as String,
      targetMarket: json['targetMarket'] as String,
      budget: (json['budget'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'industry': industry,
      'targetMarket': targetMarket,
      'budget': budget,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  BusinessPlanItem copyWith({
    String? id,
    String? title,
    String? industry,
    String? targetMarket,
    double? budget,
    String? status,
    DateTime? createdAt,
  }) {
    return BusinessPlanItem(
      id: id ?? this.id,
      title: title ?? this.title,
      industry: industry ?? this.industry,
      targetMarket: targetMarket ?? this.targetMarket,
      budget: budget ?? this.budget,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
