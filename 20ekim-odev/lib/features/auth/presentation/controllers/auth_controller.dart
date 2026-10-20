import 'package:flutter/foundation.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/mock_auth_repository.dart';

/// AuthController: Kimlik doğrulama ekranının reaktif durumlarını (state)
/// ValueNotifier mekanizmasıyla yöneten kontrolcü sınıfıdır.
class AuthController {
  // Veri katmanı deposu erişimi
  final MockAuthRepository _repository = MockAuthRepository.instance;

  // Yükleme durumu bildirimcisi (Dönme animasyonu kontrolü)
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // Olası hata mesajı bildirimcisi
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  // Aktif doğrulanmış kullanıcı nesnesi bildirimcisi
  final ValueNotifier<UserModel?> currentUser = ValueNotifier<UserModel?>(MockAuthRepository.instance.currentUser);

  /// Kullanıcının telefonuna SMS doğrulama kodu gönderir.
  Future<bool> requestSmsVerification(String phoneNumber) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final success = await _repository.sendSmsCode(phoneNumber);
      isLoading.value = false;
      return success;
    } catch (e) {
      errorMessage.value = 'SMS kodu gönderilemedi: $e';
      isLoading.value = false;
      return false;
    }
  }

  /// SMS kodunu (1234) doğrular ve oturum açma işlemini tamamlar.
  Future<bool> verifyAndLogin(UserModel user, String smsCode) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final success = await _repository.verifySmsAndLogin(user: user, smsCode: smsCode);
      if (success) {
        currentUser.value = _repository.currentUser;
      } else {
        errorMessage.value = 'Hatalı SMS doğrulama kodu! (Test Kodu: 1234)';
      }
      isLoading.value = false;
      return success;
    } catch (e) {
      errorMessage.value = 'Giriş sırasında hata oluştu: $e';
      isLoading.value = false;
      return false;
    }
  }

  /// Kullanıcı oturumunu kapatır ve ana login kapısına döndürür.
  Future<void> logout() async {
    await _repository.logout();
    currentUser.value = null;
  }

  /// Bellek sızıntılarını önlemek için ValueNotifier dinleyicilerini serbest bırakır.
  void dispose() {
    isLoading.dispose();
    errorMessage.dispose();
    currentUser.dispose();
  }
}
