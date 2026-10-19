import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Dark Obsidian Paleti
  static const Color darkBackground = Color(0xFF0D0F14);
  static const Color darkSurface = Color(0xFF161A23);
  static const Color darkCard = Color(0xFF1E2330);
  static const Color darkCardBorder = Color(0xFF2A3245);

  // Light Gym Paleti
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardBorder = Color(0xFFE2E8F0);

  // Geriye dönük uyumluluk için varsayılanlar (Dark)
  static const Color background = darkBackground;
  static const Color surface = darkSurface;
  static const Color card = darkCard;
  static const Color cardBorder = darkCardBorder;

  // Neon & Vurgulu Renkler
  static const Color neonCyan = Color(0xFF00F0FF);
  static const Color lightPrimary = Color(0xFF0284C7); // Açık modda okunabilir canlı mavi
  static const Color neonLime = Color(0xFF39FF14);
  static const Color electricBlue = Color(0xFF0077FE);
  static const Color calorieOrange = Color(0xFFFF6D00);
  static const Color danger = Color(0xFFFF3366);

  // Koyu Metin Renkleri
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Açık Metin Renkleri
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Gradyanlar
  static const LinearGradient waterGradient = LinearGradient(
    colors: [neonCyan, electricBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient fireGradient = LinearGradient(
    colors: [calorieOrange, Color(0xFFFF3D00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient energyGradient = LinearGradient(
    colors: [neonLime, Color(0xFF00E676)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
