import 'package:flutter/material.dart';
import '../../data/models/car_model.dart';

/// PaymentReservationDialog: Kredi kartı ile kiralama ödemesini alan
/// ve 3D Secure SMS doğrulama adımıyla güvenliği sağlayan açılır penceredir.
class PaymentReservationDialog extends StatefulWidget {
  final CarModel car;
  final PricingType pricingType;
  final int days;
  final VoidCallback onPaymentSuccess;

  const PaymentReservationDialog({
    super.key,
    required this.car,
    required this.pricingType,
    required this.days,
    required this.onPaymentSuccess,
  });

  @override
  State<PaymentReservationDialog> createState() => _PaymentReservationDialogState();
}

class _PaymentReservationDialogState extends State<PaymentReservationDialog> {
  // Test kartı bilgileri
  final _cardNoController = TextEditingController(text: '4543 1234 5678 9012');
  final _expiryController = TextEditingController(text: '12/28');
  final _cvvController = TextEditingController(text: '883');
  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNoController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  // Seçilen tarifeye ve gün sayısına göre doğru hesaplanan toplam ücret
  double get _totalPrice => widget.car.calculateTotal(
        type: widget.pricingType,
        days: widget.days,
      );

  // Ödeme ve 3D Secure SMS onay akışı
  void _startPaymentFlow() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final smsController = TextEditingController();
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.security, color: Colors.blue),
              SizedBox(width: 8),
              Text('3D Secure SMS Onayı'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('₺${_totalPrice.toStringAsFixed(0)} tutarındaki kiralama için bankanızdan gelen 4 haneli SMS şifresini giriniz (Test: 1234):'),
              const SizedBox(height: 12),
              TextField(
                controller: smsController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 6),
                decoration: const InputDecoration(hintText: '----', counterText: ''),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
            ElevatedButton(
              onPressed: () async {
                if (smsController.text.trim() == '1234') {
                  Navigator.pop(ctx);
                  _finalizePayment();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hatalı SMS kodu! Test kodu: 1234'), backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text('Onayla ve Bitir'),
            ),
          ],
        );
      },
    );
  }

  void _finalizePayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isProcessing = false);
    Navigator.of(context).pop();
    widget.onPaymentSuccess();
  }

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.car.brand} ${widget.car.model}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummary(context),
            const SizedBox(height: 14),
            _buildTestCardBadge(context),
            const SizedBox(height: 10),
            _buildCardInputs(),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Vazgeç')),
        ElevatedButton(
          onPressed: _isProcessing ? null : _startPaymentFlow,
          child: _isProcessing
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : Text('₺${_totalPrice.toStringAsFixed(0)} Öde (SMS Al)'),
        ),
      ],
    );
  }

  /// Kiralama süresi, tarife türü ve net hesaplanan tutar özeti
  Widget _buildSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kiralama Süresi: ${widget.days} Gün'),
          Text('Seçili Tarife Modu: ${widget.car.getRateLabel(widget.pricingType)}'),
          Text('Teslim İstasyonu: ${widget.car.stationName}'),
          const Divider(),
          Text(
            'Hesaplanan Toplam Tutar: ₺${_totalPrice.toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// Test kartı bilgilendirme rozeti
  Widget _buildTestCardBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: Colors.amber),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              'Test Kredi Kartı: 4543 1234 5678 9012 (Ödeme SMS Kodu: 1234)',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// Kart numarası ve SKT/CVV girdi alanları
  Widget _buildCardInputs() {
    return Column(
      children: [
        TextField(
          controller: _cardNoController,
          decoration: const InputDecoration(labelText: 'Kart Numarası', prefixIcon: Icon(Icons.credit_card)),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _expiryController,
                decoration: const InputDecoration(labelText: 'SKT (AA/YY)'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _cvvController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'CVV'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
