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

class AppDarkColors {
  // Sakin Gece / Koyu Kömür Zemin
  static const Color background = Color(0xFF191A20);
  
  // Koyu Kart ve Panel Yüzeyleri
  static const Color cardColor = Color(0xFF23242D);
  static const Color surfaceMuted = Color(0xFF2C2E38);
  static const Color border = Color(0xFF373A47);
  
  // Yumuşak Adaçayı & Pudra Vurguları
  static const Color primary = Color(0xFFAEC4B2);
  static const Color streakHeart = Color(0xFFE8B6B4);
  static const Color lavender = Color(0xFFC7BCDB);
  
  // Açık Krem Metinler
  static const Color textLight = Color(0xFFEDE9E3);
  static const Color textMuted = Color(0xFFA6A4A0);
}

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
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
    indicatorColor: AppColors.primary.withAlpha(60),
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

final ThemeData darkAppTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppDarkColors.background,
  cardColor: AppDarkColors.cardColor,
  colorScheme: const ColorScheme.dark(
    primary: AppDarkColors.primary,
    secondary: AppDarkColors.lavender,
    tertiary: AppDarkColors.streakHeart,
    surface: AppDarkColors.background,
    onPrimary: Colors.black87,
    onSecondary: Colors.black87,
    onSurface: AppDarkColors.textLight,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppDarkColors.background,
    foregroundColor: AppDarkColors.textLight,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: AppDarkColors.textLight,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppDarkColors.cardColor,
    indicatorColor: AppDarkColors.primary.withAlpha(70),
    surfaceTintColor: Colors.transparent,
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const TextStyle(
          color: AppDarkColors.textLight,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        );
      }
      return const TextStyle(
        color: AppDarkColors.textMuted,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );
    }),
  ),
  cardTheme: CardThemeData(
    color: AppDarkColors.cardColor,
    elevation: 1,
    shadowColor: Colors.black.withAlpha(40),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppDarkColors.border, width: 0.8),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppDarkColors.primary,
      foregroundColor: Colors.black87,
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
      foregroundColor: AppDarkColors.textLight,
      side: const BorderSide(color: AppDarkColors.border, width: 1.2),
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
    fillColor: AppDarkColors.cardColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: const TextStyle(color: AppDarkColors.textMuted, fontSize: 14),
    labelStyle: const TextStyle(color: AppDarkColors.textLight, fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppDarkColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppDarkColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppDarkColors.primary, width: 1.5),
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: AppDarkColors.textLight, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(color: AppDarkColors.textLight, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(color: AppDarkColors.textLight, fontWeight: FontWeight.w700, fontSize: 22),
    headlineSmall: TextStyle(color: AppDarkColors.textLight, fontWeight: FontWeight.w600, fontSize: 18),
    titleLarge: TextStyle(color: AppDarkColors.textLight, fontWeight: FontWeight.w600, fontSize: 17),
    titleMedium: TextStyle(color: AppDarkColors.textLight, fontWeight: FontWeight.w500, fontSize: 15),
    bodyLarge: TextStyle(color: AppDarkColors.textLight, fontSize: 16),
    bodyMedium: TextStyle(color: AppDarkColors.textLight, fontSize: 14),
    bodySmall: TextStyle(color: AppDarkColors.textMuted, fontSize: 12),
  ),
);
