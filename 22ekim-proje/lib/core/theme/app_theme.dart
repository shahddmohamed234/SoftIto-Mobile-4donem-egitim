import 'package:flutter/material.dart';

class AppColors {
  // Sıcak Kum / Krem (Zemin)
  static const Color background = Color(0xFFF9F6F0);
  
  // Adaçayı Yeşili (Ana Vurgu - Butonlar, Progress barlar)
  static const Color primary = Color(0xFF9DB2A1);
  
  // Pudra / Gül Kurusu (Streak Kalpleri)
  static const Color streakHeart = Color(0xFFDDA7A5);
  
  // Mat Lavanta (Rozet ve Kuponlar)
  static const Color lavender = Color(0xFFB5A8CB);
  
  // Koyu Antrasit (Metinler)
  static const Color textDark = Color(0xFF3A3A3A);
  
  // Beyaz ve Açık Kart Renkleri
  static const Color cardColor = Colors.white;
  static const Color surfaceMuted = Color(0xFFF1EDE6);
  static const Color border = Color(0xFFE4DFD6);
}

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.background,
  cardColor: AppColors.cardColor,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.lavender,
    tertiary: AppColors.streakHeart,
    surface: AppColors.background,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.textDark,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.textDark,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: AppColors.textDark,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.white,
    indicatorColor: AppColors.primary.withAlpha(50),
    surfaceTintColor: Colors.transparent,
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const TextStyle(
          color: AppColors.textDark,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        );
      }
      return const TextStyle(
        color: Colors.grey,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );
    }),
  ),
  cardTheme: CardThemeData(
    color: AppColors.cardColor,
    elevation: 1,
    shadowColor: Colors.black.withAlpha(15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.border, width: 0.8),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      textStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.textDark,
      side: const BorderSide(color: AppColors.border, width: 1.2),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      textStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
    labelStyle: const TextStyle(color: AppColors.textDark, fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700, fontSize: 22),
    headlineSmall: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600, fontSize: 18),
    titleLarge: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600, fontSize: 17),
    titleMedium: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500, fontSize: 15),
    bodyLarge: TextStyle(color: AppColors.textDark, fontSize: 16),
    bodyMedium: TextStyle(color: AppColors.textDark, fontSize: 14),
    bodySmall: TextStyle(color: Colors.black54, fontSize: 12),
  ),
);
