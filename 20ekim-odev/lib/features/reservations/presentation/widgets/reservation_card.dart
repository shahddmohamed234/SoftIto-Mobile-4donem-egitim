import 'package:flutter/material.dart';
import '../../data/models/reservation_model.dart';

/// ReservationCard: Rezervasyonun durumunu, geri teslimat takibini (kalan süre),
/// erken teslim ve sistemden süre uzatma eylemlerini barındıran kart bileşenidir.
class ReservationCard extends StatelessWidget {
  final ReservationModel reservation;
  final VoidCallback onExtend;
  final VoidCallback onEarlyReturn;
  final VoidCallback onViewPenalties;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.onExtend,
    required this.onEarlyReturn,
    required this.onViewPenalties,
  });

  String _format(DateTime date) => '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';

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
            _buildHeader(context),
            const SizedBox(height: 8),
            _buildDetails(context),
            if (reservation.status == ReservationStatus.active) ...[
              const SizedBox(height: 10),
              _buildReturnTrackingBox(context),
            ],
            if (reservation.totalExtraPenalties > 0) ...[
              const SizedBox(height: 10),
              _buildPenaltyAlert(context),
            ],
            const Divider(height: 20),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  /// Takip numarası ve durum rozeti
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(reservation.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
        _buildStatusBadge(context),
      ],
    );
  }

  /// Durum rozeti (Aktif, Onay Bekliyor, Tamamlandı)
  Widget _buildStatusBadge(BuildContext context) {
    Color color = reservation.status == ReservationStatus.active
        ? Colors.green
        : (reservation.status == ReservationStatus.pending ? Colors.orange : Colors.grey);
    String label = reservation.status == ReservationStatus.active
        ? 'Aktif Kiralama'
        : (reservation.status == ReservationStatus.pending ? 'Onay Bekliyor' : 'Tamamlandı');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  /// Araç modeli, istasyon, tarihler ve ödenen tutar
  Widget _buildDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(reservation.carModel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Teslim İstasyonu: ${reservation.stationName}', style: Theme.of(context).textTheme.bodySmall),
        Text('Tarih Aralığı: ${_format(reservation.startDate)} - ${_format(reservation.endDate)}', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text('Ödenen Kira Tutarı: ₺${reservation.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  /// Geri Teslimat Takibi kutusu (Kalan süre ve sistemden uzatma imkanı)
  Widget _buildReturnTrackingBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 16, color: Colors.blue),
              const SizedBox(width: 6),
              Text(
                'Geri Teslimat Takibi: ${reservation.remainingTimeText}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Süre bitmeden şubeye gitmeden sistem üzerinden kiralama sürenizi uzatabilirsiniz.',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// HGS veya gecikme cezası uyarısı
  Widget _buildPenaltyAlert(BuildContext context) {
    return InkWell(
      onTap: onViewPenalties,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '₺${reservation.totalExtraPenalties.toStringAsFixed(2)} bekleyen HGS / Ceza ödemesi var',
                style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const Icon(Icons.chevron_right, size: 18),
          ],
        ),
      ),
    );
  }

  /// Erken teslimat (iadesiz) ve Sistemden Süre Uzatma butonları
  Widget _buildActions(BuildContext context) {
    if (reservation.status != ReservationStatus.active) {
      return TextButton.icon(
        onPressed: onViewPenalties,
        icon: const Icon(Icons.receipt_long, size: 18),
        label: const Text('Ücret & HGS Detayı'),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: onEarlyReturn,
          child: const Text('Erken Teslim'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onExtend,
          child: const Text('Süre Uzat'),
        ),
      ],
    );
  }
}
