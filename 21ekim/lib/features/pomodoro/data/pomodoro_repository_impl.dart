import '../domain/pomodoro_repository.dart';
import 'models/pomodoro_session_model.dart';
import '../../../core/utils/json_storage_service.dart';

/// PomodoroRepository arayüzünün yerel JSON dosyasını kullanan somut uygulaması
class PomodoroRepositoryImpl implements PomodoroRepository {
  final JsonStorageService _storageService;

  PomodoroRepositoryImpl({JsonStorageService? storageService})
      : _storageService = storageService ?? JsonStorageService();

  @override
  Future<List<PomodoroSessionModel>> getSessions() async {
    return await _storageService.loadSessions();
  }

  @override
  Future<void> saveSession(PomodoroSessionModel session) async {
    final List<PomodoroSessionModel> currentSessions = await _storageService.loadSessions();
    currentSessions.insert(0, session);
    await _storageService.saveSessions(currentSessions);
  }
}
