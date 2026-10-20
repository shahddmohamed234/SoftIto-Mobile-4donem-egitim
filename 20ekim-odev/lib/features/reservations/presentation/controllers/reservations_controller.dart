// ValueNotifier reaktif durum yönetimi için Flutter temel kütüphanesini içeri aktarır
import 'package:flutter/foundation.dart';
// Rezervasyon veri modelini içeri aktarır
import '../../data/models/reservation_model.dart';
// Rezervasyon veri deposunu içeri aktarır
import '../../data/repositories/mock_reservation_repository.dart';

/// ReservationsController: Rezervasyon listesi, erken iade, sistem üzerinden
/// süre uzatma ve HGS ceza ödeme durumlarını reaktif olarak yöneten kontrolcüdür.
class ReservationsController {
  // Veri katmanı deposuna referans (Singleton nesnesi)
  final MockReservationRepository _repository = MockReservationRepository.instance;

  // Ekran yükleme durumunu bildiren reaktif bayrak
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // Rezervasyon listesi değişimlerini dinleyicilere ileten reaktif liste bildirimcisi
  final ValueNotifier<List<ReservationModel>> reservations = ValueNotifier<List<ReservationModel>>([]);

  /// Rezervasyonları veri deposundan çeker ve arayüzü günceller
  Future<void> loadReservations() async {
    // Yükleniyor durumunu aç
    isLoading.value = true;
    // Depo üzerinden güncel rezervasyon listesini oku
    final list = await _repository.getReservations();
    // Reaktif listeyi güncelle
    reservations.value = list;
    // Yükleniyor durumunu kapat
    isLoading.value = false;
  }

  /// Kullanıcının doğrudan sistem üzerinden kiralama süresini uzatmasını yönetir
  Future<bool> extendRental(String id, int extraDays, double cost) async {
    // İşlem başladığı için yükleme durumunu aktif et
    isLoading.value = true;
    // Depo katmanında süreyi uzat
    final success = await _repository.extendRental(id, extraDays, cost);
    // Rezervasyon listesini yeniden çekip arayüze yansıt
    await loadReservations();
    // İşlem başarı durumunu döndür
    return success;
  }

  /// Aracı rezerve edilen tarihten önce iadesiz olarak teslim eder
  Future<bool> earlyReturn(String id) async {
    // Yükleniyor durumunu aç
    isLoading.value = true;
    // Depo katmanında teslimatı tamamla
    final success = await _repository.earlyReturn(id);
    // Güncel listeyi tekrar yükle
    await loadReservations();
    // Başarı durumunu dön
    return success;
  }

  /// Varsa HGS ve geç teslimat cezalarını öder
  Future<bool> payPenalties(String id) async {
    // Yükleniyor durumunu aç
    isLoading.value = true;
    // Depo katmanında borçları öde
    final success = await _repository.payPenalties(id);
    // Rezervasyonları yeniden yükle
    await loadReservations();
    // Başarı durumunu dön
    return success;
  }

  /// Bellek sızıntılarını önlemek için ValueNotifier dinleyicilerini serbest bırakır
  void dispose() {
    // Yükleme bildirimcisini bellekten temizle
    isLoading.dispose();
    // Rezervasyon listesi bildirimcisini bellekten temizle
    reservations.dispose();
  }
}
