import 'package:flutter/foundation.dart';
import '../../data/models/reservation_model.dart';
import '../../data/repositories/mock_reservation_repository.dart';

/// ReservationsController: Rezervasyon listesi, erken iade, sistem üzerinden
/// süre uzatma ve HGS ceza ödeme durumlarını reaktif olarak yönetir.
class ReservationsController {
  final MockReservationRepository _repository = MockReservationRepository.instance;

  // Yükleme durumu bildirimcisi
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // Rezervasyon listesi bildirimcisi
  final ValueNotifier<List<ReservationModel>> reservations = ValueNotifier<List<ReservationModel>>([]);

  /// Rezervasyonları veri deposundan çeker
  Future<void> loadReservations() async {
    isLoading.value = true;
    final list = await _repository.getReservations();
    reservations.value = list;
    isLoading.value = false;
  }

  /// Doğrudan sistem üzerinden kiralama süresini uzatır
  Future<bool> extendRental(String id, int extraDays, double cost) async {
    isLoading.value = true;
    final success = await _repository.extendRental(id, extraDays, cost);
    await loadReservations();
    return success;
  }

  /// Aracı rezerve edilen tarihten önce iadesiz olarak teslim eder
  Future<bool> earlyReturn(String id) async {
    isLoading.value = true;
    final success = await _repository.earlyReturn(id);
    await loadReservations();
    return success;
  }

  /// HGS ve geç teslimat cezalarını öder
  Future<bool> payPenalties(String id) async {
    isLoading.value = true;
    final success = await _repository.payPenalties(id);
    await loadReservations();
    return success;
  }

  /// Bellek temizliği
  void dispose() {
    isLoading.dispose();
    reservations.dispose();
  }
}
