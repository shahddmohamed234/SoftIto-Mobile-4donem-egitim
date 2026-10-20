import 'package:flutter/material.dart';

/// AppColors: EasyRent uygulaması genelinde Material 3 çift tema standartlarına
/// uygun olarak kullanılan renk sabitleri paletidir.
class AppColors {
  // --- Ortak Renk Paleti (Mavi ve Kırmızı) ---
  // Açık temada ana renk olarak kullanılan ferah mavi
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color deepBlue = Color(0xFF0D47A1);
  static const Color accentBlue = Color(0xFF64B5F6);

  // Koyu temada vurgu rengi ve hata durumlarında kullanılan kırmızı
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color darkRed = Color(0xFFB71C1C);
  static const Color accentRed = Color(0xFFEF5350);

  // --- Açık Tema Renkleri (Mavi Ağırlıklı Ferah Tasarım) ---
  static const Color lightBackground = Color(0xFFF7F9FC);
  static const Color lightSurface = Colors.white;
  static const Color lightTextPrimary = Color(0xFF1A1C1E);
  static const Color lightTextSecondary = Color(0xFF5A6065);
  static const Color lightCardBorder = Color(0xFFE2E8F0);

  // --- Koyu Tema Renkleri (Kırmızı Vurgulu ve Koyu Arka Plan) ---
  static const Color darkBackground = Color(0xFF121417);
  static const Color darkSurface = Color(0xFF1A1D21);
  static const Color darkCard = Color(0xFF22272E);
  static const Color darkTextPrimary = Color(0xFFF0F6FC);
  static const Color darkTextSecondary = Color(0xFF8B949E);
  static const Color darkCardBorder = Color(0xFF30363D);

  // --- Durum ve İşlem Renkleri ---
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFED6C02);
  static const Color info = Color(0xFF0288D1);
}
