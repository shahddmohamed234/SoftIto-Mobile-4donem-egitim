import 'package:flutter/foundation.dart';

@immutable
class FundingOpportunity {
  final String id;
  final String provider;
  final String title;
  final double maxAmount;
  final String deadline;
  final String category; // 'Hibe', 'Tohum Yatırım', 'Faizsiz Destek'
  final bool isApplied;
  final String status; // 'Başvurulmadı', 'İnceleniyor', 'Onaylandı', 'Reddedildi'
  final String? rejectionReason;
  final List<String> criteria;

  const FundingOpportunity({
    required this.id,
    required this.provider,
    required this.title,
    required this.maxAmount,
    required this.deadline,
    required this.category,
    this.isApplied = false,
    this.status = 'Başvurulmadı',
    this.rejectionReason,
    this.criteria = const [
      'Anonim veya Limited Şirket statüsünde olmak',
      'Hazır ve test edilmiş MVP / Prototip bulunması',
      'Sistemde onaylanmış en az bir iş planına sahip olmak',
      'Sektörde 2 yılı aşmamış erken aşama girişim olmak',
    ],
  });

  factory FundingOpportunity.fromJson(Map<String, dynamic> json) {
    return FundingOpportunity(
      id: json['id'] as String,
      provider: json['provider'] as String,
      title: json['title'] as String,
      maxAmount: (json['maxAmount'] as num).toDouble(),
      deadline: json['deadline'] as String,
      category: json['category'] as String,
      isApplied: json['isApplied'] as bool? ?? false,
      status: json['status'] as String? ?? 'Başvurulmadı',
      rejectionReason: json['rejectionReason'] as String?,
      criteria: (json['criteria'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider': provider,
      'title': title,
      'maxAmount': maxAmount,
      'deadline': deadline,
      'category': category,
      'isApplied': isApplied,
      'status': status,
      'rejectionReason': rejectionReason,
      'criteria': criteria,
    };
  }

  FundingOpportunity copyWith({
    String? id,
    String? provider,
    String? title,
    double? maxAmount,
    String? deadline,
    String? category,
    bool? isApplied,
    String? status,
    String? rejectionReason,
    List<String>? criteria,
  }) {
    return FundingOpportunity(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      title: title ?? this.title,
      maxAmount: maxAmount ?? this.maxAmount,
      deadline: deadline ?? this.deadline,
      category: category ?? this.category,
      isApplied: isApplied ?? this.isApplied,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      criteria: criteria ?? this.criteria,
    );
  }
}
