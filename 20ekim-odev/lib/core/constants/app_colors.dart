// Flutter malzeme tasarımı ve renk sınıflarını içeri aktarır
import 'package:flutter/material.dart';

/// AppColors: EasyRent uygulaması genelinde Material 3 çift tema standartlarına
/// uygun olarak kullanılan renk sabitleri paletidir.
class AppColors {
  // Sınıfın dışarıdan örneklenmesini (instance oluşturulmasını) engelleyen özel yapıcı metot
  AppColors._();

  // --- Ortak Renk Paleti (Mavi ve Kırmızı) ---
  // Açık temada ana renk (primary) olarak kullanılan ferah mavi tonu
  static const Color primaryBlue = Color(0xFF1E88E5);
  // Başlıklar ve kurumsal ögeler için kullanılan koyu mavi tonu
  static const Color deepBlue = Color(0xFF0D47A1);
  // Vurgular ve ikonlar için kullanılan açık mavi tonu
  static const Color accentBlue = Color(0xFF64B5F6);

  // Koyu temada ana vurgu rengi ve hata durumlarında kullanılan kırmızı tonu
  static const Color primaryRed = Color(0xFFD32F2F);
  // Koyu kırmızı tonu (hover veya basılı durumlar için)
  static const Color darkRed = Color(0xFFB71C1C);
  // Açık kırmızı tonu (hafif uyarılar ve vurgular için)
  static const Color accentRed = Color(0xFFEF5350);

  // --- Açık Tema Renkleri (Mavi Ağırlıklı Ferah Tasarım) ---
  // Açık temadaki arka plan rengi (göz yormayan açık gri/mavi)
  static const Color lightBackground = Color(0xFFF7F9FC);
  // Açık temada kart ve diyalogların yüzey rengi (saf beyaz)
  static const Color lightSurface = Colors.white;
  // Açık temada birincil metin rengi (koyu antrasit)
  static const Color lightTextPrimary = Color(0xFF1A1C1E);
  // Açık temada ikincil metin ve alt başlık rengi (orta gri)
  static const Color lightTextSecondary = Color(0xFF5A6065);
  // Açık temadaki kart kenarlık ve ayraç çizgisi rengi
  static const Color lightCardBorder = Color(0xFFE2E8F0);

  // --- Koyu Tema Renkleri (Kırmızı Vurgulu ve Koyu Arka Plan) ---
  // Koyu temadaki ana sayfa arka plan rengi (gece siyahı)
  static const Color darkBackground = Color(0xFF121417);
  // Koyu temadaki yüzey rengi (gece mavimsi koyu gri)
  static const Color darkSurface = Color(0xFF1A1D21);
  // Koyu temadaki kart ve diyalog gövde rengi
  static const Color darkCard = Color(0xFF22272E);
  // Koyu temada birincil metin rengi (kırık beyaz)
  static const Color darkTextPrimary = Color(0xFFF0F6FC);
  // Koyu temada ikincil metin ve açıklama rengi (açık gri)
  static const Color darkTextSecondary = Color(0xFF8B949E);
  // Koyu temadaki kart kenarlık ve sınır çizgisi rengi
  static const Color darkCardBorder = Color(0xFF30363D);

  // --- Durum ve İşlem Renkleri ---
  // Başarılı işlemler ve müsait durumlar için yeşil renk
  static const Color success = Color(0xFF2E7D32);
  // Bekleyen işlemler ve uyarı bildirimleri için turuncu renk
  static const Color warning = Color(0xFFED6C02);
  // Bilgilendirme metinleri ve ipuçları için açık mavi renk
  static const Color info = Color(0xFF0288D1);
}
