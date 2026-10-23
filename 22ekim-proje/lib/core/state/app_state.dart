import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../utils/json_storage_service.dart';
import '../utils/translation_service.dart';

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  AppState._internal();

  final JsonStorageService _storage = JsonStorageService.instance;

  // User state
  Map<String, dynamic> _user = {};
  bool _isLoggedIn = false;
  String _selectedMascotId = 'pamuk';

  // Preferences
  String _language = 'TR';
  ThemeMode _themeMode = ThemeMode.light;

  // Habits state
  List<Map<String, dynamic>> _habits = [];

  // Streak state
  List<String> _streakDates = [];
  int _currentStreak = 0;

  // Badges and coupons state
  List<Map<String, dynamic>> _badgesAndCoupons = [];

  // Getters
  Map<String, dynamic> get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  String get selectedMascotId => _selectedMascotId;
  String get language => _language;
  ThemeMode get themeMode => _themeMode;
  String get themeName => _themeMode == ThemeMode.dark ? 'dark' : 'light';
  List<Map<String, dynamic>> get habits => List.unmodifiable(_habits);
  List<String> get streakDates => List.unmodifiable(_streakDates);
  int get currentStreak => _currentStreak;
  List<Map<String, dynamic>> get badgesAndCoupons => List.unmodifiable(_badgesAndCoupons);

  CatMascot get selectedMascot {
    for (final mascot in AppConstants.mascots) {
      if (mascot.id == _selectedMascotId) {
        return mascot;
      }
    }
    return AppConstants.mascots.first;
  }

  Future<void> init() async {
    await _storage.initializeDefaultsIfNeeded();
    await reloadAll();
  }

  Future<void> reloadAll() async {
    _user = await _storage.readUser();
    _isLoggedIn = _user['isLoggedIn'] ?? false;
    _selectedMascotId = _user['mascotId'] ?? 'pamuk';
    _language = _user['language'] ?? 'TR';

    final themeStr = _user['theme'] ?? 'light';
    _themeMode = (themeStr == 'dark' || themeStr == 'Sakin Gece')
        ? ThemeMode.dark
        : ThemeMode.light;

    _habits = await _storage.readHabits();

    // Check for daily rollover: reset isDoneToday if not completed today
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    bool habitsChanged = false;

    for (int i = 0; i < _habits.length; i++) {
      final habit = Map<String, dynamic>.from(_habits[i]);
      if (habit['lastCompletedDate'] != todayStr && habit['isDoneToday'] == true) {
        habit['isDoneToday'] = false;
        _habits[i] = habit;
        habitsChanged = true;
      }
    }
    if (habitsChanged) {
      await _storage.writeHabits(_habits);
    }

    final streaksData = await _storage.readStreaks();
    final List<dynamic> dates = streaksData['streakDates'] ?? [];
    _streakDates = dates.map((e) => e.toString()).toList();
    _currentStreak = streaksData['currentStreak'] ?? _streakDates.length;

    final savedBadges = await _storage.readBadgesAndCoupons();
    final allDefaults = [...AppConstants.defaultBadges, ...AppConstants.defaultCoupons];
    _badgesAndCoupons = savedBadges.map((item) {
      final match = allDefaults.firstWhere(
        (d) => d['id'] == item['id'],
        orElse: () => <String, dynamic>{},
      );
      if (match.isNotEmpty) {
        return {
          ...item,
          'titleEn': match['titleEn'],
          'descriptionEn': match['descriptionEn'],
        };
      }
      return item;
    }).toList();
    notifyListeners();
  }

  // --- Auth & User Actions ---
  Future<void> login(String email, String password) async {
    _user['email'] = email;
    _user['isLoggedIn'] = true;
    _isLoggedIn = true;
    await _storage.writeUser(_user);
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String surname,
    required String birthDate,
    required String email,
    required String password,
  }) async {
    _user = {
      'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'surname': surname,
      'birthDate': birthDate,
      'email': email,
      'mascotId': _selectedMascotId,
      'language': _language,
      'theme': themeName,
      'isLoggedIn': true,
    };
    _isLoggedIn = true;
    await _storage.writeUser(_user);
    notifyListeners();
  }

  Future<void> logout() async {
    _user['isLoggedIn'] = false;
    _isLoggedIn = false;
    await _storage.writeUser(_user);
    notifyListeners();
  }

  Future<void> selectMascot(String mascotId) async {
    _selectedMascotId = mascotId;
    _user['mascotId'] = mascotId;
    await _storage.writeUser(_user);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    _user['language'] = lang;
    await _storage.writeUser(_user);

    if (lang == 'EN') {
      bool changed = false;
      for (int i = 0; i < _habits.length; i++) {
        final habit = Map<String, dynamic>.from(_habits[i]);
        final name = habit['name']?.toString() ?? '';
        final nameEn = habit['nameEn']?.toString();
        if (nameEn == null || nameEn.isEmpty || nameEn == name) {
          final translated = await TranslationService.translateTrToEn(name);
          if (translated.isNotEmpty && translated != name) {
            habit['nameEn'] = translated;
            _habits[i] = habit;
            changed = true;
          }
        }
      }
      if (changed) {
        await _storage.writeHabits(_habits);
      }
    }

    notifyListeners();
  }

  Future<void> setTheme(String themeStr) async {
    final isDark = themeStr == 'dark' || themeStr == 'Sakin Gece (Koyu)' || themeStr == 'Calm Night (Dark)';
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _user['theme'] = isDark ? 'dark' : 'light';
    await _storage.writeUser(_user);
    notifyListeners();
  }

  Future<void> updateUserProfile({
    required String name,
    required String surname,
    required String email,
    required String language,
  }) async {
    _user['name'] = name;
    _user['surname'] = surname;
    _user['email'] = email;
    _user['language'] = language;
    _language = language;
    await _storage.writeUser(_user);
    notifyListeners();
  }

  // --- Habit Actions ---
  Future<void> addHabit({
    required String name,
    required String emoji,
    required String category,
    String? nameEn,
    String? categoryEn,
  }) async {
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final newHabit = {
      'id': 'h_${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'nameEn': nameEn,
      'emoji': emoji,
      'category': category,
      'categoryEn': categoryEn,
      'totalCount': 1,
      'isDoneToday': true,
      'lastCompletedDate': todayStr,
    };
    _habits.add(newHabit);
    await _recordStreakToday();
    await _storage.writeHabits(_habits);
    _checkBadgeUnlocks();
    notifyListeners();
  }

  Future<void> clearAllHabits() async {
    _habits.clear();
    await _storage.writeHabits(_habits);
    notifyListeners();
  }

  Future<void> deleteHabit(String habitId) async {
    _habits.removeWhere((h) => h['id'] == habitId);
    await _storage.writeHabits(_habits);
    _checkBadgeUnlocks();
    notifyListeners();
  }

  Future<void> toggleHabitCompletion(String habitId) async {
    final index = _habits.indexWhere((h) => h['id'] == habitId);
    if (index != -1) {
      final habit = Map<String, dynamic>.from(_habits[index]);
      final bool currentStatus = habit['isDoneToday'] ?? false;
      final int totalCount = habit['totalCount'] ?? 0;

      final now = DateTime.now();
      final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      if (currentStatus) {
        habit['isDoneToday'] = false;
        habit['lastCompletedDate'] = null;
        habit['totalCount'] = (totalCount > 0) ? (totalCount - 1) : 0;
      } else {
        habit['isDoneToday'] = true;
        habit['lastCompletedDate'] = todayStr;
        habit['totalCount'] = totalCount + 1;
        await _recordStreakToday();
      }

      _habits[index] = habit;
      await _storage.writeHabits(_habits);
      _checkBadgeUnlocks();
      notifyListeners();
    }
  }

  Future<void> _recordStreakToday() async {
    final now = DateTime.now();
    final dayStr = now.day.toString().padLeft(2, '0');
    final monthStr = now.month.toString().padLeft(2, '0');
    final todayStr = '${now.year}-$monthStr-$dayStr';

    if (!_streakDates.contains(todayStr)) {
      _streakDates.add(todayStr);
      _currentStreak += 1;
      await _storage.writeStreaks({
        'streakDates': _streakDates,
        'currentStreak': _currentStreak,
      });
    }
  }

  void _checkBadgeUnlocks() {
    bool hasUpdates = false;
    for (int i = 0; i < _badgesAndCoupons.length; i++) {
      final item = Map<String, dynamic>.from(_badgesAndCoupons[i]);
      if (item['id'] == 'badge_first_step' && item['isUnlocked'] != true) {
        item['isUnlocked'] = true;
        _badgesAndCoupons[i] = item;
        hasUpdates = true;
      }
      if (item['id'] == 'badge_3_day_streak' && _currentStreak >= 3 && item['isUnlocked'] != true) {
        item['isUnlocked'] = true;
        _badgesAndCoupons[i] = item;
        hasUpdates = true;
      }
    }
    if (hasUpdates) {
      _storage.writeBadgesAndCoupons(_badgesAndCoupons);
    }
  }
}
