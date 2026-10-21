import 'package:flutter/material.dart';
import '../../data/models/settings_model.dart';
import '../../../../core/utils/json_storage_service.dart';
import '../../../../core/localization/app_strings.dart';

/// Ayarlar durumunu (State) yöneten yerel ChangeNotifier kontrolcüsü
class SettingsController extends ChangeNotifier {
  final JsonStorageService _storageService;
  SettingsModel _settings = const SettingsModel();
  bool _isLoading = true;

  SettingsController({JsonStorageService? storageService})
      : _storageService = storageService ?? JsonStorageService() {
    loadSettings();
  }

  SettingsModel get settings => _settings;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _settings.isDarkMode;
  String get languageCode => _settings.languageCode;

  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    _settings = await _storageService.loadSettings();
    AppStrings.currentLanguage = _settings.languageCode;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool enabled) async {
    _settings = _settings.copyWith(isDarkMode: enabled);
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    _settings = _settings.copyWith(languageCode: code);
    AppStrings.currentLanguage = code;
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setVolume(double volume) async {
    _settings = _settings.copyWith(pomodoroVolume: volume);
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setPomodoroSoundType(String type) async {
    _settings = _settings.copyWith(pomodoroSoundType: type);
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setBreakSoundType(String type) async {
    _settings = _settings.copyWith(breakSoundType: type);
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }
}
