// Flutter temel immutability (değişmezlik) anotasyonunu içeri aktarır
import 'package:flutter/foundation.dart';

/// UserModel: Araç kiralama için zorunlu olan sürücü kimlik ve ehliyet bilgilerini temsil eden veri modelidir.
@immutable
class UserModel {
  // 11 haneli T.C. Kimlik Numarası veya Pasaport Numarası
  final String tckn;

  // Sürücünün tam adı ve soyadı
  final String fullName;

  // Sürücünün doğum tarihi (GG.AA.YYYY formatında)
  final String birthDate;

  // Sürücü belgesi (ehliyet) seri ve belge numarası (Örn: B129845)
  final String licenseNumber;

  // SMS doğrulama kodu gönderilen cep telefonu numarası (Örn: 05551234567)
  final String phoneNumber;

  // 4 haneli SMS kodu ile doğrulanıp onaylandığını belirten durum bayrağı (True/False)
  final bool isVerified;

  // UserModel sınıfının sabit kurucu metodu
  const UserModel({
    // TCKN parametresi zorunludur
    required this.tckn,
    // Ad soyad parametresi zorunludur
    required this.fullName,
    // Doğum tarihi parametresi zorunludur
    required this.birthDate,
    // Ehliyet no parametresi zorunludur
    required this.licenseNumber,
    // Telefon numarası parametresi zorunludur
    required this.phoneNumber,
    // Doğrulanma durumu varsayılan olarak henüz onaylanmamıştır (false)
    this.isVerified = false,
  });

  /// İmmutable (değiştirilemez) nesnede istenen alanları güncelleyerek yeni bir kopya üretir.
  UserModel copyWith({
    // İsteğe bağlı yeni TCKN
    String? tckn,
    // İsteğe bağlı yeni Ad Soyad
    String? fullName,
    // İsteğe bağlı yeni Doğum Tarihi
    String? birthDate,
    // İsteğe bağlı yeni Ehliyet No
    String? licenseNumber,
    // İsteğe bağlı yeni Telefon Numarası
    String? phoneNumber,
    // İsteğe bağlı yeni Doğrulanma Durumu
    bool? isVerified,
  }) {
    // Verilen yeni değerlerle, yoksa mevcut değerlerle yeni bir UserModel döndürür
    return UserModel(
      // Yeni tckn varsa kullan, yoksa mevcut olanı koru
      tckn: tckn ?? this.tckn,
      // Yeni ad soyad varsa kullan, yoksa mevcut olanı koru
      fullName: fullName ?? this.fullName,
      // Yeni doğum tarihi varsa kullan, yoksa mevcut olanı koru
      birthDate: birthDate ?? this.birthDate,
      // Yeni ehliyet no varsa kullan, yoksa mevcut olanı koru
      licenseNumber: licenseNumber ?? this.licenseNumber,
      // Yeni telefon varsa kullan, yoksa mevcut olanı koru
      phoneNumber: phoneNumber ?? this.phoneNumber,
      // Yeni doğrulama durumu varsa kullan, yoksa mevcut olanı koru
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
