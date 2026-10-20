// Flutter temel widget ve arayüz yapı taşlarını içeri aktarır
import 'package:flutter/material.dart';
// Açık ve koyu tema tanımlamalarını içeri aktarır
import 'core/theme/app_theme.dart';
// Dinamik tema yönetim kontrolcüsünü içeri aktarır
import 'core/theme/theme_controller.dart';
// Sahte kimlik doğrulama deposunu içeri aktarır
import 'features/auth/data/repositories/mock_auth_repository.dart';
// Kimlik doğrulama ve SMS kontrolcüsünü içeri aktarır
import 'features/auth/presentation/controllers/auth_controller.dart';
// İlk açılışta zorunlu olan giriş ekranını içeri aktarır
import 'features/auth/presentation/pages/login_screen.dart';
// Ana sayfa araç ve istasyon kontrolcüsünü içeri aktarır
import 'features/home/presentation/controllers/home_controller.dart';
// Araç kiralama ve arama ekranını içeri aktarır
import 'features/home/presentation/pages/home_screen.dart';
// Kullanıcı profil ve SSS kontrolcüsünü içeri aktarır
import 'features/profile/presentation/controllers/profile_controller.dart';
// Profil bilgileri ve ayarlar ekranını içeri aktarır
import 'features/profile/presentation/pages/profile_screen.dart';
// Rezervasyon takibi kontrolcüsünü içeri aktarır
import 'features/reservations/presentation/controllers/reservations_controller.dart';
// Rezervasyonlarım ve süre uzatma ekranını içeri aktarır
import 'features/reservations/presentation/pages/reservations_screen.dart';

/// main: Uygulamanın işletim sistemi tarafından ilk çağrılan başlangıç noktasıdır.
void main() {
  // Flutter motoru ve widget bağlayıcılarının başlatıldığından emin olur
  WidgetsFlutterBinding.ensureInitialized();
  // Kök uygulama widget'ını ayağa kaldırır ve ekrana basar
  runApp(const EasyRentApp());
}

/// EasyRentApp: Kök uygulama widget'ı.
/// ThemeController'ı dinleyerek anlık tema değişimini sağlar.
class EasyRentApp extends StatelessWidget {
  // Sabit kurucu metot
  const EasyRentApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Tema modu değişimini dinleyen ve MaterialApp'i yeniden çizen reaktif builder
    return ValueListenableBuilder<ThemeMode>(
      // Dinlenecek olan tema durumu bildirimcisi
      valueListenable: ThemeController.instance.themeModeNotifier,
      // Değer her değiştiğinde çağrılan yapılandırıcı fonksiyon
      builder: (context, themeMode, _) {
        // Flutter ana uygulama çerçevesi
        return MaterialApp(
          // Uygulama başlığı
          title: 'EasyRent',
          // Sağ üstteki hata ayıklama (DEBUG) bandını gizler
          debugShowCheckedModeBanner: false,
          // Mavi ağırlıklı ferah açık tema
          theme: AppTheme.lightTheme,
          // Kırmızı vurgulu koyu tema
          darkTheme: AppTheme.darkTheme,
          // Anlık olarak seçili olan tema modu (Açık veya Koyu)
          themeMode: themeMode,
          // Uygulamanın açılış sayfası (Kimlik doğrulama kapısı)
          home: const AppRootView(),
        );
      },
    );
  }
}

/// AppRootView: Kimlik doğrulama kapısı (Auth Gate) ve ana navigasyon kabuğunu yönetir.
/// Kullanıcı oturum açmadığı sürece LoginScreen dışında hiçbir ekrana geçit vermez.
class AppRootView extends StatefulWidget {
  // Sabit kurucu metot
  const AppRootView({super.key});

  @override
  State<AppRootView> createState() => _AppRootViewState();
}

class _AppRootViewState extends State<AppRootView> {
  // Kimlik doğrulama modülü kontrolcüsü örneği
  final AuthController _authController = AuthController();
  // Ana sayfa modülü kontrolcüsü örneği
  final HomeController _homeController = HomeController();
  // Rezervasyonlar modülü kontrolcüsü örneği
  final ReservationsController _reservationsController = ReservationsController();
  // Profil modülü kontrolcüsü örneği
  final ProfileController _profileController = ProfileController();

  // Alt gezinme çubuğundaki aktif sekme indeksini tutan reaktif bildirimci (0: Araçlar)
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  // Oturum açılma durumunu tutan bildirimci (Başlangıçta oturum kapalıdır - Zorunlu Login)
  final ValueNotifier<bool> _isLoggedIn = ValueNotifier<bool>(MockAuthRepository.instance.isLoggedIn);

  @override
  void dispose() {
    // Bellek sızıntısını önlemek için auth controller'ı bellekten temizler
    _authController.dispose();
    // Home controller kaynaklarını serbest bırakır
    _homeController.dispose();
    // Rezervasyon controller kaynaklarını serbest bırakır
    _reservationsController.dispose();
    // Profil controller kaynaklarını serbest bırakır
    _profileController.dispose();
    // İndeks bildirimcisini sonlandırır
    _currentIndex.dispose();
    // Giriş durumu bildirimcisini sonlandırır
    _isLoggedIn.dispose();
    // Üst sınıfın dispose metodunu çağırır
    super.dispose();
  }

  /// Giriş başarılı olduğunda ana kabuğa yönlendiren geri çağırım metodu
  void _onLoginSuccess() {
    // Giriş durumunu doğru (true) olarak günceller
    _isLoggedIn.value = true;
    // Giriş yapan kullanıcının profil ve kurallarını yükler
    _profileController.init();
  }

  /// Çıkış yapıldığında oturumu kapatıp doğrudan LoginScreen'e döndüren metot
  void _onLogout() {
    // Oturum durumunu kapalı (false) yapar
    _isLoggedIn.value = false;
    // Sekme indeksini başlangıç sekmesine (0) sıfırlar
    _currentIndex.value = 0;
  }

  // 40 satır kuralına uygun ana build metodu (Auth Gate)
  @override
  Widget build(BuildContext context) {
    // Kullanıcının oturum açma durumunu canlı dinleyen builder
    return ValueListenableBuilder<bool>(
      // Dinlenen oturum durumu
      valueListenable: _isLoggedIn,
      // Duruma göre ilgili widget'ı inşa eder
      builder: (context, loggedIn, _) {
        // Kullanıcı henüz giriş yapmamışsa ZORUNLU olarak LoginScreen gösterilir
        if (!loggedIn) {
          return LoginScreen(
            // Kimlik doğrulama kontrolcüsü
            authController: _authController,
            // Giriş başarılı olursa çalışacak tetikleyici fonksiyon
            onLoginSuccess: _onLoginSuccess,
          );
        }
        // Giriş yapılmışsa ana gezinti kabuğunu (Scaffold + BottomBar) açar
        return _buildShellScaffold();
      },
    );
  }

  /// 3 sekmeli ana navigasyon kabuğu (Araçlar, Rezervasyonlarım, Profilim)
  Widget _buildShellScaffold() {
    // Aktif sekme değişimlerini dinler
    return ValueListenableBuilder<int>(
      // Dinlenen sekme indeksi
      valueListenable: _currentIndex,
      // Yeni sekme çizimi
      builder: (context, index, _) {
        return Scaffold(
          // Sayfa durumlarını bellekte koruyarak geçiş sağlayan yığın yapısı
          body: IndexedStack(
            // Görüntülenecek aktif sayfa indeksi
            index: index,
            // Sayfa listesi
            children: [
              // 0. Sekme: Ana Sayfa ve Araç Listesi
              HomeScreen(
                controller: _homeController,
                // Kiralama bitince rezervasyon sekmesine yönlendirir
                onNavigateToReservations: () => _currentIndex.value = 1,
              ),
              // 1. Sekme: Rezervasyonlarım ve Kiralama Takibi
              ReservationsScreen(controller: _reservationsController),
              // 2. Sekme: Profil, SSS ve Ayarlar
              ProfileScreen(
                controller: _profileController,
                onLogout: _onLogout,
              ),
            ],
          ),
          // Alt gezinti çubuğu (Material 3 NavigationBar)
          bottomNavigationBar: NavigationBar(
            // Seçili olan buton indeksi
            selectedIndex: index,
            // Sekmeye tıklandığında indeksi günceller
            onDestinationSelected: (newIndex) => _currentIndex.value = newIndex,
            // Sekme butonlarının tanımları
            destinations: const [
              // Araçlar sekmesi butonu
              NavigationDestination(
                icon: Icon(Icons.directions_car_outlined),
                selectedIcon: Icon(Icons.directions_car),
                label: 'Araçlar',
              ),
              // Rezervasyonlarım sekmesi butonu
              NavigationDestination(
                icon: Icon(Icons.bookmark_outline),
                selectedIcon: Icon(Icons.bookmark),
                label: 'Rezervasyonlarım',
              ),
              // Profilim sekmesi butonu
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profilim',
              ),
            ],
          ),
        );
      },
    );
  }
}
