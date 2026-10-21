import '../../pomodoro/data/models/pomodoro_session_model.dart';
import '../../../core/localization/app_strings.dart';

/// Odak analitiği istatistiklerini hesaplayan servis
class AnalyticsCalculator {
  /// Seans listesi üzerinden toplam çalışma süresini dakika olarak hesaplar
  static int calculateTotalWorkMinutes(List<PomodoroSessionModel> sessions) {
    int total = 0;
    for (final session in sessions) {
      total += session.workDuration;
    }
    return total;
  }

  /// Toplam mola süresini dakika olarak hesaplar
  static int calculateTotalBreakMinutes(List<PomodoroSessionModel> sessions) {
    int total = 0;
    for (final session in sessions) {
      total += session.breakDuration;
    }
    return total;
  }

  /// Ortalama seans süresini hesaplar
  static int calculateAverageWorkMinutes(List<PomodoroSessionModel> sessions) {
    if (sessions.isEmpty) return 0;
    final total = calculateTotalWorkMinutes(sessions);
    return (total / sessions.length).round();
  }

  /// Odaklanma başarı oranını (%) hesaplar (İhlal edilmeyen seansların oranı)
  static int calculateSuccessRate(List<PomodoroSessionModel> sessions) {
    if (sessions.isEmpty) return 100;
    final int violations = calculateTotalViolations(sessions);
    final int successful = sessions.length - violations;
    if (successful <= 0) return 0;
    return ((successful / sessions.length) * 100).round();
  }

  /// Toplam ihlal sayısını hesaplar
  static int calculateTotalViolations(List<PomodoroSessionModel> sessions) {
    int count = 0;
    for (final session in sessions) {
      if (session.wasViolated) {
        count++;
      }
    }
    return count;
  }

  /// Dakika cinsinden süreyi "X sa Y dk" veya "X dk" formatına dönüştürür
  static String formatMinutes(int minutes) {
    final String hStr = AppStrings.get('hours');
    final String mStr = AppStrings.get('minutes');
    if (minutes >= 60) {
      final int hours = minutes ~/ 60;
      final int remaining = minutes % 60;
      if (remaining > 0) {
        return '$hours $hStr $remaining $mStr';
      }
      return '$hours $hStr';
    }
    return '$minutes $mStr';
  }

  /// Verimlilik analiz özeti metnini üretir
  static String getInsightMessage(List<PomodoroSessionModel> sessions) {
    if (sessions.isEmpty) {
      return AppStrings.get('insightEmpty');
    }
    final int violations = calculateTotalViolations(sessions);
    if (violations == 0) {
      return AppStrings.get('insightExcellent');
    } else if (violations <= 2) {
      return AppStrings.get('insightGood');
    } else {
      return AppStrings.get('insightWarning');
    }
  }

  /// Seçili sekmeye (Günlük: 0, Haftalık: 1, Aylık: 2) göre seansları filtreler
  static List<PomodoroSessionModel> filterSessions(
    List<PomodoroSessionModel> sessions,
    int tabIndex,
    DateTime selectedDate,
  ) {
    return sessions.where((s) {
      final dt = DateTime.tryParse(s.timestamp);
      if (dt == null) return false;

      if (tabIndex == 0) {
        return dt.year == selectedDate.year &&
            dt.month == selectedDate.month &&
            dt.day == selectedDate.day;
      } else if (tabIndex == 1) {
        final diff = selectedDate.difference(dt).inDays;
        return diff >= 0 && diff < 7;
      } else {
        return dt.year == selectedDate.year && dt.month == selectedDate.month;
      }
    }).toList();
  }

  /// Dil seçeneğine göre haftalık grafik etiketleri
  static List<String> getWeeklyTitles() {
    if (AppStrings.currentLanguage == 'en') {
      return const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    }
    return const ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
  }

  /// Dil seçeneğine göre aylık grafik etiketleri
  static List<String> getMonthlyTitles() {
    if (AppStrings.currentLanguage == 'en') {
      return const ['W 1', 'W 2', 'W 3', 'W 4'];
    }
    return const ['1.Hafta', '2.Hafta', '3.Hafta', '4.Hafta'];
  }

  /// Seansları gün bazında gruplayarak son 7 günün dakikalarını haritalandırır
  static Map<int, double> getWeeklyDistribution(List<PomodoroSessionModel> sessions) {
    final Map<int, double> distribution = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0};
    final now = DateTime.now();

    for (final session in sessions) {
      final sessionDate = DateTime.tryParse(session.timestamp);
      if (sessionDate != null) {
        final differenceInDays = now.difference(sessionDate).inDays;
        if (differenceInDays >= 0 && differenceInDays < 7) {
          final int index = 6 - differenceInDays;
          distribution[index] = (distribution[index] ?? 0) + session.workDuration;
        }
      }
    }
    return distribution;
  }

  /// Seansları günün saatlerine göre (00:00 - 24:00) 4'er saatlik dilimlerde gruplar
  static Map<int, double> getDailyHourlyDistribution(List<PomodoroSessionModel> sessions) {
    final Map<int, double> hourly = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    final today = DateTime.now();

    for (final session in sessions) {
      final sessionDate = DateTime.tryParse(session.timestamp);
      if (sessionDate != null) {
        if (sessionDate.year == today.year &&
            sessionDate.month == today.month &&
            sessionDate.day == today.day) {
          final int bucket = (sessionDate.hour ~/ 4).clamp(0, 5);
          hourly[bucket] = (hourly[bucket] ?? 0) + session.workDuration;
        }
      }
    }
    return hourly;
  }

  /// Seansları haftalık bazda (ayın 4 haftası) gruplar
  static Map<int, double> getMonthlyWeeklyDistribution(List<PomodoroSessionModel> sessions) {
    final Map<int, double> weekly = {0: 0, 1: 0, 2: 0, 3: 0};
    final today = DateTime.now();

    for (final session in sessions) {
      final sessionDate = DateTime.tryParse(session.timestamp);
      if (sessionDate != null) {
        if (sessionDate.year == today.year && sessionDate.month == today.month) {
          final int weekIndex = ((sessionDate.day - 1) ~/ 7).clamp(0, 3);
          weekly[weekIndex] = (weekly[weekIndex] ?? 0) + session.workDuration;
        }
      }
    }
    return weekly;
  }
}
