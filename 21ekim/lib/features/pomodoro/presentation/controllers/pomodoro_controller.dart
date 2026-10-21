import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:full_concentrate/core/constants/app_constants.dart';
import 'package:full_concentrate/features/pomodoro/domain/pomodoro_repository.dart';
import 'package:full_concentrate/features/pomodoro/data/models/pomodoro_session_model.dart';
import 'package:full_concentrate/features/pomodoro/data/pomodoro_repository_impl.dart';
import 'package:full_concentrate/features/tasks/data/models/task_model.dart';

/// Seans durum enum değeri
enum PomodoroStatus {
  idle,     // Başlamadı / Beklemede
  working,  // Odaklanma seansı aktif çalışıyor
  paused,   // Duraklatıldı
  breaking, // Mola modunda
}

/// Pomodoro sayacının ve odak kurallarının durumunu yöneten ChangeNotifier kontrolcüsü
class PomodoroController extends ChangeNotifier with WidgetsBindingObserver {
  final PomodoroRepository _repository;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Aktif seans durumu
  PomodoroStatus _status = PomodoroStatus.idle;

  // Çalışma süresi (dakika) - En az 25 dakika kuralı
  int _workDurationMinutes = AppConstants.minWorkDurationMinutes;

  // Kalan süre (saniye cinsinden)
  int _remainingSeconds = AppConstants.minWorkDurationMinutes * 60;

  // Dinamik hesaplanan mola süresi (dakika)
  int _breakDurationMinutes = AppConstants.baseBreakReferenceMinutes;

  // İhlal tespit edildi mi?
  bool _isViolationDetected = false;

  // Toplam ihlal sayısı (aktif seans için)
  int _sessionViolations = 0;

  // Periyodik saniye sayacı
  Timer? _timer;

  // Aktif görev bilgisi
  TaskModel? _currentTask;

  PomodoroController({PomodoroRepository? repository})
      : _repository = repository ?? PomodoroRepositoryImpl() {
    WidgetsBinding.instance.addObserver(this);
    _updateBreakDuration();
  }

  // Getters
  PomodoroStatus get status => _status;
  int get workDurationMinutes => _workDurationMinutes;
  int get remainingSeconds => _remainingSeconds;
  int get breakDurationMinutes => _breakDurationMinutes;
  bool get isViolationDetected => _isViolationDetected;
  int get sessionViolations => _sessionViolations;
  TaskModel? get currentTask => _currentTask;

  /// Aktif görevi günceller
  void setCurrentTask(TaskModel? task) {
    _currentTask = task;
    notifyListeners();
  }

  /// Mola süresini dinamik denklem ile günceller
  void _updateBreakDuration() {
    _breakDurationMinutes = AppConstants.calculateBreakDuration(_workDurationMinutes);
  }

  /// Çalışma süresini ayarlar (En az 25 dakika kontrolüyle)
  void setWorkDuration(int minutes) {
    if (_status == PomodoroStatus.idle) {
      if (minutes >= AppConstants.minWorkDurationMinutes) {
        _workDurationMinutes = minutes;
      } else {
        _workDurationMinutes = AppConstants.minWorkDurationMinutes;
      }
      _remainingSeconds = _workDurationMinutes * 60;
      _updateBreakDuration();
      notifyListeners();
    }
  }

  /// Pomodoro seansını başlatır
  void startSession() {
    _status = PomodoroStatus.working;
    _isViolationDetected = false;
    _startTimer();
    notifyListeners();
  }

  /// Seansı duraklatır
  void pauseSession() {
    if (_status == PomodoroStatus.working) {
      _status = PomodoroStatus.paused;
      _timer?.cancel();
      notifyListeners();
    }
  }

  /// Duraklatılan seansa devam eder
  void resumeSession() {
    if (_status == PomodoroStatus.paused) {
      _status = PomodoroStatus.working;
      _startTimer();
      notifyListeners();
    }
  }

  /// Seansı erken bitirir veya sıfırlar
  Future<void> finishSession({bool manual = false}) async {
    _timer?.cancel();

    if (_status == PomodoroStatus.working || _status == PomodoroStatus.paused) {
      // Seansı veri tabanına kaydet
      final session = PomodoroSessionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        taskId: _currentTask?.id ?? 'genel',
        workDuration: _workDurationMinutes,
        breakDuration: _breakDurationMinutes,
        timestamp: DateTime.now().toIso8601String(),
        wasViolated: _isViolationDetected,
      );
      await _repository.saveSession(session);
    }

    _status = PomodoroStatus.idle;
    _remainingSeconds = _workDurationMinutes * 60;
    _isViolationDetected = false;
    notifyListeners();
  }

  /// Mola moduna geçiş yapar
  void startBreak() {
    _playAlarmSound();
    _status = PomodoroStatus.breaking;
    _remainingSeconds = _breakDurationMinutes * 60;
    _isViolationDetected = false; // Molada çıkış ihlal sayılmaz
    _startTimer();
    notifyListeners();
  }

  /// Molayı erken bitirir
  void finishBreakEarly() {
    _timer?.cancel();
    _status = PomodoroStatus.idle;
    _remainingSeconds = _workDurationMinutes * 60;
    notifyListeners();
  }

  /// 1 saniyelik periyodik geri sayım başlatıcı
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        _handleTimeUp();
      }
    });
  }

  /// Süre dolduğunda yapılacak işlemler
  void _handleTimeUp() {
    if (_status == PomodoroStatus.working) {
      // Çalışma seansı bitti, mola başlatılır
      final session = PomodoroSessionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        taskId: _currentTask?.id ?? 'genel',
        workDuration: _workDurationMinutes,
        breakDuration: _breakDurationMinutes,
        timestamp: DateTime.now().toIso8601String(),
        wasViolated: _isViolationDetected,
      );
      _repository.saveSession(session);
      startBreak();
    } else if (_status == PomodoroStatus.breaking) {
      // Mola bitti, idle durumuna dönülür
      _playAlarmSound();
      _status = PomodoroStatus.idle;
      _remainingSeconds = _workDurationMinutes * 60;
      notifyListeners();
    }
  }

  /// Alarm çalma fonksiyonu
  void _playAlarmSound() {
    try {
      _audioPlayer.play(AssetSource('audio/alarm.mp3'));
    } catch (_) {
      // Ses dosyası yoksa veya hata verirse sessizce devam eder
    }
  }

  /// Kırmızı Çizgi Kuralı: Uygulama yaşam döngüsü kontrolü
  /// Pomodoro devam ederken uygulamadan çıkılırsa ihlal kırmızı uyarısı tetiklenir.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_status == PomodoroStatus.working || _status == PomodoroStatus.paused) {
      if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
        _isViolationDetected = true;
        _sessionViolations++;
        // İhlal durumunda sayacı duraklat
        pauseSession();
        notifyListeners();
      }
    }
  }

  /// İhlal uyarısını temizler (kullanıcı uyarıyı onaylayıp döndüğünde)
  void acknowledgeViolation() {
    _isViolationDetected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
