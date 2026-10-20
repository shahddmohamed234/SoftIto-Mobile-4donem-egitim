import 'package:flutter/material.dart';

class ThemeController {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  final ValueNotifier<ThemeMode> _themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
  ValueNotifier<ThemeMode> get themeMode => _themeMode;

  bool get isDarkMode => _themeMode.value == ThemeMode.dark;

  void toggleTheme() {
    _themeMode.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
  }

  void setTheme(ThemeMode mode) {
    _themeMode.value = mode;
  }

  void dispose() {
    _themeMode.dispose();
  }
}
