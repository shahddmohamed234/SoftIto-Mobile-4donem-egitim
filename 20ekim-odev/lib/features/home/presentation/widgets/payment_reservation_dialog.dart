// Flutter malzeme tasarımı ve diyalog sınıflarını içeri aktarır
import 'package:flutter/material.dart';
// Araç veri modelini ve tarife türü enum'ını içeri aktarır
import '../../data/models/car_model.dart';

/// PaymentReservationDialog: Kredi kartı ile kiralama ödemesini alan
/// ve 3D Secure SMS doğrulama adımıyla güvenliği sağlayan açılır penceredir.
class PaymentReservationDialog extends StatefulWidget {
  // Kiralanacak araç modeli
  final CarModel car;

  // Seçili olan fiyatlandırma tarifesi (Günlük, Haftalık, Aylık)
  final PricingType pricingType;

  // Kiralama yapılacak toplam gün sayısı
  final int days;

  // Ödeme ve 3D Secure SMS onayı başarılı olduğunda çağrılan fonksiyon
  final VoidCallback onPaymentSuccess;

  // PaymentReservationDialog sabit kurucu metodu
  const PaymentReservationDialog({
    super.key,
    // Araç parametresi zorunludur
    required this.car,
    // Tarife türü parametresi zorunludur
    required this.pricingType,
    // Gün sayısı zorunludur
    required this.days,
    // Başarı geri çağırımı zorunludur
    required this.onPaymentSuccess,
  });

  @override
  State<PaymentReservationDialog> createState() => _PaymentReservationDialogState();
}

class _PaymentReservationDialogState extends State<PaymentReservationDialog> {
  // Test kredi kartı numarası denetleyicisi (Örnek test verisi ile hazır)
  final _cardNoController = TextEditingController(text: '4543 1234 5678 9012');

  // Son kullanma tarihi (SKT) girdi denetleyicisi
  final _expiryController = TextEditingController(text: '12/28');

  // Güvenlik kodu (CVV) girdi denetleyicisi
  final _cvvController = TextEditingController(text: '883');

  // Ödeme işlemi simülasyonu yükleniyor bayrağı
  bool _isProcessing = false;

  @override
  void dispose() {
    // Kart numarası denetleyicisini bellekten temizler
    _cardNoController.dispose();
    // SKT denetleyicisini bellekten temizler
    _expiryController.dispose();
    // CVV denetleyicisini bellekten temizler
    _cvvController.dispose();
    // Üst sınıf dispose metodunu çağırır
    super.dispose();
  }

  // Seçilen tarifeye ve gün sayısına göre doğru hesaplanan toplam ücret
  double get _totalPrice => widget.car.calculateTotal(
        type: widget.pricingType,
        days: widget.days,
      );

  // Ödeme ve 3D Secure SMS onay akışını başlatan yardımcı metot
  void _startPaymentFlow() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        // SMS kodu girdi kontrolcüsü
        final smsController = TextEditingController();
        return AlertDialog(
          // Mavi güvenlik ikonu ve başlık
          title: const Row(
            children: [
              Icon(Icons.security, color: Colors.blue),
              SizedBox(width: 8),
              Expanded(child: Text('3D Secure SMS Onayı')),
            ],
          ),
          // Klavye açıldığında taşmayı önleyen kaydırılabilir içerik
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tutar ve test kodu bilgilendirme metni
                Text('₺${_totalPrice.toStringAsFixed(0)} tutarındaki kiralama için bankanızdan gelen 4 haneli SMS şifresini giriniz (Test: 1234):'),
                const SizedBox(height: 12),
                // 4 haneli SMS kod kutusu
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
          ),
          // Buton dikey boşluğu
          actionsOverflowButtonSpacing: 8,
          actions: [
            // İptal butonu
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
            // Kodu onaylayıp ödemeyi tamamlayan buton
            ElevatedButton(
              onPressed: () async {
                // Standart test kodu 1234 kontrolü
                if (smsController.text.trim() == '1234') {
                  Navigator.pop(ctx);
                  _finalizePayment();
                } else {
                  // Hatalı kod SnackBar uyarısı
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

  // Ödeme işlemini sonlandırıp ana ekrana haber veren metot
  void _finalizePayment() async {
    setState(() => _isProcessing = true);
    // 700 ms sahte banka onay gecikmesi
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isProcessing = false);
    // Kart diyaloğunu kapatır
    Navigator.of(context).pop();
    // Başarı geri çağırımını tetikler
    widget.onPaymentSuccess();
  }

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Kiralanacak araç başlığı
      title: Text('${widget.car.brand} ${widget.car.model}'),
      // Kaydırılabilir içerik gövdesi
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kiralama süresi, tarife ve tutar özeti kutusu
            _buildSummary(context),
            const SizedBox(height: 14),
            // Test kredi kartı rozeti
            _buildTestCardBadge(context),
            const SizedBox(height: 10),
            // Kart numarası, SKT ve CVV girdi kutuları
            _buildCardInputs(),
          ],
        ),
      ),
      // Dar ekranlarda butonların taşmasını önleyen dikey boşluk
      actionsOverflowButtonSpacing: 8,
      actions: [
        // Vazgeç butonu
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Vazgeç')),
        // Ödeme ve SMS onayını başlatan buton
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
          // Kiralama gün süresi
          Text('Kiralama Süresi: ${widget.days} Gün'),
          // Seçili tarife modu etiketi
          Text('Seçili Tarife Modu: ${widget.car.getRateLabel(widget.pricingType)}'),
          // Teslim istasyonu bilgisi
          Text('Teslim İstasyonu: ${widget.car.stationName}'),
          const Divider(),
          // Doğru hesaplanan toplam tutar
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
          // Sarı bilgi ikonu
          Icon(Icons.info_outline, size: 16, color: Colors.amber),
          SizedBox(width: 6),
          // Test kartı numarası ve test SMS kodu açıklaması
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
        // Kart numarası giriş kutusu
        TextField(
          controller: _cardNoController,
          decoration: const InputDecoration(labelText: 'Kart Numarası', prefixIcon: Icon(Icons.credit_card)),
        ),
        const SizedBox(height: 8),
        // SKT ve CVV yan yana alanları
        Row(
          children: [
            // Son kullanma tarihi kutusu
            Expanded(
              child: TextField(
                controller: _expiryController,
                decoration: const InputDecoration(labelText: 'SKT (AA/YY)'),
              ),
            ),
            const SizedBox(width: 8),
            // CVV güvenlik kodu kutusu
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
