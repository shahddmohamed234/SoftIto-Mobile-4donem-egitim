import 'package:flutter/foundation.dart';

/// Rezervasyonun anlık yaşam döngüsü durumları
enum ReservationStatus { active, pending, completed }

/// ReservationModel: Kiralanan aracın rezervasyon bilgilerini,
/// geri teslimat tarihlerini, HGS ve ceza borçlarını tutan modeldir.
@immutable
class ReservationModel {
  // Benzersiz rezervasyon takip numarası (örn: REZ-1049)
  final String id;
  // Kiralanan aracın marka ve modeli
  final String carModel;
  // Aracın teslim edileceği istasyon adı
  final String stationName;
  // Kiralama başlangıç tarihi
  final DateTime startDate;
  // Kiralama bitiş / geri teslimat tarihi
  final DateTime endDate;
  // Rezervasyon durumu (Aktif, Onay Bekliyor, Tamamlandı)
  final ReservationStatus status;
  // Ödenen toplam kiralama bedeli (TL)
  final double totalAmount;
  // Otoyol/Köprü HGS geçiş borcu var mı?
  final bool hasHgsPenalty;
  // Toplam HGS borç tutarı (TL)
  final double hgsAmount;
  // Gecikmeli teslimat ceza tutarı (TL)
  final double latePenaltyAmount;
  // Başlangıç kiralama ödemesinin tamamlanıp tamamlanmadığı
  final bool isPaid;

  const ReservationModel({
    required this.id,
    required this.carModel,
    required this.stationName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.totalAmount,
    this.hasHgsPenalty = false,
    this.hgsAmount = 0.0,
    this.latePenaltyAmount = 0.0,
    this.isPaid = true,
  });

  /// Varsa HGS ve gecikme cezası toplamını hesaplar
  double get totalExtraPenalties => hgsAmount + latePenaltyAmount;

  /// Geri teslimata kalan süreyi gün ve saat olarak metinleştirir
  String get remainingTimeText {
    final now = DateTime.now();
    if (endDate.isBefore(now)) {
      return 'Teslim süresi doldu';
    }
    final difference = endDate.difference(now);
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    return '$days Gün $hours Saat Kaldı';
  }

  /// Yeni kopyasını üretir
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
      id: id ?? this.id,
      carModel: carModel ?? this.carModel,
      stationName: stationName ?? this.stationName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      hasHgsPenalty: hasHgsPenalty ?? this.hasHgsPenalty,
      hgsAmount: hgsAmount ?? this.hgsAmount,
      latePenaltyAmount: latePenaltyAmount ?? this.latePenaltyAmount,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
