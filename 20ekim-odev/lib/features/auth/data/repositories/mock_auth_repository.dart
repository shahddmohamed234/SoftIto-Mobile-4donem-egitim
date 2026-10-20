// Kullanıcı modelini içeri aktarır
import '../models/user_model.dart';

/// MockAuthRepository: Uygulama açılışında kullanıcı kimlik doğrulama,
/// ehliyet kontrolü ve SMS doğrulama işlemlerini simüle eden yerel depo sınıfıdır.
class MockAuthRepository {
  // Singleton deseni: Tüm uygulama boyunca tek bir kimlik oturumu yönetilir
  static final MockAuthRepository instance = MockAuthRepository._();

  // Sınıfın dışarıdan doğrudan çağrılmasını engelleyen özel yapıcı metot
  MockAuthRepository._();

  // Kural gereği başlangıçta oturum kapalıdır (null).
  // Böylece uygulama ilk açıldığında zorunlu olarak Login ekranı karşılar.
  UserModel? _currentUser;

  /// Aktif giriş yapmış kullanıcı nesnesini döner
  UserModel? get currentUser => _currentUser;

  /// Kullanıcının giriş yapıp yapmadığını ve SMS onayından geçip geçmediğini kontrol eden getter
  bool get isLoggedIn => _currentUser != null && _currentUser!.isVerified;

  /// Verilen telefon numarasına sahte 4 haneli SMS kodu gönderimini simüle eder
  Future<bool> sendSmsCode(String phoneNumber) async {
    // 600 ms ağ iletişim gecikmesi simülasyonu
    await Future.delayed(const Duration(milliseconds: 600));
    // Kod başarıyla gönderildi olarak kabul edilir
    return true;
  }

  /// Kullanıcının girdiği 4 haneli SMS kodunu (Test kodu: 1234) doğrular.
  /// Kod doğru ise kullanıcı onaylı hale getirilir ve oturum açılır.
  Future<bool> verifySmsAndLogin({
    // Formdan gelen kullanıcı bilgileri
    required UserModel user,
    // Kullanıcının girdiği 4 haneli SMS doğrulama kodu
    required String smsCode,
  }) async {
    // 700 ms doğrulama sunucu gecikmesi simülasyonu
    await Future.delayed(const Duration(milliseconds: 700));

    // Belirlenen standart test doğrulama kodu: "1234"
    if (smsCode == '1234') {
      // Kullanıcı nesnesini isVerified: true yaparak oturuma kaydeder
      _currentUser = user.copyWith(isVerified: true);
      // Doğrulama başarılı sonucunu döndürür
      return true;
    }
    // Hatalı kod durumunda başarısızlık döner
    return false;
  }

  /// Aktif kullanıcı oturumunu kapatır ve oturumu sıfırlar
  Future<void> logout() async {
    // 300 ms çıkış işlemi gecikmesi simülasyonu
    await Future.delayed(const Duration(milliseconds: 300));
    // Aktif kullanıcı referansını boşa çıkarır
    _currentUser = null;
  }
}
