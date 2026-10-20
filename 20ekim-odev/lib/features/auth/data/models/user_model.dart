import 'package:flutter/foundation.dart';

/// UserModel: Araç kiralama için zorunlu olan sürücü kimlik ve ehliyet bilgilerini temsil eder.
@immutable
class UserModel {
  // 11 haneli T.C. Kimlik veya Pasaport Numarası
  final String tckn;
  // Sürücünün tam adı ve soyadı
  final String fullName;
  // Sürücünün doğum tarihi (GG.AA.YYYY)
  final String birthDate;
  // Sürücü belgesi seri/belge numarası
  final String licenseNumber;
  // SMS doğrulaması yapılacak cep telefonu numarası
  final String phoneNumber;
  // 4 haneli SMS kodu ile doğrulanıp onaylandığını belirten durum bayrağı
  final bool isVerified;

  const UserModel({
    required this.tckn,
    required this.fullName,
    required this.birthDate,
    required this.licenseNumber,
    required this.phoneNumber,
    this.isVerified = false,
  });

  /// İmmutable nesnede istenen alanları güncelleyerek yeni kopya üretir.
  UserModel copyWith({
    String? tckn,
    String? fullName,
    String? birthDate,
    String? licenseNumber,
    String? phoneNumber,
    bool? isVerified,
  }) {
    return UserModel(
      tckn: tckn ?? this.tckn,
      fullName: fullName ?? this.fullName,
      birthDate: birthDate ?? this.birthDate,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
