// Flutter malzeme tasarımı kütüphanesini içeri aktarır
import 'package:flutter/material.dart';
// Rezervasyon veri modelini içeri aktarır
import '../../data/models/reservation_model.dart';

/// ReservationCard: Rezervasyonun durumunu, geri teslimat takibini (kalan süre),
/// erken teslim ve sistemden süre uzatma eylemlerini barındıran kart bileşenidir.
class ReservationCard extends StatelessWidget {
  // Görüntülenecek rezervasyon modeli
  final ReservationModel reservation;

  // Sistemden süre uzatma diyaloğunu açan fonksiyon
  final VoidCallback onExtend;

  // İadesiz erken teslimat onay diyaloğunu açan fonksiyon
  final VoidCallback onEarlyReturn;

  // Varsa HGS ve ceza borç detaylarını gösteren fonksiyon
  final VoidCallback onViewPenalties;

  // ReservationCard sabit kurucu metodu
  const ReservationCard({
    super.key,
    // Rezervasyon parametresi zorunludur
    required this.reservation,
    // Süre uzatma geri çağırımı zorunludur
    required this.onExtend,
    // Erken teslim geri çağırımı zorunludur
    required this.onEarlyReturn,
    // Ceza görüntüleme geri çağırımı zorunludur
    required this.onViewPenalties,
  });

  // Tarihleri GG.AA.YYYY formatına çeviren yardımcı metot
  String _format(DateTime date) => '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    return Card(
      // Kartlar arası alt 14px boşluk
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        // Kart içi 16px dolgu boşluğu
        padding: const EdgeInsets.all(16),
        child: Column(
          // İçerikleri sola dayar
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Kısım: Takip No ve Durum Rozeti
            _buildHeader(context),
            const SizedBox(height: 8),
            // 2. Kısım: Araç, İstasyon, Tarihler ve Fiyat Detayları
            _buildDetails(context),
            // Aktif kiralamalarda dinamik geri teslimat takibi kutusu
            if (reservation.status == ReservationStatus.active) ...[
              const SizedBox(height: 10),
              _buildReturnTrackingBox(context),
            ],
            // Ekstra HGS veya geç teslimat cezası varsa kırmızı uyarı kutusu
            if (reservation.totalExtraPenalties > 0) ...[
              const SizedBox(height: 10),
              _buildPenaltyAlert(context),
            ],
            const Divider(height: 20),
            // 3. Kısım: Aksiyon butonları (Erken Teslim, Süre Uzat vb.)
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  /// Takip numarası ve durum rozeti (Yatay taşmaya karşı korumalı)
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Takip numarası (Taşmayı önlemek için Expanded ile sarılı)
        Expanded(
          child: Text(
            reservation.id,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        // Durum rozeti (Aktif / Bekliyor / Tamamlandı)
        _buildStatusBadge(context),
      ],
    );
  }

  /// Durum rozeti (Aktif, Onay Bekliyor, Tamamlandı)
  Widget _buildStatusBadge(BuildContext context) {
    // Duruma göre rozet rengi belirleme
    Color color = reservation.status == ReservationStatus.active
        ? Colors.green
        : (reservation.status == ReservationStatus.pending ? Colors.orange : Colors.grey);
    // Duruma göre rozet metni belirleme
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
        // Araç model başlığı
        Text(reservation.carModel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        // Teslim istasyonu adı
        Text('Teslim İstasyonu: ${reservation.stationName}', style: Theme.of(context).textTheme.bodySmall),
        // Başlangıç ve bitiş tarih aralığı
        Text('Tarih Aralığı: ${_format(reservation.startDate)} - ${_format(reservation.endDate)}', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        // Ödenen kira tutarı
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
              // Mavi sayaç ikonu
              const Icon(Icons.timer_outlined, size: 16, color: Colors.blue),
              const SizedBox(width: 6),
              // Kalan süre metni (Taşmayı önlemek için Expanded ile sarılı)
              Expanded(
                child: Text(
                  'Geri Teslimat Takibi: ${reservation.remainingTimeText}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Süre uzatma bilgilendirmesi
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
      // Tıklandığında ceza detay diyaloğunu açar
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
            // Kırmızı uyarı üçgen ikonu
            Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error, size: 20),
            const SizedBox(width: 8),
            // Ceza borç tutarı açıklaması
            Expanded(
              child: Text(
                '₺${reservation.totalExtraPenalties.toStringAsFixed(2)} bekleyen HGS / Ceza ödemesi var',
                style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            // Sağ ok ikonu
            const Icon(Icons.chevron_right, size: 18),
          ],
        ),
      ),
    );
  }

  /// Erken teslimat (iadesiz) ve Sistemden Süre Uzatma butonları (Wrap ile responsive)
  Widget _buildActions(BuildContext context) {
    // Aktif olmayan rezervasyonlar için sadece detay butonu göster
    if (reservation.status != ReservationStatus.active) {
      return TextButton.icon(
        onPressed: onViewPenalties,
        icon: const Icon(Icons.receipt_long, size: 18),
        label: const Text('Ücret & HGS Detayı'),
      );
    }
    // Aktif rezervasyonlar için Erken Teslim ve Süre Uzat butonları
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 8,
      runSpacing: 8,
      children: [
        // İadesiz erken teslimat butonu
        OutlinedButton(
          onPressed: onEarlyReturn,
          child: const Text('Erken Teslim'),
        ),
        // Şubeye gitmeden sistemden süre uzatma butonu
        ElevatedButton(
          onPressed: onExtend,
          child: const Text('Süre Uzat'),
        ),
      ],
    );
  }
}
