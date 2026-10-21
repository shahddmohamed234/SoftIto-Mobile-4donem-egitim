// Rezervasyon veri modelini içeri aktarır
import '../models/reservation_model.dart';

/// MockReservationRepository: Rezervasyonların listelenmesi, yeni araç kiralama,
/// sistem üzerinden kiralama süresi uzatma, erken teslimat ve HGS borç ödemelerini simüle eden sahte veri deposudur.
class MockReservationRepository {
  // Singleton deseni: Tüm uygulama genelinde tek bir rezervasyon listesi yönetilir
  static final MockReservationRepository instance = MockReservationRepository._();

  // Dışarıdan örneklenmeyi önleyen gizli kurucu metot
  MockReservationRepository._();

  // Bellek içi mock rezervasyon listesi (Örnek başlangıç verileri ile)
  final List<ReservationModel> _reservations = [
    // 1. Örnek: Aktif ve HGS borcu olan kiralama
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
      dailyRate: 1550.0,
    ),
    // 2. Örnek: Tamamlanmış ve geç teslim cezası olan kiralama
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
      dailyRate: 1100.0,
    ),
    // 3. Örnek: Gelecek tarihli onay bekleyen kiralama
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
      dailyRate: 2200.0,
    ),
  ];

  /// Kayıtlı tüm rezervasyonları asenkron simülasyonla döner
  Future<List<ReservationModel>> getReservations() async {
    // 300 ms sahte ağ gecikmesi
    await Future.delayed(const Duration(milliseconds: 300));
    // Dışarıdan listenin doğrudan değiştirilmesini önleyen değiştirilemez kopya
    return List.unmodifiable(_reservations);
  }

  /// Yeni yapılan kiralamayı listenin en başına ekler
  Future<ReservationModel> addReservation(ReservationModel reservation) async {
    // 500 ms kayıt gecikmesi simülasyonu
    await Future.delayed(const Duration(milliseconds: 500));
    // Yeni rezervasyonu en üste ekler
    _reservations.insert(0, reservation);
    // Eklenen rezervasyon nesnesini geri döner
    return reservation;
  }

  /// Kullanıcının şubeye gitmeden doğrudan sistem üzerinden kiralama süresini uzatmasını sağlar
  Future<bool> extendRental(String reservationId, int extraDays, double additionalCost) async {
    // 400 ms işlem gecikmesi
    await Future.delayed(const Duration(milliseconds: 400));
    // İlgili rezervasyonu kimliğine göre listede bul
    final index = _reservations.indexWhere((r) => r.id == reservationId);
    // Bulunduysa
    if (index != -1) {
      final current = _reservations[index];
      // Bitiş tarihine ek günleri ve toplam tutara ek bedeli ekle
      _reservations[index] = current.copyWith(
        endDate: current.endDate.add(Duration(days: extraDays)),
        totalAmount: current.totalAmount + additionalCost,
      );
      return true;
    }
    return false;
  }

  /// Aracı rezerve edilen süreden önce erken teslim eder.
  /// (Zorunlu Kural: Kalan süre için ücret iadesi yapılmaz).
  Future<bool> earlyReturn(String reservationId) async {
    // 400 ms teslimat işlem gecikmesi
    await Future.delayed(const Duration(milliseconds: 400));
    // İlgili rezervasyonu bul
    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      final current = _reservations[index];
      // Bitiş tarihini anlık tarihe çek ve durumu tamamlandı (completed) yap
      _reservations[index] = current.copyWith(
        endDate: DateTime.now(),
        status: ReservationStatus.completed,
      );
      return true;
    }
    return false;
  }

  /// Varsa HGS geçiş veya gecikmeli teslimat borçlarını öder
  Future<bool> payPenalties(String reservationId) async {
    // 500 ms ödeme işleme gecikmesi
    await Future.delayed(const Duration(milliseconds: 500));
    // Rezervasyonu bul
    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      final current = _reservations[index];
      // HGS bayrağını kapat ve borç tutarlarını sıfırla
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
