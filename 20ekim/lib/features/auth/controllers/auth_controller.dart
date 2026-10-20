import 'package:flutter/foundation.dart';
import '../models/user_profile_model.dart';

class AuthController {
  final ValueNotifier<bool> _isLoggedIn = ValueNotifier<bool>(true);
  final ValueNotifier<UserProfile> _currentUser =
      ValueNotifier<UserProfile>(const UserProfile(
    name: 'Ahmet Yılmaz',
    email: 'ahmet@future-entrepreneur.com',
    startupName: 'TechVision AI Çözümleri',
    role: 'Kurucu Ortak & CEO',
    accountType: 'Girişimci',
    phone: '+90 532 555 0123',
    isVerified: true,
  ));

  ValueNotifier<bool> get isLoggedIn => _isLoggedIn;
  ValueNotifier<UserProfile> get currentUser => _currentUser;

  void loginAsEntrepreneur({
    required String name,
    required String email,
    required String startupName,
  }) {
    _currentUser.value = UserProfile(
      name: name.isNotEmpty ? name : 'Girişimci Kullanıcı',
      email: email.isNotEmpty ? email : 'girisimci@startup.com',
      startupName: startupName.isNotEmpty ? startupName : 'Girişim Projesi',
      role: 'Kurucu Ortak & CEO',
      accountType: 'Girişimci',
      phone: '+90 532 555 0123',
      isVerified: true,
    );
    _isLoggedIn.value = true;
  }

  void loginAsInvestor({
    required String name,
    required String email,
    required String fundName,
  }) {
    _currentUser.value = UserProfile(
      name: name.isNotEmpty ? name : 'Yatırımcı Kullanıcı',
      email: email.isNotEmpty ? email : 'yatirimci@angelvc.com',
      startupName: fundName.isNotEmpty ? fundName : 'İstanbul Melek Yatırım Ağı',
      role: 'Melek Yatırımcı / Portföy Yöneticisi',
      accountType: 'Yatırımcı',
      phone: '+90 532 888 0456',
      isVerified: true,
    );
    _isLoggedIn.value = true;
  }

  void logout() {
    _isLoggedIn.value = false;
  }

  void updateProfile({String? startupName, String? role, String? phone}) {
    _currentUser.value = _currentUser.value.copyWith(
      startupName: startupName,
      role: role,
      phone: phone,
    );
  }

  void dispose() {
    _isLoggedIn.dispose();
    _currentUser.dispose();
  }
}
