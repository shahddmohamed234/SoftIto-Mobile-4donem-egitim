// ValueNotifier ve ChangeNotifier temel sınıflarını içeri aktarır
import 'package:flutter/foundation.dart';
// Kullanıcı veri modelini içeri aktarır
import '../../data/models/user_model.dart';
// Sahte kimlik doğrulama veri deposunu içeri aktarır
import '../../data/repositories/mock_auth_repository.dart';

/// AuthController: Kimlik doğrulama ekranının reaktif durumlarını (state)
/// ValueNotifier mekanizmasıyla yöneten kontrolcü sınıfıdır.
class AuthController {
  // Veri katmanı deposuna referans (Singleton nesnesi)
  final MockAuthRepository _repository = MockAuthRepository.instance;

  // Yükleme durumu bildirimcisi (Dönme animasyonu / CircularProgressIndicator kontrolü)
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // Olası hata mesajı bildirimcisi (Hata varsa metin, yoksa null tutar)
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  // Aktif doğrulanmış kullanıcı nesnesi bildirimcisi
  final ValueNotifier<UserModel?> currentUser = ValueNotifier<UserModel?>(MockAuthRepository.instance.currentUser);

  /// Kullanıcının telefonuna SMS doğrulama kodu gönderim isteğini tetikler
  Future<bool> requestSmsVerification(String phoneNumber) async {
    // İşlem başladığı için yükleniyor bayrağını aktif et
    isLoading.value = true;
    // Önceki hata mesajını temizle
    errorMessage.value = null;
    try {
      // Depo üzerinden SMS kodu gönderimini simüle et
      final success = await _repository.sendSmsCode(phoneNumber);
      // İşlem tamamlandığında yükleniyor bayrağını kapat
      isLoading.value = false;
      // Sonucu döndür
      return success;
    } catch (e) {
      // Hata oluşursa kullanıcıya gösterilecek mesajı ata
      errorMessage.value = 'SMS kodu gönderilemedi: $e';
      // Yükleniyor durumunu kapat
      isLoading.value = false;
      // Başarısızlık dön
      return false;
    }
  }

  /// SMS kodunu (Test kodu: 1234) doğrular ve oturum açma işlemini tamamlar
  Future<bool> verifyAndLogin(UserModel user, String smsCode) async {
    // Doğrulama başladığı için yükleniyor durumunu aktif et
    isLoading.value = true;
    // Önceki hatayı sıfırla
    errorMessage.value = null;
    try {
      // Depo üzerinden kod ve kullanıcı eşleştirmesini yap
      final success = await _repository.verifySmsAndLogin(user: user, smsCode: smsCode);
      // Kod doğruysa
      if (success) {
        // Oturumu açılan kullanıcıyı kontrolcüde güncelle
        currentUser.value = _repository.currentUser;
      } else {
        // Hatalı kod uyarısını kaydet
        errorMessage.value = 'Hatalı SMS doğrulama kodu! (Test Kodu: 1234)';
      }
      // Yükleniyor durumunu kapat
      isLoading.value = false;
      // Başarı durumunu döndür
      return success;
    } catch (e) {
      // Beklenmeyen bir hata oluşursa hata mesajını set et
      errorMessage.value = 'Giriş sırasında hata oluştu: $e';
      // Yükleniyor durumunu kapat
      isLoading.value = false;
      // Başarısızlık dön
      return false;
    }
  }

  /// Kullanıcı oturumunu kapatır ve ana login kapısına döndürür
  Future<void> logout() async {
    // Depo katmanındaki oturumu sonlandır
    await _repository.logout();
    // Kontrolcüdeki kullanıcı nesnesini sıfırla
    currentUser.value = null;
  }

  /// Bellek sızıntılarını önlemek için ValueNotifier dinleyicilerini serbest bırakır
  void dispose() {
    // Yükleniyor bildirimcisini bellekten at
    isLoading.dispose();
    // Hata bildirimcisini bellekten at
    errorMessage.dispose();
    // Kullanıcı bildirimcisini bellekten at
    currentUser.dispose();
  }
}
