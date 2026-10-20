// Flutter malzeme tasarımı kütüphanesini içeri aktarır
import 'package:flutter/material.dart';
// Araç veri modelini ve tarife türü enum'ını içeri aktarır
import '../../data/models/car_model.dart';
// Rezervasyon veri modelini içeri aktarır
import 'package:easy_rent/features/reservations/data/models/reservation_model.dart';
// Rezervasyon veri deposunu içeri aktarır
import 'package:easy_rent/features/reservations/data/repositories/mock_reservation_repository.dart';
// Ana sayfa kontrolcüsünü içeri aktarır
import '../controllers/home_controller.dart';
// Araç kartı bileşenini içeri aktarır
import '../widgets/car_card.dart';
// Tarih aralığı seçici kart bileşenini içeri aktarır
import '../widgets/date_range_picker_card.dart';
// Kiralama ödeme ve 3D SMS onay penceresini içeri aktarır
import '../widgets/payment_reservation_dialog.dart';
// Tarife modu (Günlük/Haftalık/Aylık) anahtar çubuğunu içeri aktarır
import '../widgets/rate_toggle_bar.dart';
// Harita teslim noktaları alt sayfasını içeri aktarır
import '../widgets/station_locations_sheet.dart';

/// HomeScreen: Araç listeleme, takvim seçimi, tarife modu ve harita istasyonlarının
/// gösterildiği ana kullanıcı ekranıdır.
class HomeScreen extends StatefulWidget {
  // Ana sayfa kontrolcüsü
  final HomeController controller;

  // Başarılı kiralama sonrası rezervasyonlar sekmesine yönlendiren fonksiyon
  final VoidCallback onNavigateToReservations;

  // HomeScreen sabit kurucu metodu
  const HomeScreen({
    super.key,
    // Kontrolcü parametresi zorunludur
    required this.controller,
    // Rezervasyon sayfasına geçiş geri çağırımı zorunludur
    required this.onNavigateToReservations,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // Üst sınıf initState metodunu çalıştırır
    super.initState();
    // Sayfa ilk açıldığında istasyon ve araç verilerini depodan yükler
    widget.controller.init();
  }

  /// Harita ve istasyon seçim alt panelini (BottomSheet) açar
  void _openStationSheet() {
    showModalBottomSheet(
      context: context,
      // Tam yükseklik kontrolüne izin verir
      isScrollControlled: true,
      builder: (ctx) => StationLocationsSheet(
        // Mevcut istasyonlar listesi
        stations: widget.controller.stations.value,
        // Seçili istasyon nesnesi
        selectedStation: widget.controller.selectedStation.value,
        // İstasyon seçildiğinde kontrolcüyü günceller
        onSelect: widget.controller.setStation,
      ),
    );
  }

  /// Kiralama ödeme diyaloğunu (Test kartı ve 3D secure SMS) açar
  void _openPaymentDialog(CarModel car) {
    showDialog(
      context: context,
      builder: (ctx) => PaymentReservationDialog(
        car: car,
        // Aktif seçili tarife modu (Günlük, Haftalık, Aylık)
        pricingType: widget.controller.pricingType.value,
        // Kiralama gün süresi
        days: widget.controller.rentalDays,
        // Ödeme başarıyla tamamlandığında rezervasyonu oluşturan callback
        onPaymentSuccess: () => _onPaymentCompleted(car),
      ),
    );
  }

  /// Ödeme tamamlandıktan sonra rezervasyon nesnesini oluşturup listeye ekler
  void _onPaymentCompleted(CarModel car) async {
    // Tarifeye göre doğru hesaplanan toplam tutar
    final totalCalculated = car.calculateTotal(
      type: widget.controller.pricingType.value,
      days: widget.controller.rentalDays,
    );

    // Yeni rezervasyon modeli oluşturur
    final newRez = ReservationModel(
      id: 'REZ-${DateTime.now().millisecondsSinceEpoch % 10000}',
      carModel: '${car.brand} ${car.model}',
      stationName: car.stationName,
      startDate: widget.controller.dateRange.value.start,
      endDate: widget.controller.dateRange.value.end,
      status: ReservationStatus.active,
      totalAmount: totalCalculated,
      hasHgsPenalty: false,
    );

    // Depo katmanına yeni rezervasyonu kaydeder
    await MockReservationRepository.instance.addReservation(newRez);
    if (!mounted) return;

    // Kullanıcıya yeşil başarı SnackBar'ı gösterir
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${car.brand} ${car.model} başarıyla kiralandı! (₺${totalCalculated.toStringAsFixed(0)})'),
        backgroundColor: Colors.green,
        // Doğrudan Rezervasyonlarım sayfasına gitme eylemi
        action: SnackBarAction(
          label: 'Görüntüle',
          textColor: Colors.white,
          onPressed: widget.onNavigateToReservations,
        ),
      ),
    );
  }

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyRent Araçlar'),
        actions: [
          // Sağ üstteki harita istasyonları ikonu
          IconButton(
            icon: const Icon(Icons.map_outlined),
            tooltip: 'Harita Teslim Noktaları',
            onPressed: _openStationSheet,
          ),
        ],
      ),
      // Kontrolcünün yükleniyor durumunu dinler
      body: ValueListenableBuilder<bool>(
        valueListenable: widget.controller.isLoading,
        builder: (context, loading, _) {
          // Yükleniyorsa gösterge koy
          if (loading) return const Center(child: CircularProgressIndicator());
          // Aşağı çekip yenileme (RefreshIndicator) özellikli liste
          return RefreshIndicator(
            onRefresh: widget.controller.loadCars,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. Bölüm: Tarih aralığı ve İstasyon seçimi
                _buildSearchControls(),
                const SizedBox(height: 16),
                // 2. Bölüm: Tarife çubuğu ve Müsaitlik filtresi
                _buildTariffAndFilterRow(),
                const SizedBox(height: 16),
                // 3. Bölüm: Araç kartları listesi
                _buildCarList(),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Takvim aralığı ve harita istasyon seçimi bileşenleri
  Widget _buildSearchControls() {
    return Column(
      children: [
        // Takvim aralığı seçici kartı
        ValueListenableBuilder(
          valueListenable: widget.controller.dateRange,
          builder: (context, range, _) => DateRangePickerCard(
            dateRange: range,
            onDateChanged: widget.controller.setDateRange,
          ),
        ),
        const SizedBox(height: 8),
        // Harita istasyon seçimi kartı
        ValueListenableBuilder(
          valueListenable: widget.controller.selectedStation,
          builder: (context, station, _) => Card(
            child: ListTile(
              leading: Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
              title: Text(station?.name ?? 'İstasyon Seçiniz'),
              subtitle: Text(station != null ? '${station.district} Teslim & İade (Haritada Göster)' : 'Harita üzerinden seç'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _openStationSheet,
            ),
          ),
        ),
      ],
    );
  }

  /// Tarife değiştirici butonlar ve müsait araç filtresi
  Widget _buildTariffAndFilterRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Günlük/Haftalık/Aylık tarife seçim çubuğu
        ValueListenableBuilder<PricingType>(
          valueListenable: widget.controller.pricingType,
          builder: (context, type, _) => RateToggleBar(
            selectedType: type,
            onTypeChanged: widget.controller.setPricingType,
          ),
        ),
        const SizedBox(height: 8),
        // Sadece müsait araçları filtreleme anahtarı
        ValueListenableBuilder<bool>(
          valueListenable: widget.controller.onlyAvailable,
          builder: (context, onlyAvail, _) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Taşmayı önlemek için Expanded ile sarılı filtre metni
              const Expanded(
                child: Text('Sadece Müsait Araçları Göster', style: TextStyle(fontSize: 13)),
              ),
              Switch.adaptive(
                value: onlyAvail,
                onChanged: widget.controller.toggleAvailableOnly,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Araç kartları listesi
  Widget _buildCarList() {
    return ValueListenableBuilder<List<CarModel>>(
      valueListenable: widget.controller.cars,
      builder: (context, cars, _) {
        // Uygun araç yoksa bilgilendirme metni
        if (cars.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: Text('Kriterlere uygun araç bulunamadı.')),
          );
        }
        // Araç kartlarını dinamik olarak listeler
        return ValueListenableBuilder<PricingType>(
          valueListenable: widget.controller.pricingType,
          builder: (context, type, _) => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cars.length,
            itemBuilder: (ctx, i) => CarCard(
              car: cars[i],
              pricingType: type,
              onRent: () => _openPaymentDialog(cars[i]),
            ),
          ),
        );
      },
    );
  }
}
