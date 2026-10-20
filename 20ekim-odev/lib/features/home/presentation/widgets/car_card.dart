// Flutter malzeme tasarımı ve UI widget kütüphanesini içeri aktarır
import 'package:flutter/material.dart';
// Araç veri modelini ve tarife türü enum'ını içeri aktarır
import '../../data/models/car_model.dart';

/// CarCard: Araç listesinde marka, model, özellikler, fiyat etiketi
/// ve kiralama eylemini barındıran kart bileşenidir.
class CarCard extends StatelessWidget {
  // Kart üzerinde görüntülenecek araç modeli
  final CarModel car;

  // Seçili olan fiyatlandırma tarifesi türü
  final PricingType pricingType;

  // Hemen Kirala butonuna tıklandığında ödeme diyaloğunu açan fonksiyon
  final VoidCallback onRent;

  // CarCard sabit kurucu metodu
  const CarCard({
    super.key,
    // Araç nesnesi zorunludur
    required this.car,
    // Fiyatlandırma türü zorunludur
    required this.pricingType,
    // Kiralama geri çağırımı zorunludur
    required this.onRent,
  });

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    return Card(
      // Kartlar arası 14px alt boşluk
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        // Kart içi 16px dolgu boşluğu
        padding: const EdgeInsets.all(16),
        child: Column(
          // İçerikleri sola dayar
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Kısım: Marka, model, yıl, istasyon ve müsaitlik rozeti
            _buildTopRow(context),
            const SizedBox(height: 12),
            // 2. Kısım: Yakıt, vites ve koltuk özellik çipleri
            _buildFeaturesRow(context),
            const Divider(height: 24),
            // 3. Kısım: Tarife fiyatı ve Hemen Kirala butonu
            _buildBottomRow(context),
          ],
        ),
      ),
    );
  }

  /// Marka, model ve müsaitlik rozeti (Taşmayı önlemek için Expanded ile sarılı)
  Widget _buildTopRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sol başlık sütunu
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Araç marka ve modeli
              Text(
                '${car.brand} ${car.model}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              // Araç model yılı ve bulunduğu istasyon
              Text(
                '${car.year} Model • ${car.stationName}',
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Sağ taraftaki Müsait / Dolu rozeti
        _buildAvailabilityChip(context),
      ],
    );
  }

  /// Müsaitlik durumunu gösteren rozet
  Widget _buildAvailabilityChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        // Müsait ise yeşil, dolu ise hata rengi (kırmızı) arka plan
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

  /// Yakıt, vites ve koltuk özellik etiketleri (Wrap ile alt satıra geçebilir, taşmaz)
  Widget _buildFeaturesRow(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        // Yakıt tipi rozeti
        _chip(context, Icons.local_gas_station_outlined, car.fuelType),
        // Şanzıman türü rozeti
        _chip(context, Icons.settings_suggest_outlined, car.transmission),
        // Koltuk sayısı rozeti
        _chip(context, Icons.airline_seat_recline_normal, '${car.seats} Kişilik'),
      ],
    );
  }

  /// Rozet (Chip) inşa edici yardımcı metot
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
        // Fiyat bilgisi sütunu
        Expanded(
          child: Column(
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Hemen Kirala butonu (Araç müsait değilse pasifleşir)
        ElevatedButton(
          onPressed: car.isAvailable ? onRent : null,
          child: const Text('Hemen Kirala'),
        ),
      ],
    );
  }
}
