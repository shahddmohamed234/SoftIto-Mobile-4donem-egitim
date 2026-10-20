// İmmutable (değiştirilemez) anotasyonu için Flutter temel kütüphanesini içeri aktarır
import 'package:flutter/foundation.dart';

/// RentalStationModel: Araç teslim alma ve iade noktalarını, coğrafi koordinatlarını temsil eden modeldir.
@immutable
class RentalStationModel {
  // İstasyonun benzersiz kimlik kodu (örn: st-1)
  final String id;

  // İstasyonun adı (örn: İstanbul Havalimanı Şubesi)
  final String name;

  // İstasyonun bulunduğu ilçe veya bölge (örn: Arnavutköy)
  final String district;

  // İstasyonun açık adres tarifi
  final String address;

  // Haritada konumlandırma için enlem (latitude) değeri
  final double latitude;

  // Haritada konumlandırma için boylam (longitude) değeri
  final double longitude;

  // RentalStationModel sabit kurucu metodu
  const RentalStationModel({
    // İstasyon kimliği zorunludur
    required this.id,
    // İstasyon adı zorunludur
    required this.name,
    // İlçe bilgisi zorunludur
    required this.district,
    // Açık adres zorunludur
    required this.address,
    // Enlem koordinatı zorunludur
    required this.latitude,
    // Boylam koordinatı zorunludur
    required this.longitude,
  });
}
