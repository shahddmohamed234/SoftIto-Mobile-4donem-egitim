// Flutter malzeme tasarımı ve diyalog sınıflarını içeri aktarır
import 'package:flutter/material.dart';
// Rezervasyon veri modelini içeri aktarır
import '../../data/models/reservation_model.dart';

/// ExtendRentalDialog: Kullanıcıların şubeye gitmeden doğrudan sistem üzerinden
/// araç kiralama sürelerini uzatmasını sağlayan açılır penceredir.
class ExtendRentalDialog extends StatefulWidget {
  // Süresi uzatılacak olan rezervasyon modeli
  final ReservationModel reservation;

  // Uzatma onaylandığında ek gün sayısı ve hesaplanan ek maliyeti ileten fonksiyon
  final void Function(int extraDays, double extraCost) onConfirm;

  // ExtendRentalDialog sabit kurucu metodu
  const ExtendRentalDialog({
    super.key,
    // Rezervasyon parametresi zorunludur
    required this.reservation,
    // Onay fonksiyonu zorunludur
    required this.onConfirm,
  });

  @override
  State<ExtendRentalDialog> createState() => _ExtendRentalDialogState();
}

class _ExtendRentalDialogState extends State<ExtendRentalDialog> {
  // Seçilen ek gün sayısı (Varsayılan 1 gün)
  int _extraDays = 1;

  // Günlük ek uzatma baz ücreti (1200 TL/gün)
  static const double _dailyRate = 1200.0;

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    // Ek gün ve baz ücrete göre toplam ek maliyet hesabı
    final cost = _extraDays * _dailyRate;
    return AlertDialog(
      // Diyalog başlığı
      title: const Text('Sistem Üzerinden Süre Uzatma'),
      // Küçük ekranlarda veya yatay modda taşmayı önleyen kaydırılabilir içerik
      content: SingleChildScrollView(
        child: Column(
          // İçeriği dikeyde minimum boyutta tutar
          mainAxisSize: MainAxisSize.min,
          children: [
            // Şubeye gitmeden uzatma kuralı bilgilendirme bandı
            _buildInfoBanner(context),
            const SizedBox(height: 12),
            // Gün artırma ve azaltma seçicisi (- 1 Gün +)
            _buildDaysSelector(),
            const SizedBox(height: 12),
            // Dinamik olarak hesaplanan ek kiralama bedeli
            Text('Ek Kiralama Bedeli: ₺${cost.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
      // Dar ekranlarda butonların taşmasını önleyen dikey boşluk
      actionsOverflowButtonSpacing: 8,
      actions: [
        // Vazgeçme butonu
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
        // Onaylama ve süreyi uzatma butonu
        ElevatedButton(
          onPressed: () {
            // Pencereyi kapatır
            Navigator.pop(context);
            // Seçilen ek gün ve tutarı onaylayarak bildirir
            widget.onConfirm(_extraDays, cost);
          },
          child: const Text('Onayla ve Süreyi Uzat'),
        ),
      ],
    );
  }

  /// Doğrudan sistemden uzatma imkanı sağlayan bilgilendirme kutusu
  Widget _buildInfoBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'Kira sürenizi şubeye gitmeden doğrudan sistemimiz üzerinden anında uzatabilirsiniz.',
        style: TextStyle(fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Gün artırma ve azaltma seçicisi
  Widget _buildDaysSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Gün azaltma ikonu (En az 1 gün)
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: _extraDays > 1 ? () => setState(() => _extraDays--) : null,
        ),
        // Seçilen ek gün sayısı metni
        Text('+$_extraDays Gün', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        // Gün artırma ikonu (En fazla 14 gün)
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: _extraDays < 14 ? () => setState(() => _extraDays++) : null,
        ),
      ],
    );
  }
}
