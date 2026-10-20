import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  final String name;
  final String email;
  final String startupName;
  final String role;
  final String accountType; // 'Girişimci' veya 'Yatırımcı'
  final String phone;
  final bool isVerified;

  const UserProfile({
    required this.name,
    required this.email,
    required this.startupName,
    required this.role,
    this.accountType = 'Girişimci',
    this.phone = '+90 532 555 0123',
    required this.isVerified,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String,
      email: json['email'] as String,
      startupName: json['startupName'] as String,
      role: json['role'] as String,
      accountType: json['accountType'] as String? ?? 'Girişimci',
      phone: json['phone'] as String? ?? '+90 532 555 0123',
      isVerified: json['isVerified'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'startupName': startupName,
      'role': role,
      'accountType': accountType,
      'phone': phone,
      'isVerified': isVerified,
    };
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? startupName,
    String? role,
    String? accountType,
    String? phone,
    bool? isVerified,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      startupName: startupName ?? this.startupName,
      role: role ?? this.role,
      accountType: accountType ?? this.accountType,
      phone: phone ?? this.phone,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
