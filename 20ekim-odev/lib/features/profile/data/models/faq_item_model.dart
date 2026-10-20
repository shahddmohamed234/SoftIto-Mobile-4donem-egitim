// Değişmezlik (immutable) anotasyonu için Flutter temel kütüphanesini içeri aktarır
import 'package:flutter/foundation.dart';

/// FaqItemModel: Sıkça sorulan soru ve kiralama kuralı maddesini temsil eden veri modelidir.
@immutable
class FaqItemModel {
  // Soru veya kural başlığı (Örn: Erken Teslimat Kuralı)
  final String question;

  // Soruya ait detaylı açıklama, kural veya sözleşme maddesi metni
  final String answer;

  // FaqItemModel sabit kurucu metodu
  const FaqItemModel({
    // Soru başlığı zorunludur
    required this.question,
    // Cevap metni zorunludur
    required this.answer,
  });
}
