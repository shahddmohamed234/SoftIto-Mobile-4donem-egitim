// Reaktif durum yönetimi için ValueNotifier sınıfını içeri aktarır
import 'package:flutter/foundation.dart';
// Kullanıcı veri modelini içeri aktarır
import 'package:easy_rent/features/auth/data/models/user_model.dart';
// Kimlik doğrulama veri deposunu içeri aktarır
import 'package:easy_rent/features/auth/data/repositories/mock_auth_repository.dart';
// SSS veri modelini içeri aktarır
import '../../data/models/faq_item_model.dart';
// Profil veri deposunu içeri aktarır
import '../../data/repositories/mock_profile_repository.dart';

/// ProfileController: Profil ekranındaki kullanıcı bilgileri, SSS ve oturum kapatma durumlarını yöneten kontrolcüdür.
class ProfileController {
  // Kimlik doğrulama deposu örneği
  final MockAuthRepository _authRepo = MockAuthRepository.instance;

  // Profil ve SSS veri deposu örneği
  final MockProfileRepository _profileRepo = MockProfileRepository.instance;

  // Giriş yapmış aktif kullanıcının bilgilerini tutan reaktif bildirimci
  final ValueNotifier<UserModel?> user = ValueNotifier<UserModel?>(MockAuthRepository.instance.currentUser);

  // Kiralama kuralları ve SSS listesini tutan reaktif bildirimci
  final ValueNotifier<List<FaqItemModel>> faqs = ValueNotifier<List<FaqItemModel>>([]);

  // Ekran verilerinin yüklenme durumunu bildiren reaktif bayrak
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  /// Profil ekranı açıldığında kullanıcıyı ve SSS kurallarını yükleyen başlatıcı metot
  Future<void> init() async {
    // Yükleniyor durumunu aktif et
    isLoading.value = true;
    // Güncel oturum açmış kullanıcıyı depodan al ve ata
    user.value = _authRepo.currentUser;
    // Sıkça sorulan soruları depodan asenkron olarak çek
    faqs.value = await _profileRepo.getFaqs();
    // Yükleme tamamlandığında bayrağı kapat
    isLoading.value = false;
  }

  /// Kullanıcının oturumunu güvenli bir şekilde kapatır
  Future<void> logout() async {
    // Depo katmanındaki oturumu sonlandırır
    await _authRepo.logout();
    // Kontrolcüdeki kullanıcı nesnesini sıfırlar
    user.value = null;
  }

  /// Bellek sızıntılarını önlemek için tüm ValueNotifier bildirimcilerini bellekten serbest bırakır
  void dispose() {
    // Kullanıcı bildirimcisini kapat
    user.dispose();
    // SSS bildirimcisini kapat
    faqs.dispose();
    // Yükleniyor bildirimcisini kapat
    isLoading.dispose();
  }
}
