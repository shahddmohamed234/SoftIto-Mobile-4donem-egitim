import 'package:flutter/material.dart';

/// SmsVerificationDialog: Kullanıcının telefonuna gelen 4 haneli
/// SMS doğrulama kodunu (Test kodu: 1234) girdiği açılır penceredir.
class SmsVerificationDialog extends StatefulWidget {
  final String phoneNumber;
  final ValueChanged<String> onVerify;

  const SmsVerificationDialog({
    super.key,
    required this.phoneNumber,
    required this.onVerify,
  });

  @override
  State<SmsVerificationDialog> createState() => _SmsVerificationDialogState();
}

class _SmsVerificationDialogState extends State<SmsVerificationDialog> {
  // SMS kodu metin kontrolcüsü
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  // Kod girilip onaylandığında tetiklenir
  void _submit() {
    final code = _codeController.text.trim();
    if (code.isNotEmpty) {
      widget.onVerify(code);
    }
  }

  // 40 satır kuralına uygun diyalog gövdesi
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('SMS Doğrulama Kodu', textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${widget.phoneNumber} numarasına gönderilen 4 haneli kodu giriniz (Test: 1234)',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8),
              decoration: const InputDecoration(hintText: '----', counterText: ''),
            ),
          ],
        ),
      ),
      actionsOverflowButtonSpacing: 8,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Onayla ve Giriş Yap'),
        ),
      ],
    );
  }
}
