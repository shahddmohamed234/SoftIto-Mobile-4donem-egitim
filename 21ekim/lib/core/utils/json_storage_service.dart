import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:full_concentrate/core/constants/app_constants.dart';
import 'package:full_concentrate/features/tasks/data/models/task_model.dart';
import 'package:full_concentrate/features/pomodoro/data/models/pomodoro_session_model.dart';
import 'package:full_concentrate/features/settings/data/models/settings_model.dart';

/// Cihazın yerel dosya sistemine doğrudan JSON formatında okuma/yazma yapan servis sınıfı
/// 
/// Dış API veya backend bulunmadığı için tüm veri kalıcılığı bu servis üzerinden sağlanır.
class JsonStorageService {
  // Singleton tasarım deseni uygulaması
  static final JsonStorageService _instance = JsonStorageService._internal();
  factory JsonStorageService() => _instance;
  JsonStorageService._internal();

  /// Belirtilen dosya adının uygulama belgeleri dizinindeki File referansını döndürür
  Future<File> _getFile(String fileName) async {
    // Cihazın özel uygulama belgeleri klasör yolunu alır
    final directory = await getApplicationDocumentsDirectory();
    // Tam dosya yolunu oluşturur (örn: .../tasks.json)
    return File('${directory.path}/$fileName.json');
  }

  // ==================== GÖREVLER (TASKS) İŞLEMLERİ ====================

  /// Görev listesini tasks.json dosyasına asenkron olarak yazar
  Future<void> saveTasks(List<TaskModel> tasks) async {
    try {
      // tasks.json dosya referansını alır
      final file = await _getFile(AppConstants.tasksFileName);
      // Görev nesnelerini Map formatına, ardından JSON stringine çevirir
      final String jsonString = jsonEncode(tasks.map((t) => t.toJson()).toList());
      // Dosyaya UTF-8 olarak yazar
      await file.writeAsString(jsonString);
    } catch (e) {
      // Olası dosya yazma hatasını konsola yazdırır
      debugPrint('Görevler kaydedilirken hata oluştu: $e');
    }
  }

  /// tasks.json dosyasından görev listesini okur
  Future<List<TaskModel>> loadTasks() async {
    try {
      final file = await _getFile(AppConstants.tasksFileName);
      // Dosya daha önce oluşturulmuş mu kontrol eder
      if (await file.exists()) {
        final String jsonString = await file.readAsString();
        if (jsonString.trim().isEmpty) {
          return [];
        }
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((data) => TaskModel.fromJson(data)).toList();
      } else {
        // Dosya henüz yoksa boş liste döner
        return [];
      }
    } catch (e) {
      debugPrint('Görevler okunurken hata oluştu: $e');
      return [];
    }
  }

  // ==================== SEANSLAR (SESSIONS) İŞLEMLERİ ====================

  /// Pomodoro seans geçmişini sessions.json dosyasına yazar
  Future<void> saveSessions(List<PomodoroSessionModel> sessions) async {
    try {
      final file = await _getFile(AppConstants.sessionsFileName);
      final String jsonString = jsonEncode(sessions.map((s) => s.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      debugPrint('Seanslar kaydedilirken hata oluştu: $e');
    }
  }

  /// sessions.json dosyasından seans geçmişini okur
  Future<List<PomodoroSessionModel>> loadSessions() async {
    try {
      final file = await _getFile(AppConstants.sessionsFileName);
      if (await file.exists()) {
        final String jsonString = await file.readAsString();
        if (jsonString.trim().isEmpty) {
          return [];
        }
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((data) => PomodoroSessionModel.fromJson(data)).toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Seanslar okunurken hata oluştu: $e');
      return [];
    }
  }

  // ==================== AYARLAR (SETTINGS) İŞLEMLERİ ====================

  /// Kullanıcı ayarlarını settings.json dosyasına kaydeder
  Future<void> saveSettings(SettingsModel settings) async {
    try {
      final file = await _getFile(AppConstants.settingsFileName);
      final String jsonString = jsonEncode(settings.toJson());
      await file.writeAsString(jsonString);
    } catch (e) {
      debugPrint('Ayarlar kaydedilirken hata oluştu: $e');
    }
  }

  /// settings.json dosyasından ayarları okur
  Future<SettingsModel> loadSettings() async {
    try {
      final file = await _getFile(AppConstants.settingsFileName);
      if (await file.exists()) {
        final String jsonString = await file.readAsString();
        if (jsonString.trim().isNotEmpty) {
          final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
          return SettingsModel.fromJson(jsonMap);
        }
      }
      // Dosya yoksa veya boşsa varsayılan ayarları döndürür
      return const SettingsModel();
    } catch (e) {
      debugPrint('Ayarlar okunurken hata oluştu: $e');
      return const SettingsModel();
    }
  }
}
