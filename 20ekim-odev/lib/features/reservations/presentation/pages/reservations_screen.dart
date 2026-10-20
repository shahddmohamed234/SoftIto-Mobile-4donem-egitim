import 'package:flutter/material.dart';
import '../../data/models/reservation_model.dart';
import '../controllers/reservations_controller.dart';
import '../widgets/extend_rental_dialog.dart';
import '../widgets/penalty_hgs_dialog.dart';
import '../widgets/reservation_card.dart';

/// ReservationsScreen: Aktif ve geçmiş kiralamaların, geri teslimat takibinin,
/// süre uzatma ve iadesiz erken teslimat işlemlerinin yönetildiği ekrandır.
class ReservationsScreen extends StatefulWidget {
  final ReservationsController controller;

  const ReservationsScreen({super.key, required this.controller});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  @override
  void initState() {
    super.initState();
    // Sayfa açıldığında rezervasyon listesini yükle
    widget.controller.loadReservations();
  }

  /// Doğrudan sistem üzerinden kiralama süresini uzatma diyaloğunu açar
  void _onExtend(ReservationModel r) {
    showDialog(
      context: context,
      builder: (ctx) => ExtendRentalDialog(
        reservation: r,
        onConfirm: (days, cost) async {
          final ok = await widget.controller.extendRental(r.id, days, cost);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ok ? 'Kiralama süreniz sistem üzerinden $days gün uzatıldı!' : 'Hata oluştu!'),
              backgroundColor: ok ? Colors.green : Theme.of(context).colorScheme.error,
            ),
          );
        },
      ),
    );
  }

  /// Erken teslimat onayı (Kullanıcıya ücret iadesi yapılmayacağı açıkça bildirilir)
  void _onEarlyReturn(ReservationModel r) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Erken Teslimat Uyarısı'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${r.carModel} aracını planlanan tarihten önce erken teslim etmek üzeresiniz.'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: const Text(
                'ÖNEMLİ KURAL: Rezervasyon sözleşmesi gereğince erken teslim edilen gün ve saatler için KESİNLİKLE ÜCRET İADESİ YAPILMAYACAKTIR.',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Vazgeç')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () async {
              Navigator.pop(ctx);
              final ok = await widget.controller.earlyReturn(r.id);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(ok ? 'Araç teslim edildi (Erken teslim şartı: İade yapılmadı).' : 'Hata oluştu!'),
                  backgroundColor: ok ? Colors.green : Theme.of(context).colorScheme.error,
                ),
              );
            },
            child: const Text('İadesiz Teslim Et'),
          ),
        ],
      ),
    );
  }

  /// HGS ve geç teslim cezaları kontrol diyaloğu
  void _onViewPenalties(ReservationModel r) {
    showDialog(
      context: context,
      builder: (ctx) => PenaltyHgsDialog(
        reservation: r,
        onPay: () async {
          final ok = await widget.controller.payPenalties(r.id);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ok ? 'HGS ve ceza borçları başarıyla ödendi!' : 'Ödeme başarısız!'),
              backgroundColor: ok ? Colors.green : Theme.of(context).colorScheme.error,
            ),
          );
        },
      ),
    );
  }

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rezervasyonlarım')),
      body: ValueListenableBuilder<bool>(
        valueListenable: widget.controller.isLoading,
        builder: (context, loading, _) {
          if (loading) return const Center(child: CircularProgressIndicator());
          return RefreshIndicator(
            onRefresh: widget.controller.loadReservations,
            child: _buildList(),
          );
        },
      ),
    );
  }

  /// Rezervasyon kartları listesi
  Widget _buildList() {
    return ValueListenableBuilder<List<ReservationModel>>(
      valueListenable: widget.controller.reservations,
      builder: (context, list, _) {
        if (list.isEmpty) {
          return const Center(child: Text('Henüz kayıtlı rezervasyonunuz bulunmuyor.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (ctx, i) => ReservationCard(
            reservation: list[i],
            onExtend: () => _onExtend(list[i]),
            onEarlyReturn: () => _onEarlyReturn(list[i]),
            onViewPenalties: () => _onViewPenalties(list[i]),
          ),
        );
      },
    );
  }
}
