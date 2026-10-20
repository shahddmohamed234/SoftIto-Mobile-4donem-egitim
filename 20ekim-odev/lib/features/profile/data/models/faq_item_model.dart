import 'package:flutter/foundation.dart';

/// FaqItemModel: Sıkça sorulan soru ve kiralama kuralı maddesini temsil eder.
@immutable
class FaqItemModel {
  // Soru başlığı
  final String question;
  // Detaylı kural ve cevap metni
  final String answer;

  const FaqItemModel({
    required this.question,
    required this.answer,
  });
}
