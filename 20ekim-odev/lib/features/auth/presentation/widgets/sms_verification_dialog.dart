// Flutter malzeme tasarımı ve diyalog sınıflarını içeri aktarır
import 'package:flutter/material.dart';

/// SmsVerificationDialog: Kullanıcının telefonuna gelen 4 haneli
/// SMS doğrulama kodunu (Test kodu: 1234) girdiği açılır penceredir.
class SmsVerificationDialog extends StatefulWidget {
  // Doğrulama kodunun gönderildiği telefon numarası
  final String phoneNumber;

  // Doğrulama butonuna basıldığında kodu üst widget'a ileten geri çağırım fonksiyonu
  final ValueChanged<String> onVerify;

  // Diyalog sabit kurucu metodu
  const SmsVerificationDialog({
    super.key,
    // Telefon numarası zorunludur
    required this.phoneNumber,
    // Onay fonksiyonu zorunludur
    required this.onVerify,
  });

  @override
  State<SmsVerificationDialog> createState() => _SmsVerificationDialogState();
}

class _SmsVerificationDialogState extends State<SmsVerificationDialog> {
  // SMS kodunun yazıldığı metin kutusunun kontrolcüsü
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    // Kontrolcüyü bellekten temizler
    _codeController.dispose();
    // Üst sınıf dispose metodunu çağırır
    super.dispose();
  }

  // Kod girilip onaylandığında tetiklenen onaylama yordamı
  void _submit() {
    // Metin kutusundaki değeri baş ve son boşluklardan arındırarak alır
    final code = _codeController.text.trim();
    // Kod boş değilse doğrulama geri çağırımını tetikler
    if (code.isNotEmpty) {
      widget.onVerify(code);
    }
  }

  // 40 satır kuralına uygun diyalog gövdesi
  @override
  Widget build(BuildContext context) {
    // Standart Material uyarı ve işlem penceresi
    return AlertDialog(
      // Ortalanmış diyalog başlığı
      title: const Text('SMS Doğrulama Kodu', textAlign: TextAlign.center),
      // Klavye açıldığında dikey taşmayı önleyen kaydırılabilir içerik alanı
      content: SingleChildScrollView(
        child: Column(
          // İçeriği sığdığı kadar dikeyde minimum tutar
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bilgilendirici açıklama metni ve test kodu ipucu
            Text(
              '${widget.phoneNumber} numarasına gönderilen 4 haneli kodu giriniz (Test: 1234)',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            // Metin kutusu ile açıklama arasına 16px boşluk
            const SizedBox(height: 16),
            // 4 haneli kod giriş alanı
            TextField(
              // Metin kontrolcüsünü bağlar
              controller: _codeController,
              // Sayısal klavye açar
              keyboardType: TextInputType.number,
              // En fazla 4 karakter girilmesine izin verir
              maxLength: 4,
              // Metni ortalar
              textAlign: TextAlign.center,
              // Büyük puntolu ve aralıklı PIN stili
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8),
              // Sayaç yazısını gizler ve yer tutucu koyar
              decoration: const InputDecoration(hintText: '----', counterText: ''),
            ),
          ],
        ),
      ),
      // Dar ekranlarda butonların taşmasını önleyen dikey boşluk ayarı
      actionsOverflowButtonSpacing: 8,
      // Diyalog alt eylem butonları
      actions: [
        // Diyaloğu kapatan İptal butonu
        TextButton(
          // Pencereyi kapatır
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        // Kodu onaylayıp girişi tamamlayan buton
        ElevatedButton(
          // Onay metodunu çalıştırır
          onPressed: _submit,
          child: const Text('Onayla ve Giriş Yap'),
        ),
      ],
    );
  }
}
