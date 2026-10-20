import 'package:flutter/material.dart';
import '../../data/models/car_model.dart';
import 'package:easy_rent/features/reservations/data/models/reservation_model.dart';
import 'package:easy_rent/features/reservations/data/repositories/mock_reservation_repository.dart';
import '../controllers/home_controller.dart';
import '../widgets/car_card.dart';
import '../widgets/date_range_picker_card.dart';
import '../widgets/payment_reservation_dialog.dart';
import '../widgets/rate_toggle_bar.dart';
import '../widgets/station_locations_sheet.dart';

/// HomeScreen: Araç listeleme, takvim seçimi, tarife modu ve harita istasyonlarının
/// gösterildiği ana kullanıcı ekranıdır.
class HomeScreen extends StatefulWidget {
  final HomeController controller;
  final VoidCallback onNavigateToReservations;

  const HomeScreen({
    super.key,
    required this.controller,
    required this.onNavigateToReservations,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Sayfa açıldığında istasyon ve araç verilerini yükle
    widget.controller.init();
  }

  /// Harita ve istasyon seçim panelini açar
  void _openStationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StationLocationsSheet(
        stations: widget.controller.stations.value,
        selectedStation: widget.controller.selectedStation.value,
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
        pricingType: widget.controller.pricingType.value,
        days: widget.controller.rentalDays,
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

    await MockReservationRepository.instance.addReservation(newRez);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${car.brand} ${car.model} başarıyla kiralandı! (₺${totalCalculated.toStringAsFixed(0)})'),
        backgroundColor: Colors.green,
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
          IconButton(
            icon: const Icon(Icons.map_outlined),
            tooltip: 'Harita Teslim Noktaları',
            onPressed: _openStationSheet,
          ),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: widget.controller.isLoading,
        builder: (context, loading, _) {
          if (loading) return const Center(child: CircularProgressIndicator());
          return RefreshIndicator(
            onRefresh: widget.controller.loadCars,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSearchControls(),
                const SizedBox(height: 16),
                _buildTariffAndFilterRow(),
                const SizedBox(height: 16),
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
        ValueListenableBuilder(
          valueListenable: widget.controller.dateRange,
          builder: (context, range, _) => DateRangePickerCard(
            dateRange: range,
            onDateChanged: widget.controller.setDateRange,
          ),
        ),
        const SizedBox(height: 8),
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
        ValueListenableBuilder<PricingType>(
          valueListenable: widget.controller.pricingType,
          builder: (context, type, _) => RateToggleBar(
            selectedType: type,
            onTypeChanged: widget.controller.setPricingType,
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<bool>(
          valueListenable: widget.controller.onlyAvailable,
          builder: (context, onlyAvail, _) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
        if (cars.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: Text('Kriterlere uygun araç bulunamadı.')),
          );
        }
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
