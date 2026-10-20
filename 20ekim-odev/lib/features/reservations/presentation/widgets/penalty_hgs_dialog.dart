// Flutter malzeme tasarımı ve diyalog sınıflarını içeri aktarır
import 'package:flutter/material.dart';
// Rezervasyon veri modelini içeri aktarır
import '../../data/models/reservation_model.dart';

/// PenaltyHgsDialog: Otoyol/Köprü HGS geçiş tutarlarını ve varsa geç teslimat
/// cezalarını detaylı gösteren ve ödeme yapılmasını sağlayan penceredir.
class PenaltyHgsDialog extends StatelessWidget {
  // İncelenen rezervasyon nesnesi
  final ReservationModel reservation;

  // Borç ödendiğinde tetiklenecek fonksiyon
  final VoidCallback onPay;

  // PenaltyHgsDialog sabit kurucu metodu
  const PenaltyHgsDialog({
    super.key,
    // Rezervasyon parametresi zorunludur
    required this.reservation,
    // Ödeme geri çağırımı zorunludur
    required this.onPay,
  });

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    // Ceza ve HGS detaylarını gösteren AlertDialog
    return AlertDialog(
      // Turuncu ücret/gişe ikonu ve başlık
      title: const Row(
        children: [
          Icon(Icons.toll, color: Colors.orange),
          SizedBox(width: 8),
          Expanded(child: Text('HGS & Ceza Detayları')),
        ],
      ),
      // Dikey taşmayı önleyen kaydırılabilir içerik gövdesi
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Takip numarası satırı
            _row('Rezervasyon Takip No', reservation.id),
            // Kiralanan araç bilgisi satırı
            _row('Kiralanan Araç', reservation.carModel),
            const Divider(),
            // Köprü ve otoyol geçiş tutarı
            _row('Otoyol/Köprü HGS Tutarı', '₺${reservation.hgsAmount.toStringAsFixed(2)}'),
            // Varsa geç teslimat cezası
            _row('Geç Teslimat Cezası', '₺${reservation.latePenaltyAmount.toStringAsFixed(2)}'),
            const Divider(),
            // Toplam ödenecek ekstra borç tutarı
            _row('Ödenecek Toplam Ekstra', '₺${reservation.totalExtraPenalties.toStringAsFixed(2)}', isBold: true),
          ],
        ),
      ),
      // Dar ekranlarda butonların taşmasını önleyen dikey boşluk
      actionsOverflowButtonSpacing: 8,
      actions: [
        // Pencereyi kapatma butonu
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kapat')),
        // Borç varsa ödeme yapma butonu
        if (reservation.totalExtraPenalties > 0)
          ElevatedButton(
            // Kırmızı renkli ödeme butonu stili
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () {
              // Diyaloğu kapat
              Navigator.pop(context);
              // Ödeme işlemini başlat
              onPay();
            },
            child: const Text('Borcu Şimdi Öde'),
          ),
      ],
    );
  }

  /// Satır bazlı bilgi etiketi ve değer hizalayıcısı (Yatay taşmayı önler)
  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      // Dikey 4px boşluk
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sol etiket (Geniş alanı esnek kullanarak taşmayı engeller)
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          const SizedBox(width: 8),
          // Sağ değer metni
          Text(
            value,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
