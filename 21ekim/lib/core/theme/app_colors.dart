import 'package:flutter/material.dart';

/// Full Concentrate uygulamasına ait renk paleti
/// 
/// Tasarım kuralı gereğince yeşil gibi dikkat dağıtıcı renkler kullanılmamış,
/// bordo, gül kurusu, pudra ve mürdüm gibi gözü yormayan tonlar seçilmiştir.
class AppColors {
  // Çalışma ve Odaklanma Modu Ana Rengi: Koyu Bordo
  static const Color burgundy = Color(0xFF721C24);
  static const Color darkBurgundy = Color(0xFF800020);

  // İkincil Renk: Gül Kurusu / Koyu Pembe
  static const Color roseDust = Color(0xFFB56576);

  // Mola ve Rahatlama Rengi: Yumuşak Pembe
  static const Color softPink = Color(0xFFF5CAC3);

  // Açık Tema Genel Arka Planı: Açık Pudra
  static const Color lightPowder = Color(0xFFF8EDEB);

  // Ana Metinler ve Başlıklar: Koyu Antrasit
  static const Color darkAnthracite = Color(0xFF2D2327);

  // Başlamadan Önceki Bilgilendirme Rengi: Sıcak Sarı
  static const Color warmYellow = Color(0xFFE9C46A);

  // Seans İhlali ve Uygulamadan Çıkış Uyarısı: İhlal Kırmızısı
  static const Color violationRed = Color(0xFFE63946);

  // Karanlık Mod (Dark Mode) Ana Arka Planı: Koyu Mürdüm / Gri
  static const Color darkPlum = Color(0xFF1A1114);

  // Karanlık Mod Vurgu ve Sayaç Rengi: Pastel Pembe
  static const Color pastelPink = Color(0xFFF4ACB7);

  // Kart zeminleri ve nötr yüzeyler
  static const Color white = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF271A20);
  static const Color subtleDivider = Color(0xFFE0D0D3);
}
