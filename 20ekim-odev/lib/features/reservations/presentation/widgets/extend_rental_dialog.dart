import 'package:flutter/material.dart';
import '../../data/models/reservation_model.dart';

/// ExtendRentalDialog: Kullanıcıların şubeye gitmeden doğrudan sistem üzerinden
/// araç kiralama sürelerini uzatmasını sağlayan açılır penceredir.
class ExtendRentalDialog extends StatefulWidget {
  final ReservationModel reservation;
  final void Function(int extraDays, double extraCost) onConfirm;

  const ExtendRentalDialog({
    super.key,
    required this.reservation,
    required this.onConfirm,
  });

  @override
  State<ExtendRentalDialog> createState() => _ExtendRentalDialogState();
}

class _ExtendRentalDialogState extends State<ExtendRentalDialog> {
  int _extraDays = 1;
  // Günlük ek uzatma baz ücreti
  static const double _dailyRate = 1200.0;

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    final cost = _extraDays * _dailyRate;
    return AlertDialog(
      title: const Text('Sistem Üzerinden Süre Uzatma'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoBanner(context),
            const SizedBox(height: 12),
            _buildDaysSelector(),
            const SizedBox(height: 12),
            Text('Ek Kiralama Bedeli: ₺${cost.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
      actionsOverflowButtonSpacing: 8,
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
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
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: _extraDays > 1 ? () => setState(() => _extraDays--) : null,
        ),
        Text('+$_extraDays Gün', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: _extraDays < 14 ? () => setState(() => _extraDays++) : null,
        ),
      ],
    );
  }
}
