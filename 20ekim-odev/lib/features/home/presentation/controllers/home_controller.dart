import 'package:flutter/material.dart';
import '../../data/models/car_model.dart';
import '../../data/models/rental_station_model.dart';
import '../../data/repositories/mock_car_repository.dart';

/// HomeController: Ana sayfa üzerindeki tarih seçimi, istasyon seçimi,
/// tarife modu (günlük/haftalık/aylık) ve araç filtreleme durumlarını yönetir.
class HomeController {
  final MockCarRepository _repository = MockCarRepository.instance;

  // Sayfa yükleniyor durumu
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // Gösterilecek araçlar listesi
  final ValueNotifier<List<CarModel>> cars = ValueNotifier<List<CarModel>>([]);

  // Mevcut teslim ve iade istasyonları
  final ValueNotifier<List<RentalStationModel>> stations = ValueNotifier<List<RentalStationModel>>([]);

  // Seçili fiyatlandırma tarifesi (Günlük, Haftalık, Aylık)
  final ValueNotifier<PricingType> pricingType = ValueNotifier<PricingType>(PricingType.daily);

  // Seçilen kiralama başlangıç ve bitiş tarih aralığı
  final ValueNotifier<DateTimeRange> dateRange = ValueNotifier<DateTimeRange>(
    DateTimeRange(
      start: DateTime.now().add(const Duration(days: 1)),
      end: DateTime.now().add(const Duration(days: 4)),
    ),
  );

  // Seçili teslim alma/iade istasyonu
  final ValueNotifier<RentalStationModel?> selectedStation = ValueNotifier<RentalStationModel?>(null);

  // Yalnızca müsait araçları filtreleme anahtarı
  final ValueNotifier<bool> onlyAvailable = ValueNotifier<bool>(false);

  /// Başlangıç verilerini (istasyonlar ve araçlar) yükler
  Future<void> init() async {
    isLoading.value = true;
    final stationList = await _repository.getStations();
    stations.value = stationList;
    if (stationList.isNotEmpty) {
      selectedStation.value = stationList.first;
    }
    await loadCars();
    isLoading.value = false;
  }

  /// İstasyon ve müsaitlik filtresine göre araç listesini yeniler
  Future<void> loadCars() async {
    final list = await _repository.getCars(
      stationName: selectedStation.value?.name,
      onlyAvailable: onlyAvailable.value,
    );
    cars.value = list;
  }

  /// Tarife tipini günceller ve takvimdeki tarih aralığını tarifeye senkronize eder
  void setPricingType(PricingType type) {
    pricingType.value = type;

    final start = dateRange.value.start;
    if (type == PricingType.weekly && rentalDays < 7) {
      // Haftalık seçildiğinde takvimi en az 7 güne tamamlar
      dateRange.value = DateTimeRange(start: start, end: start.add(const Duration(days: 7)));
    } else if (type == PricingType.monthly && rentalDays < 30) {
      // Aylık seçildiğinde takvimi en az 30 güne tamamlar
      dateRange.value = DateTimeRange(start: start, end: start.add(const Duration(days: 30)));
    }
  }

  /// Takvimden yeni tarih aralığı seçildiğinde çalışır
  void setDateRange(DateTimeRange range) {
    dateRange.value = range;
    final days = range.end.difference(range.start).inDays;

    // Seçilen gün sayısına göre tarife modunu akıllıca uyarla
    if (days >= 30 && pricingType.value != PricingType.monthly) {
      pricingType.value = PricingType.monthly;
    } else if (days >= 7 && days < 30 && pricingType.value == PricingType.daily) {
      pricingType.value = PricingType.weekly;
    }
  }

  /// Teslim ve iade istasyonunu günceller
  void setStation(RentalStationModel station) {
    selectedStation.value = station;
    loadCars();
  }

  /// Sadece müsait olan araçları gösterme anahtarını değiştirir
  void toggleAvailableOnly(bool value) {
    onlyAvailable.value = value;
    loadCars();
  }

  /// Kiralama yapılacak toplam gün sayısını hesaplar
  int get rentalDays {
    final diff = dateRange.value.end.difference(dateRange.value.start).inDays;
    return diff > 0 ? diff : 1;
  }

  /// Dinleyicileri temizler
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
