// Değişmezlik anotasyonu için temel Flutter kütüphanesini içeri aktarır
import 'package:flutter/foundation.dart';

/// Rezervasyonun anlık yaşam döngüsü durumları (Aktif, Onay Bekliyor, Tamamlandı)
enum ReservationStatus { active, pending, completed }

/// ReservationModel: Kiralanan aracın rezervasyon bilgilerini,
/// geri teslimat tarihlerini, HGS ve ceza borçlarını tutan modeldir.
@immutable
class ReservationModel {
  // Benzersiz rezervasyon takip numarası (örn: REZ-1049)
  final String id;

  // Kiralanan aracın marka ve modeli (örn: Mercedes C200)
  final String carModel;

  // Aracın teslim edileceği istasyon adı (örn: İST Havalimanı Şube)
  final String stationName;

  // Kiralama başlangıç tarihi ve saati
  final DateTime startDate;

  // Kiralama bitiş ve geri teslimat tarihi
  final DateTime endDate;

  // Rezervasyonun mevcut durumu (active, pending, completed)
  final ReservationStatus status;

  // Başlangıçta ödenen toplam kiralama bedeli (Türk Lirası)
  final double totalAmount;

  // Otoyol/Köprü HGS geçiş borcu olup olmadığını belirten bayrak
  final bool hasHgsPenalty;

  // Varsa toplam HGS borç tutarı (TL)
  final double hgsAmount;

  // Gecikmeli teslimat ceza tutarı (TL)
  final double latePenaltyAmount;

  // Başlangıç kiralama ödemesinin tamamlanıp tamamlanmadığı
  final bool isPaid;

  // ReservationModel sabit kurucu metodu
  const ReservationModel({
    // Takip no zorunludur
    required this.id,
    // Araç modeli zorunludur
    required this.carModel,
    // İstasyon adı zorunludur
    required this.stationName,
    // Başlangıç tarihi zorunludur
    required this.startDate,
    // Bitiş tarihi zorunludur
    required this.endDate,
    // Durum zorunludur
    required this.status,
    // Toplam tutar zorunludur
    required this.totalAmount,
    // HGS borcu varsayılan olarak yoktur
    this.hasHgsPenalty = false,
    // HGS tutarı varsayılan olarak 0.0 TL'dir
    this.hgsAmount = 0.0,
    // Geç teslimat cezası varsayılan olarak 0.0 TL'dir
    this.latePenaltyAmount = 0.0,
    // Kiralama ücreti varsayılan olarak ödenmiştir
    this.isPaid = true,
  });

  /// Varsa HGS ve gecikme cezası toplamını hesaplayan getter
  double get totalExtraPenalties => hgsAmount + latePenaltyAmount;

  /// Geri teslimata kalan süreyi hesaplayıp gün ve saat olarak biçimlendiren getter
  String get remainingTimeText {
    // Şimdiki zaman damgası
    final now = DateTime.now();
    // Bitiş tarihi geçmişse teslim süresinin bittiğini bildir
    if (endDate.isBefore(now)) {
      return 'Teslim süresi doldu';
    }
    // İki tarih arasındaki fark
    final difference = endDate.difference(now);
    // Kalan tam gün sayısı
    final days = difference.inDays;
    // Kalan saat (24 saat moduna göre)
    final hours = difference.inHours % 24;
    // Okunabilir metin çıktısı
    return '$days Gün $hours Saat Kaldı';
  }

  /// İmmutable modelin istenen alanlarını güncelleyerek yeni kopyasını üretir
  ReservationModel copyWith({
    String? id,
    String? carModel,
    String? stationName,
    DateTime? startDate,
    DateTime? endDate,
    ReservationStatus? status,
    double? totalAmount,
    bool? hasHgsPenalty,
    double? hgsAmount,
    double? latePenaltyAmount,
    bool? isPaid,
  }) {
    return ReservationModel(
      // id değerini güncelle veya mevcut olanı koru
      id: id ?? this.id,
      // Araç modelini güncelle veya mevcut olanı koru
      carModel: carModel ?? this.carModel,
      // İstasyonu güncelle veya mevcut olanı koru
      stationName: stationName ?? this.stationName,
      // Başlangıç tarihini güncelle veya koru
      startDate: startDate ?? this.startDate,
      // Bitiş tarihini güncelle veya koru
      endDate: endDate ?? this.endDate,
      // Durumu güncelle veya koru
      status: status ?? this.status,
      // Toplam tutarı güncelle veya koru
      totalAmount: totalAmount ?? this.totalAmount,
      // HGS bayrağını güncelle veya koru
      hasHgsPenalty: hasHgsPenalty ?? this.hasHgsPenalty,
      // HGS tutarını güncelle veya koru
      hgsAmount: hgsAmount ?? this.hgsAmount,
      // Ceza tutarını güncelle veya koru
      latePenaltyAmount: latePenaltyAmount ?? this.latePenaltyAmount,
      // Ödeme durumunu güncelle veya koru
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
