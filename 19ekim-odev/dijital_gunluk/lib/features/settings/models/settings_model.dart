import 'package:flutter/material.dart';

@immutable
class AppSettings {
  final ThemeMode themeMode;
  final bool enableNotifications;
  final String authorName;

  const AppSettings({
    this.themeMode = ThemeMode.light,
    this.enableNotifications = true,
    this.authorName = 'Günlük Yazarı',
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? enableNotifications,
    String? authorName,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      authorName: authorName ?? this.authorName,
    );
  }
}
