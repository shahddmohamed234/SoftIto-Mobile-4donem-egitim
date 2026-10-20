// Flutter malzeme tasarımı kütüphanesini içeri aktarır
import 'package:flutter/material.dart';

/// AuthTextField: Giriş formundaki standart stilli, ikonlu ve doğrulamalı (validation) metin kutusudur.
class AuthTextField extends StatelessWidget {
  // Metin kutusundaki girdiyi yöneten denetleyici
  final TextEditingController controller;

  // Metin kutusunun üzerinde görünen alan etiketi (Örn: Ad Soyad)
  final String label;

  // Kullanıcıya rehberlik eden yer tutucu ipucu metni
  final String hintText;

  // Metin kutusunun sol tarafında yer alan ön ek ikonu
  final IconData prefixIcon;

  // Açılacak klavye türü (Sayısal, telefon, metin vb.)
  final TextInputType keyboardType;

  // Form doğrulama kuralı fonksiyonu (Geçersizse hata mesajı döner)
  final String? Function(String?)? validator;

  // AuthTextField sabit kurucu metodu
  const AuthTextField({
    super.key,
    // Kontrolcü zorunludur
    required this.controller,
    // Etiket zorunludur
    required this.label,
    // İpucu zorunludur
    required this.hintText,
    // Sol ikon zorunludur
    required this.prefixIcon,
    // Klavye türü varsayılan olarak normal metindir
    this.keyboardType = TextInputType.text,
    // Doğrulama fonksiyonu isteğe bağlıdır
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // 40 satır kuralına uygun atomik ve şık yapı
    return Padding(
      // Her form alanı altına 14px dikey boşluk ekler
      padding: const EdgeInsets.only(bottom: 14),
      // Form doğrulama özellikli metin girdi bileşeni
      child: TextFormField(
        // Metin denetleyicisini bağlar
        controller: controller,
        // Klavye türünü atar
        keyboardType: keyboardType,
        // Doğrulama kurallarını bağlar
        validator: validator,
        // Metin kutusu süsleme ve stil tanımları
        decoration: InputDecoration(
          // Alan etiketi
          labelText: label,
          // İpucu metni
          hintText: hintText,
          // Sol başa temaya uygun renkli ön ek ikonu yerleştirir
          prefixIcon: Icon(prefixIcon, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
