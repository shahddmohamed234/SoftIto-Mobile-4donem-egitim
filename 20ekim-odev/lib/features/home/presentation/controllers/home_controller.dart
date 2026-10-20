// Flutter malzeme tasarımı ve DateTimeRange sınıflarını içeri aktarır
import 'package:flutter/material.dart';
// Araç veri modelini ve tarife türü enum'ını içeri aktarır
import '../../data/models/car_model.dart';
// İstasyon veri modelini içeri aktarır
import '../../data/models/rental_station_model.dart';
// Araç ve filo veri deposunu içeri aktarır
import '../../data/repositories/mock_car_repository.dart';

/// HomeController: Ana sayfa üzerindeki tarih seçimi, istasyon seçimi,
/// tarife modu (günlük/haftalık/aylık) ve araç filtreleme durumlarını yöneten kontrolcüdür.
class HomeController {
  // Veri katmanı araç deposu örneği
  final MockCarRepository _repository = MockCarRepository.instance;

  // Sayfa yükleniyor durumunu bildiren reaktif bayrak
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // Ekranda listelenecek araçları tutan reaktif liste bildirimcisi
  final ValueNotifier<List<CarModel>> cars = ValueNotifier<List<CarModel>>([]);

  // Mevcut teslim ve iade istasyonları listesini tutan reaktif bildirimci
  final ValueNotifier<List<RentalStationModel>> stations = ValueNotifier<List<RentalStationModel>>([]);

  // Seçili fiyatlandırma tarifesini tutan reaktif bildirimci (Varsayılan: Günlük)
  final ValueNotifier<PricingType> pricingType = ValueNotifier<PricingType>(PricingType.daily);

  // Seçilen kiralama başlangıç ve bitiş tarih aralığını tutan reaktif bildirimci (Varsayılan: Yarından itibaren 3 gün)
  final ValueNotifier<DateTimeRange> dateRange = ValueNotifier<DateTimeRange>(
    DateTimeRange(
      start: DateTime.now().add(const Duration(days: 1)),
      end: DateTime.now().add(const Duration(days: 4)),
    ),
  );

  // Haritadan veya listeden seçili olan teslim alma/iade istasyonu
  final ValueNotifier<RentalStationModel?> selectedStation = ValueNotifier<RentalStationModel?>(null);

  // Yalnızca müsait olan araçları gösterme filtresi anahtarı (Varsayılan: false)
  final ValueNotifier<bool> onlyAvailable = ValueNotifier<bool>(false);

  /// Başlangıç verilerini (istasyonlar ve araçlar) yükleyen başlatıcı metot
  Future<void> init() async {
    // Yükleniyor durumunu aç
    isLoading.value = true;
    // İstasyon listesini depodan çek
    final stationList = await _repository.getStations();
    stations.value = stationList;
    // İstasyon listesi doluysa ilk istasyonu varsayılan seçili yap
    if (stationList.isNotEmpty) {
      selectedStation.value = stationList.first;
    }
    // Seçili kriterlere göre araçları yükle
    await loadCars();
    // Yükleniyor durumunu kapat
    isLoading.value = false;
  }

  /// İstasyon ve müsaitlik filtresine göre araç listesini depodan yeniler
  Future<void> loadCars() async {
    final list = await _repository.getCars(
      stationName: selectedStation.value?.name,
      onlyAvailable: onlyAvailable.value,
    );
    // Reaktif listeyi güncelle
    cars.value = list;
  }

  /// Tarife tipini günceller ve takvimdeki tarih aralığını tarifeye senkronize eder
  void setPricingType(PricingType type) {
    // Seçili tarife tipini ata
    pricingType.value = type;

    // Başlangıç tarihini al
    final start = dateRange.value.start;
    // Haftalık tarife seçilmiş ve gün sayısı 7'den az ise takvimi 7 güne tamamla
    if (type == PricingType.weekly && rentalDays < 7) {
      dateRange.value = DateTimeRange(start: start, end: start.add(const Duration(days: 7)));
    } else if (type == PricingType.monthly && rentalDays < 30) {
      // Aylık tarife seçilmiş ve gün sayısı 30'dan az ise takvimi 30 güne tamamla
      dateRange.value = DateTimeRange(start: start, end: start.add(const Duration(days: 30)));
    }
  }

  /// Takvimden yeni tarih aralığı seçildiğinde çalışır ve tarifeyi akıllıca uydurur
  void setDateRange(DateTimeRange range) {
    // Yeni tarih aralığını ata
    dateRange.value = range;
    // Gün farkını hesapla
    final days = range.end.difference(range.start).inDays;

    // Seçilen gün sayısı 30 ve üstüyse tarife modunu otomatik olarak aylık yap
    if (days >= 30 && pricingType.value != PricingType.monthly) {
      pricingType.value = PricingType.monthly;
    } else if (days >= 7 && days < 30 && pricingType.value == PricingType.daily) {
      // Seçilen gün 7 ile 30 gün arasındaysa otomatik olarak haftalık avantaja geçir
      pricingType.value = PricingType.weekly;
    }
  }

  /// Teslim ve iade istasyonunu günceller ve araçları yeniden filtreler
  void setStation(RentalStationModel station) {
    selectedStation.value = station;
    loadCars();
  }

  /// Sadece müsait olan araçları gösterme anahtarını değiştirir ve listeyi yeniler
  void toggleAvailableOnly(bool value) {
    onlyAvailable.value = value;
    loadCars();
  }

  /// Kiralama yapılacak toplam gün sayısını hesaplayan getter (En az 1 gün)
  int get rentalDays {
    final diff = dateRange.value.end.difference(dateRange.value.start).inDays;
    return diff > 0 ? diff : 1;
  }

  /// Bellek sızıntılarını önlemek için ValueNotifier dinleyicilerini serbest bırakır
  void dispose() {
    isLoading.dispose();
    cars.dispose();
    stations.dispose();
    pricingType.dispose();
    dateRange.dispose();
    selectedStation.dispose();
    onlyAvailable.dispose();
  }
}
