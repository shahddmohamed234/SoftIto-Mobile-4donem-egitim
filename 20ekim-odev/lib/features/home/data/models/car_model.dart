// İmmutable (değiştirilemez) model anotasyonu için Flutter temel kütüphanesini içeri aktarır
import 'package:flutter/foundation.dart';

/// Fiyatlandırma ve kiralama tarifesi seçenekleri (Günlük, Haftalık, Aylık)
enum PricingType { daily, weekly, monthly }

/// CarModel: Kiralık araç özelliklerini, günlük/haftalık/aylık fiyatlarını
/// ve müsaitlik durumunu tutan veri modelidir.
@immutable
class CarModel {
  // Benzersiz araç kimliği (örn: car-1)
  final String id;

  // Araç markası (örn: Fiat, Renault, Toyota, BMW)
  final String brand;

  // Araç modeli (örn: Egea, Clio, Corolla)
  final String model;

  // Model yılı (örn: 2024)
  final String year;

  // Yakıt türü (Benzin, Dizel, Hibrit, Elektrik)
  final String fuelType;

  // Vites türü (Otomatik, Manuel)
  final String transmission;

  // Koltuk ve yolcu kapasitesi (örn: 5)
  final int seats;

  // Günlük kiralama birim fiyatı (TL)
  final double dailyRate;

  // Haftalık paket kiralama fiyatı (TL - 7 günlük indirimli paket)
  final double weeklyRate;

  // Aylık paket kiralama fiyatı (TL - 30 günlük indirimli paket)
  final double monthlyRate;

  // Aracın anlık kiralanabilir müsaitlik durumu (true: Müsait, false: Dolu)
  final bool isAvailable;

  // Aracın bulunduğu teslim ve iade istasyonu adı
  final String stationName;

  // Görsel bağlantısı veya varlık yolu
  final String imageUrl;

  // CarModel sabit kurucu metodu
  const CarModel({
    // Araç ID'si zorunludur
    required this.id,
    // Marka zorunludur
    required this.brand,
    // Model zorunludur
    required this.model,
    // Yıl zorunludur
    required this.year,
    // Yakıt tipi zorunludur
    required this.fuelType,
    // Vites türü zorunludur
    required this.transmission,
    // Koltuk sayısı zorunludur
    required this.seats,
    // Günlük fiyat zorunludur
    required this.dailyRate,
    // Haftalık fiyat zorunludur
    required this.weeklyRate,
    // Aylık fiyat zorunludur
    required this.monthlyRate,
    // Müsaitlik varsayılan olarak aktiftir (true)
    this.isAvailable = true,
    // İstasyon adı zorunludur
    required this.stationName,
    // Görsel yolu varsayılan olarak boştur
    this.imageUrl = '',
  });

  /// Seçili tarifeye göre birim fiyat etiketini biçimlendirip döner
  String getRateLabel(PricingType type) {
    switch (type) {
      // Günlük tarife seçiliyse günlük fiyatı yazdır
      case PricingType.daily:
        return '₺${dailyRate.toStringAsFixed(0)} / Gün';
      // Haftalık tarife seçiliyse haftalık paket fiyatını yazdır
      case PricingType.weekly:
        return '₺${weeklyRate.toStringAsFixed(0)} / Hafta';
      // Aylık tarife seçiliyse aylık paket fiyatını yazdır
      case PricingType.monthly:
        return '₺${monthlyRate.toStringAsFixed(0)} / Ay';
    }
  }

  /// Seçili tarifeye (Günlük, Haftalık, Aylık) ve gün sayısına göre
  /// DOĞRU toplam kiralama tutarını hesaplar.
  double calculateTotal({required PricingType type, required int days}) {
    // Gün sayısının en az 1 olmasını garantiye alır
    final validDays = days > 0 ? days : 1;

    switch (type) {
      case PricingType.daily:
        // Günlük tarifede seçilen gün sayısı ile günlük ücret çarpılır
        return dailyRate * validDays;

      case PricingType.weekly:
        // 7 günden az ise müşteri aleyhine yüksek tutar çıkmaması için günlük fiyat uygulanır
        if (validDays < 7) {
          return dailyRate * validDays;
        }
        if (validDays == 7) {
          return weeklyRate;
        }
        // 7 günden fazla ise tam haftalar ve artık günler haftalık indirimli birim fiyattan hesaplanır
        final weeks = validDays ~/ 7;
        final remainingDays = validDays % 7;
        return (weeks * weeklyRate) + (remainingDays * (weeklyRate / 7.0));

      case PricingType.monthly:
        // 30 günden az ise en avantajlı haftalık veya günlük tarife baz alınır
        if (validDays < 30) {
          if (validDays >= 7) {
            final weeks = validDays ~/ 7;
            final remainingDays = validDays % 7;
            return (weeks * weeklyRate) + (remainingDays * (weeklyRate / 7.0));
          }
          return dailyRate * validDays;
        }
        if (validDays == 30) {
          return monthlyRate;
        }
        // 30 günden fazla ise tam aylar ve artık günler aylık avantajlı birim fiyattan hesaplanır
        final months = validDays ~/ 30;
        final remainingDays = validDays % 30;
        return (months * monthlyRate) + (remainingDays * (monthlyRate / 30.0));
    }
  }
}
