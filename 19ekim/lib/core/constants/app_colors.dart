import 'package:flutter/material.dart';

/// Dark Obsidian & Neon gece spor salonu renk paleti.
class AppColors {
  const AppColors._();

  // Zemin & Yüzey (Dark Obsidian)
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF161B22);
  static const Color surfaceVariant = Color(0xFF21262D);
  static const Color border = Color(0xFF30363D);

  // Neon Vurgu Renkleri
  static const Color neonCyan = Color(0xFF00F0FF); // Su takibi vurgusu
  static const Color neonLime = Color(0xFF39FF14); // Egzersiz & Enerji vurgusu
  static const Color neonOrange = Color(0xFFFF6D00); // Kalori & Kardiyo vurgusu
  static const Color neonPurple = Color(0xFFBC13FE); // Hedef & Başarı vurgusu

  // Metin Renkleri
  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF6E7681);

  // Durum Renkleri
  static const Color success = Color(0xFF2EA043);
  static const Color error = Color(0xFFF85149);
}
