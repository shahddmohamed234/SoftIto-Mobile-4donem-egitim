import 'package:flutter/material.dart';
import '../../data/models/reservation_model.dart';

/// PenaltyHgsDialog: Otoyol/Köprü HGS geçiş tutarlarını ve varsa geç teslimat
/// cezalarını detaylı gösteren ve ödeme yapılmasını sağlayan penceredir.
class PenaltyHgsDialog extends StatelessWidget {
  final ReservationModel reservation;
  final VoidCallback onPay;

  const PenaltyHgsDialog({
    super.key,
    required this.reservation,
    required this.onPay,
  });

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.toll, color: Colors.orange),
          SizedBox(width: 8),
          Text('HGS & Ceza Detayları'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row('Rezervasyon Takip No', reservation.id),
          _row('Kiralanan Araç', reservation.carModel),
          const Divider(),
          _row('Otoyol/Köprü HGS Tutarı', '₺${reservation.hgsAmount.toStringAsFixed(2)}'),
          _row('Geç Teslimat Cezası', '₺${reservation.latePenaltyAmount.toStringAsFixed(2)}'),
          const Divider(),
          _row('Ödenecek Toplam Ekstra', '₺${reservation.totalExtraPenalties.toStringAsFixed(2)}', isBold: true),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kapat')),
        if (reservation.totalExtraPenalties > 0)
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () {
              Navigator.pop(context);
              onPay();
            },
            child: const Text('Borcu Şimdi Öde'),
          ),
      ],
    );
  }

  /// Satır bazlı bilgi etiketi ve değer hizalayıcısı
  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
