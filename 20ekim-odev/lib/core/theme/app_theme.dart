// Flutter malzeme tasarımı kütüphanesini içeri aktarır
import 'package:flutter/material.dart';
// Uygulama renk paleti sabitlerini içeri aktarır
import '../constants/app_colors.dart';

/// AppTheme: Material Design 3 kurallarına uygun olarak hazırlanmış
/// Açık (Mavi ağırlıklı) ve Koyu (Kırmızı vurgulu) tema yapılandırmalarını içerir.
class AppTheme {
  // Sınıfın dışarıdan örneklenmesini engelleyen özel (private) kurucu metot
  AppTheme._();

  /// Açık Tema: Mavi Ağırlıklı Ferah Tasarım
  static ThemeData get lightTheme {
    // Açık temaya özgü Material 3 renk şeması tanımlaması
    const colorScheme = ColorScheme.light(
      // Ana tema rengi: Ferah mavi
      primary: AppColors.primaryBlue,
      // Ana renk üzerindeki metin/ikon rengi: Saf beyaz
      onPrimary: Colors.white,
      // İkincil vurgu rengi: Kırmızı
      secondary: AppColors.primaryRed,
      // İkincil renk üzerindeki metin rengi: Beyaz
      onSecondary: Colors.white,
      // Kart ve diyalog yüzey rengi: Beyaz
      surface: AppColors.lightSurface,
      // Yüzey üzerindeki birincil metin rengi: Koyu antrasit
      onSurface: AppColors.lightTextPrimary,
      // Hata durum rengi: Kırmızı
      error: AppColors.primaryRed,
      // Hata rengi üzerindeki metin rengi: Beyaz
      onError: Colors.white,
    );

    // Açık tema için ThemeData nesnesi inşa edilip döndürülür
    return ThemeData(
      // Material 3 tasarım dilini etkinleştirir
      useMaterial3: true,
      // Renk paleti şemasını bağlar
      colorScheme: colorScheme,
      // Sayfaların varsayılan arka plan rengini ayarlar
      scaffoldBackgroundColor: AppColors.lightBackground,
      // Sayfa üst çubuğu (AppBar) görsel tema ayarları
      appBarTheme: const AppBarTheme(
        // Üst çubuk arka plan rengi
        backgroundColor: Colors.white,
        // Üst çubuk metin ve ikon rengi
        foregroundColor: AppColors.lightTextPrimary,
        // Düz ve modern görünüm için gölge yüksekliği sıfırlanır
        elevation: 0,
        // Başlık metnini yatayda ortalar
        centerTitle: true,
      ),
      // Kart (Card) bileşenlerinin genel tasarım kuralları
      cardTheme: CardThemeData(
        // Kart arka plan rengi
        color: AppColors.lightSurface,
        // Kart gölge derinliği
        elevation: 1,
        // Kart köşe yuvarlaklığı ve sınır çizgisi stili
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightCardBorder),
        ),
      ),
      // Yükseltilmiş butonların (ElevatedButton) genel tasarım kuralları
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // Buton arka plan rengi (Mavi)
          backgroundColor: AppColors.primaryBlue,
          // Buton üzerindeki yazı ve ikon rengi (Beyaz)
          foregroundColor: Colors.white,
          // Düz şık görünüm için gölgesiz yapı
          elevation: 0,
          // Buton içi dolgu boşlukları (yatay 20, dikey 14)
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          // Buton köşe kavisi (12px)
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          // Buton yazı tipi kalınlığı ve boyutu
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      // Metin giriş alanlarının (TextField / TextFormField) tasarım kuralları
      inputDecorationTheme: InputDecorationTheme(
        // Arka planın dolgulu olmasını sağlar
        filled: true,
        // Metin kutusu içi dolgu rengi
        fillColor: Colors.white,
        // Varsayılan kenarlık stili
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightCardBorder),
        ),
        // Etkin (odaklanılmamış) durumdaki kenarlık stili
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightCardBorder),
        ),
        // Odaklanılmış (aktif yazılan) durumdaki mavi kenarlık stili
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
      ),
    );
  }

  /// Koyu Tema: Kırmızı Vurgulu ve Koyu Arka Planlı Tasarım
  static ThemeData get darkTheme {
    // Koyu temaya özgü Material 3 renk şeması tanımlaması
    const colorScheme = ColorScheme.dark(
      // Ana tema rengi: Kırmızı vurgu
      primary: AppColors.primaryRed,
      // Ana renk üzerindeki metin/ikon rengi: Saf beyaz
      onPrimary: Colors.white,
      // İkincil renk: Mavi
      secondary: AppColors.primaryBlue,
      // İkincil renk üzerindeki yazı rengi: Saf beyaz
      onSecondary: Colors.white,
      // Yüzey rengi: Gece grisi
      surface: AppColors.darkSurface,
      // Yüzey üzerindeki birincil metin rengi: Kırık beyaz
      onSurface: AppColors.darkTextPrimary,
      // Hata durum rengi: Parlak kırmızı
      error: AppColors.accentRed,
      // Hata rengi üzerindeki metin rengi: Saf beyaz
      onError: Colors.white,
    );

    // Koyu tema için ThemeData nesnesi inşa edilip döndürülür
    return ThemeData(
      // Material 3 tasarım standartlarını etkinleştirir
      useMaterial3: true,
      // Koyu renk paletini bağlar
      colorScheme: colorScheme,
      // Koyu mod arka plan rengi
      scaffoldBackgroundColor: AppColors.darkBackground,
      // Koyu mod AppBar ayarları
      appBarTheme: const AppBarTheme(
        // Üst çubuğun koyu yüzey rengi
        backgroundColor: AppColors.darkSurface,
        // Üst çubuk metin rengi
        foregroundColor: AppColors.darkTextPrimary,
        // Gölge derinliği sıfır
        elevation: 0,
        // Başlığı ortala
        centerTitle: true,
      ),
      // Koyu mod kart tasarım ayarları
      cardTheme: CardThemeData(
        // Koyu kart rengi
        color: AppColors.darkCard,
        // Düz kart gölgesi
        elevation: 0,
        // Koyu kart kenarlık ve sınır çizgisi
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkCardBorder),
        ),
      ),
      // Koyu mod buton tasarım ayarları
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // Koyu mod buton arka planı (Kırmızı)
          backgroundColor: AppColors.primaryRed,
          // Buton yazı rengi (Beyaz)
          foregroundColor: Colors.white,
          // Gölgesiz düz yapı
          elevation: 0,
          // Buton iç boşluğu
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          // Köşe yuvarlaklığı
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          // Yazı stili
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      // Koyu mod metin girdi kutusu tasarım ayarları
      inputDecorationTheme: InputDecorationTheme(
        // Kutunun içini doldur
        filled: true,
        // Koyu kutu içi dolgu rengi
        fillColor: AppColors.darkCard,
        // Varsayılan sınır çizgisi
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkCardBorder),
        ),
        // Boştayken kenarlık stili
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkCardBorder),
        ),
        // Odaklanıldığında kırmızı parlayan kenarlık stili
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 2),
        ),
      ),
    );
  }
}
