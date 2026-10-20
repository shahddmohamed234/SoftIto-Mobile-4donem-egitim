import '../models/reservation_model.dart';

/// MockReservationRepository: Rezervasyonların listelenmesi, yeni araç kiralama,
/// sistem üzerinden kiralama süresi uzatma, erken teslimat ve HGS borç ödemelerini simüle eder.
class MockReservationRepository {
  // Singleton erişim
  static final MockReservationRepository instance = MockReservationRepository._();
  MockReservationRepository._();

  // Mock rezervasyon listesi
  final List<ReservationModel> _reservations = [
    ReservationModel(
      id: 'REZ-1049',
      carModel: 'Toyota Corolla 1.8 Hybrid',
      stationName: 'Levent Metro Şubesi',
      startDate: DateTime.now().subtract(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 3, hours: 5)),
      status: ReservationStatus.active,
      totalAmount: 4650.0,
      hasHgsPenalty: true,
      hgsAmount: 145.50, // 15 Temmuz Şehitler Köprüsü ve Otoyol HGS
      latePenaltyAmount: 0.0,
      isPaid: true,
    ),
    ReservationModel(
      id: 'REZ-1032',
      carModel: 'Renault Clio 1.0 TCe',
      stationName: 'İstanbul Havalimanı (İST)',
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().subtract(const Duration(days: 7)),
      status: ReservationStatus.completed,
      totalAmount: 3300.0,
      hasHgsPenalty: false,
      hgsAmount: 0.0,
      latePenaltyAmount: 350.0, // Geç teslim cezası
      isPaid: true,
    ),
    ReservationModel(
      id: 'REZ-1055',
      carModel: 'Peugeot 3008 Allure SUV',
      stationName: 'Sabiha Gökçen Havalimanı (SAW)',
      startDate: DateTime.now().add(const Duration(days: 3)),
      endDate: DateTime.now().add(const Duration(days: 7)),
      status: ReservationStatus.pending,
      totalAmount: 8800.0,
      hasHgsPenalty: false,
      hgsAmount: 0.0,
      latePenaltyAmount: 0.0,
      isPaid: true,
    ),
  ];

  /// Kayıtlı tüm rezervasyonları asenkron simülasyonla döner
  Future<List<ReservationModel>> getReservations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_reservations);
  }

  /// Yeni yapılan kiralamayı listenin en başına ekler
  Future<ReservationModel> addReservation(ReservationModel reservation) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _reservations.insert(0, reservation);
    return reservation;
  }

  /// Kullanıcının sistem üzerinden kiralama süresini uzatmasını sağlar
  Future<bool> extendRental(String reservationId, int extraDays, double additionalCost) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      final current = _reservations[index];
      _reservations[index] = current.copyWith(
        endDate: current.endDate.add(Duration(days: extraDays)),
        totalAmount: current.totalAmount + additionalCost,
      );
      return true;
    }
    return false;
  }

  /// Aracı rezerve edilen süreden önce erken teslim eder.
  /// (Kural: Kalan süre için ücret iadesi yapılmaz).
  Future<bool> earlyReturn(String reservationId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      final current = _reservations[index];
      _reservations[index] = current.copyWith(
        endDate: DateTime.now(),
        status: ReservationStatus.completed,
      );
      return true;
    }
    return false;
  }

  /// Varsa HGS veya geç teslimat borçlarını öder
  Future<bool> payPenalties(String reservationId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      final current = _reservations[index];
      _reservations[index] = current.copyWith(
        hasHgsPenalty: false,
        hgsAmount: 0.0,
        latePenaltyAmount: 0.0,
      );
      return true;
    }
    return false;
  }
}
