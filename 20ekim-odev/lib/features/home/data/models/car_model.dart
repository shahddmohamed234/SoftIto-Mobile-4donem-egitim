import 'package:flutter/foundation.dart';

/// Fiyatlandırma ve kiralama tarifesi seçenekleri
enum PricingType { daily, weekly, monthly }

/// CarModel: Kiralık araç özelliklerini, günlük/haftalık/aylık fiyatlarını
/// ve müsaitlik durumunu tutan veri modelidir.
@immutable
class CarModel {
  // Benzersiz araç kimliği
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
  // Koltuk / Yolcu kapasitesi
  final int seats;
  // Günlük kiralama birim fiyatı (TL)
  final double dailyRate;
  // Haftalık paket kiralama fiyatı (TL - 7 günlük)
  final double weeklyRate;
  // Aylık paket kiralama fiyatı (TL - 30 günlük)
  final double monthlyRate;
  // Aracın anlık müsaitlik durumu
  final bool isAvailable;
  // Aracın bulunduğu teslim/iade istasyonu adı
  final String stationName;
  // Görsel bağlantısı veya varlık yolu
  final String imageUrl;

  const CarModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.fuelType,
    required this.transmission,
    required this.seats,
    required this.dailyRate,
    required this.weeklyRate,
    required this.monthlyRate,
    this.isAvailable = true,
    required this.stationName,
    this.imageUrl = '',
  });

  /// Seçili tarifeye göre birim fiyat etiketini döner
  String getRateLabel(PricingType type) {
    switch (type) {
      case PricingType.daily:
        return '₺${dailyRate.toStringAsFixed(0)} / Gün';
      case PricingType.weekly:
        return '₺${weeklyRate.toStringAsFixed(0)} / Hafta';
      case PricingType.monthly:
        return '₺${monthlyRate.toStringAsFixed(0)} / Ay';
    }
  }

  /// Seçili tarifeye (Günlük, Haftalık, Aylık) ve gün sayısına göre
  /// DOĞRU toplam kiralama tutarını hesaplar.
  double calculateTotal({required PricingType type, required int days}) {
    final validDays = days > 0 ? days : 1;

    switch (type) {
      case PricingType.daily:
        // Günlük tarifede seçilen gün sayısı ile günlük ücret çarpılır
        return dailyRate * validDays;

      case PricingType.weekly:
        // Haftalık tarifede haftalık avantajlı paket baz alınır
        if (validDays <= 7) {
          return weeklyRate;
        }
        final weeks = validDays ~/ 7;
        final remainingDays = validDays % 7;
        return (weeks * weeklyRate) + (remainingDays * (weeklyRate / 7.0));

      case PricingType.monthly:
        // Aylık tarifede 30 günlük avantajlı paket baz alınır
        if (validDays <= 30) {
          return monthlyRate;
        }
        final months = validDays ~/ 30;
        final remainingDays = validDays % 30;
        return (months * monthlyRate) + (remainingDays * (monthlyRate / 30.0));
    }
  }
}
