// Araç veri modelini içeri aktarır
import '../models/car_model.dart';
// İstasyon veri modelini içeri aktarır
import '../models/rental_station_model.dart';

/// MockCarRepository: Araç filosunu, istasyon noktalarını ve filtreleme kurallarını
/// çevrimdışı yerel mock verilerle yöneten sahte veri deposu sınıfıdır.
class MockCarRepository {
  // Singleton örneği: Tüm uygulama genelinde tek bir filo deposu çalışır
  static final MockCarRepository instance = MockCarRepository._();

  // Dışarıdan örnekleme yapılmasını engelleyen gizli kurucu metot
  MockCarRepository._();

  // Teslim alma ve iade istasyonları sabit veri listesi
  final List<RentalStationModel> _stations = const [
    // 1. İstasyon: İstanbul Havalimanı Avrupa Yakası
    RentalStationModel(
      id: 'st_1',
      name: 'İstanbul Havalimanı (İST)',
      district: 'Arnavutköy',
      address: 'Tayakadın Mah., Terminal Cad. No:1',
      latitude: 41.2609,
      longitude: 28.7424,
    ),
    // 2. İstasyon: Sabiha Gökçen Havalimanı Anadolu Yakası
    RentalStationModel(
      id: 'st_2',
      name: 'Sabiha Gökçen Havalimanı (SAW)',
      district: 'Pendik',
      address: 'Sanayi Mah., Havaalanı Girişi',
      latitude: 40.8986,
      longitude: 29.3092,
    ),
    // 3. İstasyon: Kadıköy Şube
    RentalStationModel(
      id: 'st_3',
      name: 'Kadıköy Rıhtım İstasyonu',
      district: 'Kadıköy',
      address: 'Rıhtım Cad. No:24',
      latitude: 40.9904,
      longitude: 29.0255,
    ),
    // 4. İstasyon: Levent Şube
    RentalStationModel(
      id: 'st_4',
      name: 'Levent Metro Şubesi',
      district: 'Beşiktaş',
      address: 'Büyükdere Cad. No:185',
      latitude: 41.0776,
      longitude: 29.0125,
    ),
  ];

  // Kiralık araç filosu veri listesi
  final List<CarModel> _cars = [
    // 1. Araç: Renault Clio Ekonomik
    const CarModel(
      id: 'car_1',
      brand: 'Renault',
      model: 'Clio 1.0 TCe',
      year: '2024',
      fuelType: 'Benzin',
      transmission: 'Otomatik',
      seats: 5,
      dailyRate: 1100,
      weeklyRate: 6800,
      monthlyRate: 24500,
      isAvailable: true,
      stationName: 'İstanbul Havalimanı (İST)',
    ),
    // 2. Araç: Fiat Egea Ekonomik Dizel
    const CarModel(
      id: 'car_2',
      brand: 'Fiat',
      model: 'Egea 1.3 Multijet',
      year: '2023',
      fuelType: 'Dizel',
      transmission: 'Manuel',
      seats: 5,
      dailyRate: 950,
      weeklyRate: 5900,
      monthlyRate: 21000,
      isAvailable: true,
      stationName: 'Kadıköy Rıhtım İstasyonu',
    ),
    // 3. Araç: Toyota Corolla Çevreci Hibrit
    const CarModel(
      id: 'car_3',
      brand: 'Toyota',
      model: 'Corolla 1.8 Hybrid',
      year: '2024',
      fuelType: 'Hibrit',
      transmission: 'Otomatik',
      seats: 5,
      dailyRate: 1550,
      weeklyRate: 9800,
      monthlyRate: 35000,
      isAvailable: true,
      stationName: 'Levent Metro Şubesi',
    ),
    // 4. Araç: Volkswagen Golf Konfor
    const CarModel(
      id: 'car_4',
      brand: 'Volkswagen',
      model: 'Golf 1.5 eTSI',
      year: '2024',
      fuelType: 'Benzin (Mild Hybrid)',
      transmission: 'Otomatik',
      seats: 5,
      dailyRate: 1850,
      weeklyRate: 11500,
      monthlyRate: 41000,
      isAvailable: true,
      stationName: 'Sabiha Gökçen Havalimanı (SAW)',
    ),
    // 5. Araç: Peugeot 3008 Geniş SUV
    const CarModel(
      id: 'car_5',
      brand: 'Peugeot',
      model: '3008 Allure SUV',
      year: '2024',
      fuelType: 'Dizel',
      transmission: 'Otomatik',
      seats: 5,
      dailyRate: 2200,
      weeklyRate: 13800,
      monthlyRate: 49000,
      isAvailable: true,
      stationName: 'İstanbul Havalimanı (İST)',
    ),
    // 6. Araç: BMW 320i Premium Lüks (Dolu durumda)
    const CarModel(
      id: 'car_6',
      brand: 'BMW',
      model: '320i M Sport',
      year: '2024',
      fuelType: 'Benzin',
      transmission: 'Otomatik',
      seats: 5,
      dailyRate: 3600,
      weeklyRate: 22500,
      monthlyRate: 79000,
      isAvailable: false,
      stationName: 'Levent Metro Şubesi',
    ),
  ];

  /// Teslim istasyonları listesini asenkron olarak döner
  Future<List<RentalStationModel>> getStations() async {
    // 200 ms okuma gecikmesi simülasyonu
    await Future.delayed(const Duration(milliseconds: 200));
    return _stations;
  }

  /// İstasyon ve müsaitlik kriterlerine göre filtrelenmiş araç listesini döner
  Future<List<CarModel>> getCars({String? stationName, bool onlyAvailable = false}) async {
    // 300 ms filtreleme gecikmesi simülasyonu
    await Future.delayed(const Duration(milliseconds: 300));
    // Orijinal araba listesinin kopyasını oluştur
    var result = List<CarModel>.from(_cars);
    // İstasyon filtresi verilmişse eşleşenleri filtrele
    if (stationName != null && stationName.isNotEmpty) {
      result = result.where((c) => c.stationName == stationName).toList();
    }
    // Sadece müsait olanlar istenmişse dolu araçları çıkar
    if (onlyAvailable) {
      result = result.where((c) => c.isAvailable).toList();
    }
    // Filtrelenmiş araç listesini döndür
    return result;
  }
}
