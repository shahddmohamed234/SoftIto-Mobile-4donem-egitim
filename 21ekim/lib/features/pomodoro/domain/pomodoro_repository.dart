import '../data/models/pomodoro_session_model.dart';

/// Pomodoro oturum kayıtlarının soyut arayüzü
abstract class PomodoroRepository {
  /// Kayıtlı tüm geçmiş seansları getirir
  Future<List<PomodoroSessionModel>> getSessions();

  /// Tamamlanan veya sonlandırılan bir seansı kaydeder
  Future<void> saveSession(PomodoroSessionModel session);
}
