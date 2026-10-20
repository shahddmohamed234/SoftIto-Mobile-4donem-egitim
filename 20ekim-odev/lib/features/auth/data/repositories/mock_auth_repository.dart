import '../models/user_model.dart';

/// MockAuthRepository: Uygulama açılışında kullanıcı kimlik doğrulama,
/// ehliyet kontrolü ve SMS doğrulama işlemlerini simüle eden yerel depo sınıfıdır.
class MockAuthRepository {
  // Singleton deseni: Tüm uygulama boyunca tek bir kimlik oturumu yönetilir.
  static final MockAuthRepository instance = MockAuthRepository._();
  MockAuthRepository._();

  // Kural gereği başlangıçta oturum kapalıdır (null).
  // Böylece uygulama ilk açıldığında doğrudan Login ekranı karşılar.
  UserModel? _currentUser;

  /// Aktif giriş yapmış kullanıcı nesnesini döner.
  UserModel? get currentUser => _currentUser;

  /// Kullanıcının giriş yapıp yapmadığını ve SMS onayından geçip geçmediğini kontrol eder.
  bool get isLoggedIn => _currentUser != null && _currentUser!.isVerified;

  /// Verilen telefon numarasına sahte 4 haneli SMS kodu gönderimini simüle eder.
  Future<bool> sendSmsCode(String phoneNumber) async {
    // 600 ms ağ gecikmesi simülasyonu
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }

  /// Kullanıcının girdiği 4 haneli SMS kodunu (Test kodu: 1234) doğrular.
  /// Kod doğru ise kullanıcı onaylı hale getirilir ve oturum açılır.
  Future<bool> verifySmsAndLogin({
    required UserModel user,
    required String smsCode,
  }) async {
    // 700 ms doğrulama gecikmesi simülasyonu
    await Future.delayed(const Duration(milliseconds: 700));

    // Belirlenen standart test doğrulama kodu: "1234"
    if (smsCode == '1234') {
      _currentUser = user.copyWith(isVerified: true);
      return true;
    }
    return false;
  }

  /// Aktif kullanıcı oturumunu kapatır ve oturumu sıfırlar.
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }
}
