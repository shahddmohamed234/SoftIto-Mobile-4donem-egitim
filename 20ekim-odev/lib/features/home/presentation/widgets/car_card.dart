import 'package:flutter/material.dart';
import '../../data/models/car_model.dart';

/// CarCard: Araç listesinde marka, model, özellikler, fiyat etiketi
/// ve kiralama eylemini barındıran kart bileşenidir.
class CarCard extends StatelessWidget {
  final CarModel car;
  final PricingType pricingType;
  final VoidCallback onRent;

  const CarCard({
    super.key,
    required this.car,
    required this.pricingType,
    required this.onRent,
  });

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopRow(context),
            const SizedBox(height: 12),
            _buildFeaturesRow(context),
            const Divider(height: 24),
            _buildBottomRow(context),
          ],
        ),
      ),
    );
  }

  /// Marka, model ve müsaitlik rozeti
  Widget _buildTopRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${car.brand} ${car.model}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 2),
            Text('${car.year} Model • ${car.stationName}', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        _buildAvailabilityChip(context),
      ],
    );
  }

  /// Müsaitlik durumunu gösteren rozet
  Widget _buildAvailabilityChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: car.isAvailable
            ? Colors.green.withValues(alpha: 0.15)
            : Theme.of(context).colorScheme.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        car.isAvailable ? 'Müsait' : 'Dolu',
        style: TextStyle(
          color: car.isAvailable ? Colors.green : Theme.of(context).colorScheme.error,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Yakıt, vites ve koltuk özellik etiketleri
  Widget _buildFeaturesRow(BuildContext context) {
    return Row(
      children: [
        _chip(context, Icons.local_gas_station_outlined, car.fuelType),
        const SizedBox(width: 8),
        _chip(context, Icons.settings_suggest_outlined, car.transmission),
        const SizedBox(width: 8),
        _chip(context, Icons.airline_seat_recline_normal, '${car.seats} Kişilik'),
      ],
    );
  }

  Widget _chip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  /// Seçili tarife etiketine göre fiyat ve Hemen Kirala butonu
  Widget _buildBottomRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tarife Fiyatı', style: Theme.of(context).textTheme.bodySmall),
            Text(
              car.getRateLabel(pricingType),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: car.isAvailable ? onRent : null,
          child: const Text('Hemen Kirala'),
        ),
      ],
    );
  }
}
