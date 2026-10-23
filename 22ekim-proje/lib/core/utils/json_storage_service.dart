import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../constants/app_constants.dart';

class JsonStorageService {
  static JsonStorageService? _instance;
  static JsonStorageService get instance {
    _instance ??= JsonStorageService._internal();
    return _instance!;
  }

  JsonStorageService._internal();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  // Initializing default JSON data if files do not exist
  Future<void> initializeDefaultsIfNeeded() async {
    try {
      await _initUserJson();
      await _initHabitsJson();
      await _initStreaksJson();
      await _initBadgesAndCouponsJson();
    } catch (e) {
      debugPrint('Error initializing local JSON files: $e');
    }
  }

  Future<void> _initUserJson() async {
    final file = await _getFile('user.json');
    final exists = await file.exists();
    if (!exists) {
      final defaultUser = {
        'id': 'user_1',
        'name': 'Gezgin',
        'surname': 'Pati',
        'email': 'pati@goon.com',
        'birthDate': '2000-01-01',
        'mascotId': 'pamuk',
        'language': 'TR',
        'theme': 'light',
        'isLoggedIn': false,
      };
      await file.writeAsString(jsonEncode(defaultUser));
    }
  }

  Future<void> _initHabitsJson() async {
    final file = await _getFile('habits.json');
    final exists = await file.exists();
    if (!exists) {
      await file.writeAsString(jsonEncode([]));
    }
  }

  Future<void> _initStreaksJson() async {
    final file = await _getFile('streaks.json');
    final exists = await file.exists();
    if (!exists) {
      final now = DateTime.now();
      // Add streak dates for recent days of the current month
      final List<String> dates = [];
      for (int i = 1; i <= now.day; i++) {
        if (i % 5 != 0) {
          final dayStr = i.toString().padLeft(2, '0');
          final monthStr = now.month.toString().padLeft(2, '0');
          dates.add('${now.year}-$monthStr-$dayStr');
        }
      }
      await file.writeAsString(jsonEncode({'streakDates': dates, 'currentStreak': 4}));
    }
  }

  Future<void> _initBadgesAndCouponsJson() async {
    final file = await _getFile('badges_and_coupons.json');
    final exists = await file.exists();
    if (!exists) {
      final combined = [
        ...AppConstants.defaultBadges,
        ...AppConstants.defaultCoupons,
      ];
      await file.writeAsString(jsonEncode(combined));
    }
  }

  // --- USER API ---
  Future<Map<String, dynamic>> readUser() async {
    try {
      final file = await _getFile('user.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        return jsonDecode(content) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Error reading user.json: $e');
    }
    return {};
  }

  Future<void> writeUser(Map<String, dynamic> user) async {
    try {
      final file = await _getFile('user.json');
      await file.writeAsString(jsonEncode(user));
    } catch (e) {
      debugPrint('Error writing user.json: $e');
    }
  }

  // --- HABITS API ---
  Future<List<Map<String, dynamic>>> readHabits() async {
    try {
      final file = await _getFile('habits.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> list = jsonDecode(content);
        return list.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      debugPrint('Error reading habits.json: $e');
    }
    return [];
  }

  Future<void> writeHabits(List<Map<String, dynamic>> habits) async {
    try {
      final file = await _getFile('habits.json');
      await file.writeAsString(jsonEncode(habits));
    } catch (e) {
      debugPrint('Error writing habits.json: $e');
    }
  }

  // --- STREAKS API ---
  Future<Map<String, dynamic>> readStreaks() async {
    try {
      final file = await _getFile('streaks.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        return jsonDecode(content) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Error reading streaks.json: $e');
    }
    return {'streakDates': <String>[], 'currentStreak': 0};
  }

  Future<void> writeStreaks(Map<String, dynamic> streaks) async {
    try {
      final file = await _getFile('streaks.json');
      await file.writeAsString(jsonEncode(streaks));
    } catch (e) {
      debugPrint('Error writing streaks.json: $e');
    }
  }

  // --- BADGES AND COUPONS API ---
  Future<List<Map<String, dynamic>>> readBadgesAndCoupons() async {
    try {
      final file = await _getFile('badges_and_coupons.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> list = jsonDecode(content);
        return list.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      debugPrint('Error reading badges_and_coupons.json: $e');
    }
    return [];
  }

  Future<void> writeBadgesAndCoupons(List<Map<String, dynamic>> items) async {
    try {
      final file = await _getFile('badges_and_coupons.json');
      await file.writeAsString(jsonEncode(items));
    } catch (e) {
      debugPrint('Error writing badges_and_coupons.json: $e');
    }
  }
}
